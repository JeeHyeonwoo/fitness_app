import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:textfield_datepicker/textfield_datepicker.dart';
import '../utils/app_colors.dart';

class RoundDateField extends StatelessWidget {
  TextEditingController textEditingController;
  RoundDateField({Key? key, required this.textEditingController}) : super(key:key);
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
        preferredDateFormat: DateFormat('dd-MMMM-' 'yyyy'),
        textfieldDatePickerController: textEditingController,
        materialDatePickerLocale: Locale('ja', 'JP'),
        /*style: TextStyle(
          fontSize: displayWidth(context) * 0.040,
          fontWeight: FontWeight.w400,
          color: Colors.black,
        ),*/
        textCapitalization: TextCapitalization.sentences,
        cursorColor: Colors.black,
        decoration: InputDecoration(
          //errorText: errorTextValue,
          /*helperStyle: TextStyle(
              fontSize: displayWidth(context) * 0.031,
              fontWeight: FontWeight.w700,
              color: Colors.grey),*/
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.white, width: 0),
              borderRadius: BorderRadius.circular(2)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(2),
              borderSide: const BorderSide(
                width: 0,
                color: Colors.white,
              )),
          hintText: 'Select Date',
          /*hintStyle: TextStyle(
              fontSize: displayWidth(context) * 0.04,
              fontWeight: FontWeight.normal),*/
          filled: true,
          fillColor: Colors.grey[300],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      )
    );
  }
}