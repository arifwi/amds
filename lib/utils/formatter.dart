import 'package:flutter/services.dart';

class UpperCaseFormatter extends TextInputFormatter{
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    // TODO: implement formatEditUpdate
    return newValue.copyWith(text:  newValue.text.toUpperCase());
  }

}