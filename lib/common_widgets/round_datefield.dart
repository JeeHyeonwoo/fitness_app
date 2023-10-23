import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:textfield_datepicker/textfield_datepicker.dart';
import '../utils/app_colors.dart';

class RoundDateField extends StatelessWidget {
  final String icon;
  TextEditingController textEditingController;
  RoundDateField({Key? key, required this.textEditingController, required this.icon}) : super(key:key);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: AppColors.lightGrayColor,
          borderRadius: BorderRadius.circular(15)),
      child: TextfieldDatePicker(
        cupertinoDatePickerBackgroundColor: Colors.white,
        cupertinoDatePickerMaximumDate: DateTime(2099),
        cupertinoDatePickerMaximumYear: 2099,
        cupertinoDatePickerMinimumYear: 1990,
        cupertinoDatePickerMinimumDate: DateTime(1990),
        cupertinoDateInitialDateTime: DateTime.now(),
        materialDatePickerFirstDate: DateTime(1850),
        materialDatePickerInitialDate: DateTime.now(),
        materialDatePickerLastDate: DateTime(2099),
        preferredDateFormat: DateFormat('yyyy-MM-dd'),
        textfieldDatePickerController: textEditingController,
        materialDatePickerLocale: Locale('ko', 'KR'),
        /*style: TextStyle(
          fontSize: displayWidth(context) * 0.040,
          fontWeight: FontWeight.w400,
          color: Colors.black,
        ),*/
        textfieldDatePickerMargin: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
        textfieldDatePickerPadding : EdgeInsets.symmetric(vertical: 0, horizontal: 0),
        textCapitalization: TextCapitalization.sentences,
        cursorColor: Colors.black,
        decoration: InputDecoration(
            contentPadding:
            const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            hintText: "생년월일",
            prefixIcon: Container(
                alignment: Alignment.center,
                width: 20,
                height: 20,
                child: Image.asset(
                  icon,
                  width: 20,
                  height: 20,
                  fit: BoxFit.contain,
                  color: AppColors.grayColor,
                )),
            hintStyle: TextStyle(fontSize: 12, color: AppColors.grayColor)),
      ),
    );
  }
}