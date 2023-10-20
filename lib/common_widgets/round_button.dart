import 'package:flutter/material.dart';

import '../utils/app_colors.dart';

enum RoundButtonType { primaryBG, secondaryBG }

class RoundButton extends StatelessWidget {
  final String title;
  final RoundButtonType type;
  final Function() onPressed;
  final double radius;
  final double fontSize;

  const RoundButton({Key? key, required this.title, required this.onPressed, this.type = RoundButtonType.secondaryBG, this.radius = 20.0, this.fontSize=11})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: type == RoundButtonType.secondaryBG?AppColors.secondaryG:AppColors.primaryG,
              begin: Alignment.centerLeft,
              end: Alignment.centerRight),
          borderRadius: BorderRadius.circular(this.radius),
          boxShadow: const [
            BoxShadow(
                color: Colors.black26, blurRadius: 2, offset: Offset(0, 2))
          ]),
      child: MaterialButton(
        minWidth: double.maxFinite,
        height: 50,
        onPressed: onPressed,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(this.radius)),
        textColor: AppColors.primaryColor1,
        child: Text(
          title,
          style: TextStyle(
            fontSize: fontSize,
            color: AppColors.whiteColor,
            fontFamily: "Poppins",
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
