import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mvideo/business_login/home_cubit/home_cubit.dart';
import 'package:mvideo/data/video_model.dart';

Widget videoBottomNav(BuildContext context, Size size) {
  HomeCubit homeCubit = BlocProvider.of<HomeCubit>(context);
  return // < video download

      Container(
    padding: const EdgeInsets.all(10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
            onPressed: () {
              homeCubit.goBack();
            },
            icon: const Icon(Icons.arrow_back_ios_new_rounded)),
        BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            VideoModel activeItem = state.videos![state.activeVideo!];
            bool isActive =
                state.loacalVideoFiles?.contains(activeItem.name) ?? false;

            return GestureDetector(
              onTap: () async {
                if (isActive == false && state.isDownloading == false) {
                  homeCubit.downloadVideo(
                      conetxt: context, index: state.activeVideo!);
                }
              },
              child: state.isDownloading!
                  ? Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: isActive ? Colors.grey[300] : Colors.green,
                          borderRadius:
                              BorderRadius.circular(size.width * 0.02)),
                      child: const Text("Downloading..."),
                    )
                  : Container(
                      padding: const EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                          color: isActive ? Colors.grey[300] : Colors.green,
                          borderRadius:
                              BorderRadius.circular(size.width * 0.02)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.arrow_drop_down_sharp,
                            size: size.width * 0.1,
                          ),
                          Text(isActive ? "Downloaded" : "Download"),
                        ],
                      ),
                    ),
            );
          },
        ),
        IconButton(
            onPressed: () {
              homeCubit.goFarword();
            },
            icon: const Icon(Icons.arrow_forward_ios_rounded))
      ],
    ),
  );
}
