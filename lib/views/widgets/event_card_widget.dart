import 'package:custome_mobile/helpers/color_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EventCardWidget extends StatelessWidget {
  final bool isPast;
  final bool isCurrent;
  final String title;
  final String imageUrl;

  const EventCardWidget(
      {Key? key,
      required this.isPast,
      required this.title,
      required this.imageUrl,
      required this.isCurrent})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5),
      padding: const EdgeInsets.all(5),
      child: Row(
        children: [
          Image.asset(
            imageUrl,
            height: 40.h,
            width: 40.w,
          ),
          Text(
            title,
            style: TextStyle(
              color: isPast
                  ? isCurrent
                      ? AppColor.goldenYellow
                      : Colors.black
                  : Colors.black54,
            ),
          )
        ],
      ),
    );
  }
}
