import 'package:custome_mobile/helpers/color_constants.dart';
import 'package:custome_mobile/views/screens/trader/trader_confirm_screen.dart';
import 'package:custome_mobile/views/widgets/custom_botton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TraderMessageScreen extends StatelessWidget {
  final focusNode = FocusNode();

  TraderMessageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(13, 52, 83, 1),
      body: Column(
        children: [
          SizedBox(
            height: 191.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Image.asset(
                "assets/images/trader_checked.png",
                height: 85,
              ),
            ],
          ),
          SizedBox(
            height: 31.h,
          ),
          Text(
            "ادخل الكود المكون من 6 أرقام",
            style: TextStyle(
              color: Colors.white,
              fontSize: 19.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 37.h,
          ),
          Container(
            height: 246.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(42),
            ),
            margin: EdgeInsets.symmetric(horizontal: 21.w),
            padding: EdgeInsets.symmetric(vertical: 50.h),
            child: Column(
              children: [
                SizedBox(
                  width: 304.w,
                  child: TextFormField(
                    focusNode: focusNode,
                    keyboardType: TextInputType.phone,
                    // initialValue: widget.initialValue,
                    // validator: widget.validatorFn,
                    // onSaved: widget.onSavedFn,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                    ),
                    decoration: const InputDecoration(
                      hintText: "",
                      hintStyle: TextStyle(
                        color: Color.fromARGB(255, 7, 3, 3),
                        fontSize: 16,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 34,
                ),
                SizedBox(
                    width: 304.w,
                    child: CustomButton(
                      title: Text(
                        "التالي",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 19.sp,
                        ),
                      ),
                      color: AppColor.deepYellow,
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const TraderConfirmScreen(),
                            ));
                      },
                    )),
              ],
            ),
          )
        ],
      ),
    );
  }
}
