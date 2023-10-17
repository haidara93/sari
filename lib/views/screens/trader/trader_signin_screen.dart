import 'package:custome_mobile/business_logic/bloc/auth_bloc.dart';
import 'package:custome_mobile/constants/text_constants.dart';
import 'package:custome_mobile/helpers/color_constants.dart';
import 'package:custome_mobile/views/screens/trader/trader_confirm_screen.dart';
import 'package:custome_mobile/views/screens/trader/trader_message_screen.dart';
import 'package:custome_mobile/views/widgets/custom_botton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TraderSigninScreen extends StatefulWidget {
  TraderSigninScreen({Key? key}) : super(key: key);

  @override
  State<TraderSigninScreen> createState() => _TraderSigninScreenState();
}

class _TraderSigninScreenState extends State<TraderSigninScreen> {
  final focusNode = FocusNode();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _usernameController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login() async {
    _postData(context);
    _usernameController.text = '';
    _passwordController.text = '';
  }

  void _postData(context) {
    // ScaffoldMessenger.of(context)
    //     .showSnackBar(SnackBar(content: Text("aasdasd")));
    BlocProvider.of<AuthBloc>(context).add(SignInButtonPressed(
        _usernameController.text, _passwordController.text));
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 120.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                child: Image.asset(
                  "assets/images/963.png",
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              Text(
                "قم بتسجيل الدخول",
                style: TextStyle(
                    fontSize: 19.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColor.deepBlue),
              ),
              // Text(
              //   "ادخل رقم الهاتف وسوف نرسل لك رمز التحقق",
              //   style: TextStyle(
              //     color: Colors.white,
              //     fontSize: 19.sp,
              //     fontWeight: FontWeight.bold,
              //   ),
              // ),
              SizedBox(
                height: 37.h,
              ),
              Card(
                elevation: 3,
                clipBehavior: Clip.antiAlias,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                  Radius.circular(40),
                )),
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 35),
                  child: Form(
                    key: _formKey,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 62.w),
                      child: Column(
                        children: [
                          SizedBox(
                            width: 304.w,
                            child: TextFormField(
                              // focusNode: focusNode,
                              // keyboardType: TextInputType.phone,
                              // initialValue: widget.initialValue,
                              validator: (value) {
                                if (value!.isEmpty || value.length < 4) {
                                  return TextConstants.emailErrorText;
                                }
                                return null;
                              },
                              onSaved: (newValue) {
                                _usernameController.text = newValue!;
                              },
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16.sp,
                              ),
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 20.w, vertical: 2.h),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(42),
                                  borderSide: BorderSide(
                                    color: Color.fromRGBO(13, 52, 83, 1),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(42),
                                  borderSide: const BorderSide(
                                    color: Color.fromRGBO(13, 52, 83, 1),
                                  ),
                                ),
                                hintText: "اسم المستخدم",
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16.sp,
                                ),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 34.h,
                          ),
                          SizedBox(
                            width: 304.w,
                            child: TextFormField(
                              // focusNode: focusNode,
                              // keyboardType: TextInputType.phone,
                              // initialValue: widget.initialValue,
                              validator: (value) {
                                if (value!.isEmpty || value.length < 4) {
                                  return TextConstants.passwordErrorText;
                                }
                                return null;
                              },
                              onSaved: (newValue) {
                                _passwordController.text = newValue!;
                              },
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16.sp,
                              ),
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 20.w, vertical: 2.h),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(42),
                                  borderSide: BorderSide(
                                    color: Color.fromRGBO(13, 52, 83, 1),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(42),
                                  borderSide: const BorderSide(
                                    color: Color.fromRGBO(13, 52, 83, 1),
                                  ),
                                ),
                                hintText: "كلمة المرور",
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16.sp,
                                ),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 34.h,
                          ),
                          BlocConsumer<AuthBloc, AuthState>(
                            listener: (context, state) {
                              if (state is AuthTraderSuccessState) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          TraderConfirmScreen(),
                                    ));
                              }
                              if (state is AuthBrokerSuccessState) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          TraderConfirmScreen(),
                                    ));
                              }
                            },
                            builder: (context, state) {
                              if (state is AuthLoggingInProgressState) {
                                return SizedBox(
                                    width: 304.w,
                                    child: CustomButton(
                                      color: AppColor.deepYellow,
                                      title: const CircularProgressIndicator(),
                                      onTap: () {},
                                    ));
                              } else {
                                return SizedBox(
                                    width: 304.w,
                                    child: CustomButton(
                                      title: Text(
                                        "تسجيل الدخول",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 19.sp,
                                        ),
                                      ),
                                      color: AppColor.deepYellow,
                                      onTap: () {
                                        _formKey.currentState?.save();

                                        if (_formKey.currentState!.validate()) {
                                          _login();
                                        }
                                      },
                                    ));
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
