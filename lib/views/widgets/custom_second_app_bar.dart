// import 'package:custome_mobile/helpers/color_constants.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// // ignore: must_be_immutable
// class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
//   String title;
//   GlobalKey<ScaffoldState>? scaffoldKey;
//   CustomAppBar({super.key, required this.title, this.scaffoldKey});

//   @override
//   Widget build(BuildContext context) {
//     return AppBar(
//       title: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Image.asset(
//             "assets/images/sari_white_logo.png",
//             height: 35.h,
//           ),
//           Text(
//             title,
//             style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 22.sp,
//                 fontWeight: FontWeight.bold),
//           ),
//           Text(
//             "",
//             style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 22.sp,
//                 fontWeight: FontWeight.bold),
//           ),
//         ],
//       ),
//       centerTitle: true,
//       backgroundColor: AppColor.deepBlue,
//       toolbarHeight: 65.h,
//       elevation: 2,
//       actions: [
//         Container(
//           margin: EdgeInsets.symmetric(vertical: 13.h, horizontal: 3.w),
//           height: 35.h,
//           width: 35.w,
//           decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(45),
//               color: AppColor.deepBlue),
//           child: Center(
//             child: Icon(
//               Icons.notifications,
//               color: Colors.white,
//               size: 35.w,
//             ),
//           ),
//         ),
//       ],
//     );
//     // Container(
//     //   height: 160.h,
//     //   padding: const EdgeInsets.only(bottom: 6.0),
//     //   decoration: BoxDecoration(
//     //     color: AppColor.deepBlue,
//     //     borderRadius: const BorderRadius.only(
//     //       bottomLeft: Radius.circular(20.0),
//     //       bottomRight: Radius.circular(20.0),
//     //     ),
//     //   ),
//     //   child: Padding(
//     //     padding: EdgeInsets.symmetric(horizontal: 12.w),
//     //     child: Column(children: [
//     //       Row(
//     //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//     //         children: [
//     //           Row(
//     //             children: [
//     //               GestureDetector(
//     //                 onTap: () {
//     //                   scaffoldKey.currentState!.openDrawer();
//     //                 },
//     //                 child: Container(
//     //                   margin:
//     //                       EdgeInsets.symmetric(vertical: 13.h, horizontal: 3.w),
//     //                   height: 35.h,
//     //                   width: 35.w,
//     //                   decoration: BoxDecoration(
//     //                       borderRadius: BorderRadius.circular(45),
//     //                       color: Colors.white),
//     //                   child: Center(
//     //                     child: Icon(
//     //                       Icons.list,
//     //                       color: AppColor.deepBlue,
//     //                       size: 25.w,
//     //                     ),
//     //                   ),
//     //                 ),
//     //               ),
//     //               Container(
//     //                 margin:
//     //                     EdgeInsets.symmetric(vertical: 13.h, horizontal: 3.w),
//     //                 height: 35.h,
//     //                 width: 35.w,
//     //                 decoration: BoxDecoration(
//     //                     borderRadius: BorderRadius.circular(45),
//     //                     color: Colors.white),
//     //                 child: Center(
//     //                   child: Icon(
//     //                     Icons.notifications,
//     //                     color: AppColor.deepBlue,
//     //                     size: 25.w,
//     //                   ),
//     //                 ),
//     //               ),
//     //             ],
//     //           ),
//     //           Image.asset(
//     //             "assets/images/sari_white_logo.png",
//     //             height: 35.h,
//     //           ),
//     //         ],
//     //       ),
//     //       Spacer(),
//     //       Row(
//     //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//     //         children: [
//     //           Container(
//     //             height: 35.h,
//     //             width: 35.w,
//     //             margin: EdgeInsets.symmetric(vertical: 13.h, horizontal: 5.w),
//     //             decoration: BoxDecoration(
//     //                 borderRadius: BorderRadius.circular(45),
//     //                 color: Colors.white),
//     //             child: Center(
//     //               child: Icon(
//     //                 Icons.arrow_back_ios,
//     //                 color: AppColor.deepBlue,
//     //                 size: 25.w,
//     //               ),
//     //             ),
//     //           ),
//     //           Text(
//     //             title,
//     //             style: TextStyle(
//     //                 color: Colors.white,
//     //                 fontSize: 22.sp,
//     //                 fontWeight: FontWeight.bold),
//     //           ),
//     //         ],
//     //       )
//     //     ]),
//     //   ),
//     // );
//   }

//   @override
//   Size get preferredSize => const Size(double.infinity, 130.0);
// }
