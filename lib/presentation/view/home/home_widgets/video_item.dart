import 'package:flutter/material.dart';
import 'package:mvideo/data/video_model.dart';

Widget videoItem(BuildContext context,
    {required Size size,
    VideoModel? videoModel,
    VoidCallback? onTap,
    bool active = false}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
          color: Colors.grey[200],
          border: Border.all(
              color:
                  active ? Theme.of(context).primaryColor : Colors.transparent,
              width: 1)),
      child: Row(
        children: [
          Container(
            height: size.height * 0.08,
            width: size.width * 0.22,
            color: Colors.grey[100],
            child: Image.network(
              "${videoModel?.thumbnailUrl}",
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(
            width: size.width * 0.02,
          ),
          Text(
            "${videoModel?.name}",
            style: TextStyle(fontSize: size.width * 0.04),
          )
        ],
      ),
    ),
  );
}
