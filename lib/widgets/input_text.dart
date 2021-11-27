import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputText extends StatelessWidget {
  final String label, hintText, initialValue;
  final bool obscureText;
  final bool borderEnabled;
  final bool formEnabled;
  final bool isPasswordField;
  final bool withPrefix;
  final double fontSize;
  final double width;
  final TextInputType type;
  final TextAlign textAlign;
  final Icon prefix;
  final Color colorText;
  final void Function(String text) onChanged;
  final String Function(String text) validator;
  final void Function() showPassword;
  final TextEditingController controller;

  const InputText({
    Key key,
    this.initialValue = "",
    this.label = '',
    this.type = TextInputType.text,
    this.obscureText = false,
    this.borderEnabled = true,
    this.formEnabled = false,
    this.isPasswordField = false,
    this.withPrefix = false,
    this.fontSize = 15,
    this.onChanged,
    this.validator,
    this.hintText,
    this.colorText,
    @required this.width,
    this.showPassword,
    this.controller,
    this.textAlign = TextAlign.start,
    this.prefix,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 3),
      child: Container(
        width: this.width,
        child: TextFormField(
          initialValue: this.initialValue,
          textAlign: this.textAlign,
          maxLines: 1,
          enabled: this.formEnabled,
          keyboardType: this.type,
          obscureText: this.obscureText,
          style: TextStyle(
            fontSize: this.fontSize,
            color: this.colorText,
          ),
          onChanged: this.onChanged,
          validator: this.validator,
          decoration: InputDecoration(
            prefixIcon: this.withPrefix ? this.prefix : null,
            prefixIconConstraints: this.withPrefix
                ? BoxConstraints(
                    minWidth: 0,
                    minHeight: 0,
                  )
                : null,
            suffixIcon: this.isPasswordField
                ? IconButton(
                    icon: Icon(
                      this.obscureText
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: this.colorText,
                    ),
                    onPressed: this.showPassword,
                  )
                : null,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(
                color: Colors.grey,
              ),
            ),
            filled: true,
            fillColor: Colors.white54,
            focusColor: Colors.white70,
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(
                color: Colors.grey,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(
                color: Colors.grey,
              ),
            ),
            labelText: this.label,
            contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            labelStyle: TextStyle(
              color: this.colorText,
              fontSize: this.fontSize,
            ),
            hintText: this.hintText,
          ),
          controller: this.controller,
        ),
      ),
    );
  }
}
