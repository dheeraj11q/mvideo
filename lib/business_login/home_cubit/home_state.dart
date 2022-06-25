part of 'home_cubit.dart';

class HomeState extends Equatable {
  final List<VideoModel>? videos;
  final FlickManager? flickManager;
  final int? activeVideo;
  final bool? isLoading;
  final bool? isDownloading;
  final List<String>? loacalVideoFiles;
  final bool? storagePermission;
  const HomeState(
      {this.videos,
      this.flickManager,
      this.activeVideo,
      this.isLoading,
      this.loacalVideoFiles,
      this.storagePermission,
      this.isDownloading});

  HomeState copyWith(
      {List<VideoModel>? videos,
      FlickManager? flickManager,
      int? activeVideo,
      bool? isLoading,
      List<String>? loacalVideoFiles,
      bool? storagePermission,
      bool? isDownloading}) {
    return HomeState(
        videos: videos ?? this.videos,
        flickManager: flickManager ?? this.flickManager,
        activeVideo: activeVideo ?? this.activeVideo,
        isLoading: isLoading ?? this.isLoading,
        loacalVideoFiles: loacalVideoFiles ?? this.loacalVideoFiles,
        storagePermission: storagePermission ?? this.storagePermission,
        isDownloading: isDownloading ?? this.isDownloading);
  }

  @override
  List<Object> get props => [
        videos!,
        flickManager!,
        activeVideo!,
        isLoading!,
        loacalVideoFiles!,
        storagePermission!,
        isDownloading!
      ];
}
