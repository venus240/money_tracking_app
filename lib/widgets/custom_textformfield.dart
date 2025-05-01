import 'package:flutter/material.dart';
import 'package:money_tracking_app/constants/color_constant.dart';

// ignore: must_be_immutable
class CustomTextFormField extends StatefulWidget {
  final IconData? iconSuffix;
  final String labelText;
  final String hintText;
  final TextEditingController controller;
  final Key fieldKey;
  final String validateText;
  bool obscureText;
  CustomTextFormField({
    super.key,
    required this.labelText,
    required this.hintText,
    required this.controller,
    required this.fieldKey,
    required this.validateText,
    this.iconSuffix,
    this.obscureText = false,
  });

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          key: widget.fieldKey,
          obscureText: widget.obscureText,
          controller: widget.controller,
          decoration: InputDecoration(
            suffixIcon: buildSuffixIcon(),
            suffixIconColor: Colors.grey,
            labelText: widget.labelText,
            labelStyle: TextStyle(color: Colors.black),
            hintText: widget.hintText,
            hintStyle: TextStyle(color: Colors.grey),
            border: const OutlineInputBorder(),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(mainColor), width: 2.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(mainColor), width: 2.0),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return widget.validateText;
            }
            return null;
          },
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget? buildSuffixIcon() {
    if (widget.iconSuffix != null && widget.iconSuffix == Icons.lock) {
      return IconButton(
        icon:
            widget.obscureText
                ? Icon(widget.iconSuffix)
                : Icon(Icons.lock_open),
        onPressed: () {
          setState(() {
            widget.obscureText = !widget.obscureText;
          });
        },
      );
    } else {
      return Icon(widget.iconSuffix);
    }
  }
}
