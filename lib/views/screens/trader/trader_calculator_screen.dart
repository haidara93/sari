import 'package:custome_mobile/views/widgets/calculator_widget.dart';
import 'package:flutter/material.dart';

class TraderCalculatorScreen extends StatelessWidget {
  final GlobalKey<FormState> _calformkey = GlobalKey<FormState>();

  final TextEditingController _typeAheadController = TextEditingController();

  final TextEditingController _wieghtController = TextEditingController();

  final TextEditingController _originController = TextEditingController();

  final TextEditingController _valueController = TextEditingController();

  TraderCalculatorScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.grey[200],
          body: SafeArea(
              child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 35,
                    ),
                    Text(
                      "حاسبة الرسوم الجمركية",
                      style: TextStyle(
                          color: Colors.yellow[700],
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    const Text(
                      "تتيح أداة حاسبة الرسوم الجمركية تقدير التكلفة الإجمالية لاستيراد البضائع وفقاً للتعرفة الجمركية والقوانين الضريبية في الجمهورية العربية السورية، وتوفر مجموعة واسعة من المعلومات المفصلة حول الرسوم الجمركية بما في ذلك الأحكام والشروط والأسعار الاسترشادية المتوفرة.",
                      maxLines: 10,
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 7),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        gradient: const LinearGradient(
                            colors: [
                              Color.fromARGB(255, 229, 215, 94),
                              Colors.white,
                              Colors.white,
                              Colors.white,
                              Colors.white,
                              Colors.white,
                              Colors.white,
                              Colors.white,
                              Colors.white,
                              Colors.white,
                              Colors.white,
                              Colors.white,
                              Colors.white,
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter),
                      ),
                      width: double.infinity,
                      padding: const EdgeInsets.all(8.0),
                      child: CalculatorWidget(
                          calformkey: _calformkey,
                          typeAheadController: _typeAheadController,
                          originController: _originController,
                          wieghtController: _wieghtController,
                          valueController: _valueController),
                    ),
                  ]),
            ),
          )),
        ));
  }
}
