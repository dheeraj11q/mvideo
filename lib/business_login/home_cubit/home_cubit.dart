import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/widgets.dart';
import 'package:mvideo/data/video_model.dart';
import 'package:mvideo/data/videos.dart';
import 'package:mvideo/presentation/common_widgets/snack_bar.dart';
import 'package:mvideo/services/encryption.dart';
import 'package:mvideo/services/local_notification_api.dart';
import 'package:mvideo/services/video_file_manager.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_player/video_player.dart';
import 'package:http/http.dart' as http;
part 'home_state.dart';

// https://stackoverflow.com/questions/59981337/how-can-i-encrypt-video-file-using-dart

enum Dir { enc, dec }

String videoUrl =
    "https://drive.google.com/uc?export=download&id=10chrCTHZV1Tw9xGbN5sKLma6IwrVNJ3T";

class HomeCubit extends Cubit<HomeState> {
  HomeCubit()
      : super(
          HomeState(
              videos: videos,
              flickManager: FlickManager(
                  videoPlayerController:
                      VideoPlayerController.network(videoUrl)),
              activeVideo: 0,
              isLoading: false,
              isDownloading: false,
              loacalVideoFiles: const [],
              storagePermission: true),
        );

  void videoLoad() {
    // state.flickManager?.flickControlManager?.pause();
    getLoaclVideos();
  }

  void videoItemPlay({required int index}) async {
    VideoModel? videoModel = state.videos![index];

    bool available =
        await isVideoAvailable(videoName: videoModel.name!, dir: Dir.enc);

    emit(state.copyWith(activeVideo: index));

    // if video file downloaded

    if (available) {
      bool availableDec =
          await isVideoAvailable(videoName: videoModel.name!, dir: Dir.dec);
      //< if video file decrypted
      if (availableDec) {
        Directory d = await VideoFileManager.getExternalVisibleDir("dec");
        state.flickManager?.handleChangeVideo(VideoPlayerController.file(
            File(d.path + "/${videoModel.name}.mp4")));
      } else {
        //< decrypt then play
        emit(state.copyWith(isLoading: true));
        await videoDecryptGetPath(videoModel.name!);
        // Directory d = await VideoFileManager.getExternalVisibleDir("dec");

        // state.flickManager?.handleChangeVideo(VideoPlayerController.file(
        //     File(d.path + "/${videoModel.name}.mp4")));
        // emit(state.copyWith(isLoading: false));
      }
    } else {
      state.flickManager
          ?.handleChangeVideo(VideoPlayerController.network(videoModel.url!));
    }
    emit(state.copyWith(
      flickManager: state.flickManager,
    ));
  }

  // <

  void decVideoPlay(name) async {
    Directory d = await VideoFileManager.getExternalVisibleDir("dec");

    state.flickManager?.handleChangeVideo(
        VideoPlayerController.file(File(d.path + "/$name.mp4")));
  }

//<
  Future<bool> isVideoAvailable(
      {required String videoName, required Dir dir}) async {
    Directory d = await VideoFileManager.getExternalVisibleDir(dir.name);
    var files = d.listSync();
    for (var file in files) {
      var fileNameWithEx = file.path.split("/").last;
      var justFileName = fileNameWithEx.split(".").first;

      if (videoName == justFileName) {
        return true;
      }
    }

    return false;
  }

  // < getlocal video files list

  void getLoaclVideos() async {
    List<String> localVideoNames = [];

    Directory d = await VideoFileManager.getExternalVisibleDir(Dir.enc.name);
    var files = d.listSync();
    for (var file in files) {
      var fileNameWithEx = file.path.split("/").last;
      var justFileName = fileNameWithEx.split(".").first;
      localVideoNames.add(justFileName);
    }

    emit(state.copyWith(loacalVideoFiles: localVideoNames));
  }

  // < video file download

  downloadVideo({required BuildContext conetxt, required int index}) async {
    if (await requestStoragePermission()) {
      VideoModel? videoModel = state.videos![index];
      emit(state.copyWith(isDownloading: true));
      // showing notification
      LocalNotificationApi.showNotification(
          id: index,
          title: videoModel.name,
          body: "Your video is downloading...");
      Directory d = await VideoFileManager.getExternalVisibleDir("enc");
      var resp = await http.get(Uri.parse(videoModel.url!));

      // < encrypt video with isolate thread
      var receiverPort = ReceivePort();

      Map<String, dynamic> data = {
        'port': receiverPort.sendPort,
        'data': resp.bodyBytes
      };
      await Isolate.spawn(
        encryptDataWithIsolate,
        data,
      );

      receiverPort.listen(
        (enResult) async {
          await VideoFileManager.writeData(
              enResult, d.path + '/${videoModel.name}.mp4');
          getLoaclVideos();

          appSnack(conetxt, "Video Dowloaded");
          emit(state.copyWith(isDownloading: false));
          // showing notification
          LocalNotificationApi.showNotification(
              id: index,
              title: videoModel.name,
              body: "Your video is Downloaded");
        },
      );

      // <

    }
  }

// < video file decrypt and write dec folder
  Future<void> videoDecryptGetPath(String filename) async {
    emit(state.copyWith(isLoading: true));

    Directory d = await VideoFileManager.getExternalVisibleDir("enc");
    Directory dec = await VideoFileManager.getExternalVisibleDir("dec");
    Uint8List encData =
        await VideoFileManager.readData(d.path + '/$filename.mp4');

    // < decrypt video with isolate thread
    var receiverPort = ReceivePort("dec");

    Map<String, dynamic> data = {
      'port': receiverPort.sendPort,
      'data': encData
    };
    await Isolate.spawn(
      decryptDataWithIsolate,
      data,
    );

    receiverPort.listen(
      (plainData) async {
        await VideoFileManager.writeData(plainData, dec.path + '/$filename.mp4')
            .then((value) {
          emit(state.copyWith(isLoading: false));
          decVideoPlay(filename);
        });
      },
    );

    //>
  }

  //< farword and back

  void goFarword() {
    int? activeIndex = state.activeVideo;

    if ((state.videos!.length - 1) > state.activeVideo!) {
      activeIndex = activeIndex! + 1;
      emit(state.copyWith(activeVideo: activeIndex));
      videoItemPlay(index: activeIndex);
    }
  }

  void goBack() {
    int? activeIndex = state.activeVideo;

    if (0 < state.activeVideo!) {
      activeIndex = activeIndex! - 1;
      emit(state.copyWith(activeVideo: activeIndex));
      videoItemPlay(index: activeIndex);
    }
  }

  //< get permission

  Future<bool> requestStoragePermission() async {
    if (!await Permission.storage.isGranted) {
      PermissionStatus result = await Permission.storage.request();
      if (result.isGranted) {
        return true;
      } else {
        return false;
      }
    } else {
      return true;
    }
  }

  void onDispose() {
    state.flickManager?.dispose();
  }

  //<

  Future<void> deleteDecDir() async {
    Directory d = await VideoFileManager.getExternalVisibleDir("dec");
    d.deleteSync(recursive: true);
  }

  void onClose() async {
    emit(HomeState(
        videos: videos,
        flickManager: FlickManager(
            videoPlayerController: VideoPlayerController.network(videoUrl)),
        activeVideo: 0,
        isLoading: false,
        loacalVideoFiles: const [],
        storagePermission: true));
  }
}
