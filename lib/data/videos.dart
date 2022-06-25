import 'package:mvideo/data/video_model.dart';

List<VideoModel> videos = [
  VideoModel(
      name: "meet",
      url: driveDownloadLinkWithId("10chrCTHZV1Tw9xGbN5sKLma6IwrVNJ3T"),
      thumbnailUrl:
          driveDownloadLinkWithId("19TTbvM-l-pXXAvdmjOsvY6xjZvGsZm_O")),
  VideoModel(
      name: "yo man",
      url: driveDownloadLinkWithId("1EHEiun2CTdg4vww5iOQ7gUucovAuk7is"),
      thumbnailUrl:
          driveDownloadLinkWithId("1ajfIwyEeNNBDD-7EHI244zNsedfR8Bd-"))
];

String driveDownloadLinkWithId(String id) {
  return "https://drive.google.com/uc?export=download&id=$id";
}
