import 'package:fitnessapp/common_widgets/round_datefield.dart';
import 'package:fitnessapp/utils/app_colors.dart';
import 'package:fitnessapp/utils/db/member/member.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common_widgets/round_gradient_button.dart';
import '../../common_widgets/round_textfield.dart';

class SignupScreen extends StatefulWidget {
  static String routeName = "/SignupScreen";
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool isCheck = false;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _weightController = TextEditingController();
  TextEditingController _heightController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    Get.put(Member());
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15,horizontal: 25),
          child: Column(
            children: [
              SizedBox(
                width: media.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: media.width*0.03,
                    ),
                    const Text(
                      "회원정보",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.blackColor,
                        fontSize: 20,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: media.width*0.05),
              RoundTextField(
                  hintText: "이름",
                  icon: "assets/icons/user_icon.png",
                  textEditingController: _nameController,
                  textInputType: TextInputType.name),
              SizedBox(height: media.width*0.05),
              RoundTextField(
                hintText: "키",
                icon: "assets/icons/user_icon.png",
                textEditingController: _heightController,
                textInputType: TextInputType.number,
              ),
              SizedBox(height: media.width*0.05),
              RoundTextField(
                hintText: "몸무게",
                icon: "assets/icons/user_icon.png",
                textEditingController: _weightController,
                textInputType: TextInputType.number,
              ),
              SizedBox(height: media.width*0.05),
              RoundDateField(
                  textEditingController: _dateController,
                  icon: "assets/icons/date.png",
              ),
              SizedBox(height: media.width*0.03),
              GetBuilder<Member>(builder: (controller) {
                return RoundGradientButton(
                  title: "저장",
                  onPressed: () {
                    print(_dateController.text);
                    controller.setMember(_nameController, _heightController, _weightController, _dateController);
                    Navigator.pop(context);
                  },
                );
              }),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
