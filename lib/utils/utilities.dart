import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';

class PercentFormField extends StatelessWidget {
  const PercentFormField({
    Key? key,
    required this.controller,
    required this.focusNode,
    required this.hint,
    required this.icon,
    required this.obscureText,
    required this.inputType,
    required this.enableNumberFormat,
  }) : super(key: key);

  final String hint;
  final IconData icon;
  final TextEditingController controller;
  final FocusNode focusNode;
  final TextInputType inputType;
  final bool obscureText;
  final bool enableNumberFormat;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      obscureText: obscureText,
      keyboardType: inputType,
      style: const TextStyle(color: Colors.white),
      cursorColor: Colors.white,
      textInputAction: TextInputAction.done,
      onSaved: (value) {
        controller.text = value!;
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Enter $hint";
        }
        return null;
      },
      decoration: InputDecoration(
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(30.0)),
          borderSide: BorderSide(color: Color(0xFF222222)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(30.0)),
          borderSide: BorderSide(color: Color(0xFF222222)),
        ),
        suffixText: '%',
        prefixIcon: Icon(icon, color: Colors.black),
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white),
        fillColor: Colors.black,
        filled: true,
      ),
      inputFormatters: enableNumberFormat
          ? [
              CurrencyTextInputFormatter(
                decimalDigits: 2,
                symbol: '',
              ),
            ]
          : [],
    );
  }
}

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    Key? key,
    required this.controller,
    required this.hint,
    required this.icon,
    required this.obscureText,
    required this.inputType,
    required this.next,
    required this.focusNode,
  }) : super(key: key);

  final String hint;
  final IconData icon;
  final TextEditingController controller;
  final TextInputType inputType;
  final bool obscureText;
  final bool next;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: inputType,
      focusNode: focusNode,
      style: const TextStyle(color: Colors.white),
      cursorColor: Colors.white,
      textInputAction: next ? TextInputAction.next : TextInputAction.done,
      onSaved: (value) {
        controller.text = value!;
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return hint == "Confirm password"
              ? "Confirm password"
              : "Enter $hint";
        }
        if (hint == "Email" && !validateEmail(value)) {
          return "Please enter a valid email";
        }
        return null;
      },
      decoration: InputDecoration(
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(30.0)),
          borderSide: BorderSide(color: Colors.grey),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(30.0)),
          borderSide: BorderSide(color: Colors.grey),
        ),
        prefixIcon: Icon(icon, color: Colors.white),
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white),
        //labelText: hint,
        //labelStyle: TextStyle(color: Colors.grey.shade700),
        fillColor: Colors.black,
        filled: true,
        //floatingLabelBehavior: FloatingLabelBehavior.never,
      ),
    );
  }
}

Color determineColor(double percentage) {
  if (percentage > 0) {
    return Colors.green;
  } else {
    return Colors.red;
  }
}

IconData determineIcon(double percentage) {
  if (percentage > 0) {
    return Icons.call_made_rounded;
  } else {
    return Icons.call_received_rounded;
  }
}

String trimDollars(String amount) {
  String trimmed = "";
  for (int i = 0; i < amount.length - 3; i++) {
    trimmed += amount[i];
  }
  return trimmed;
}

bool validateEmail(String email) {
  final regularExp = RegExp(
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9]{0,253}[a-zA-Z0-9])?)*$");
  return regularExp.hasMatch(email);
}

String capitalizeFirstLetter(String input) {
  return input[0].toUpperCase() + input.substring(1).toLowerCase();
}
