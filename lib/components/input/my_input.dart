import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:time_control/theme.dart';

class MyInput extends StatelessWidget {
  final String labelText;
  final String hintText;
  final void Function(String) onSaved;
  final void Function(String) onValidator;
  final void Function(String) onChanged;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final Icon icon;
  final Color iconColor;
  final bool enabled;
  final TextCapitalization textCapitalization;
  final bool obscureText;
  final Widget suffixIcon;
  final int maxLines;
  final int totalNumberCharacters = 255;
  final bool showNumberCharacters;
  final void Function() onTap;
  final bool required;

  const MyInput({
    Key key,
    this.labelText,
    this.hintText,
    this.controller,
    this.keyboardType,
    this.onValidator,
    this.onChanged,
    this.onSaved,
    this.icon,
    this.enabled,
    this.textCapitalization,
    this.iconColor,
    this.obscureText,
    this.suffixIcon,
    this.maxLines,
    this.showNumberCharacters,
    this.onTap, this.required,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 8.0,
        right: 8.0,
        top: 4.0,
        bottom: 14.0,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextFormField(
            controller: controller,
            inputFormatters: [
              LengthLimitingTextInputFormatter(totalNumberCharacters),
            ],
            enabled: enabled ?? true,
            keyboardType: keyboardType,
            textCapitalization: textCapitalization ?? TextCapitalization.none,
            autofocus: false,
            obscureText: obscureText ?? false,
            maxLines: maxLines ?? 1,
            readOnly: onTap != null,
            onTap: onTap,
            decoration: InputDecoration(
              labelText: labelText,
              hintText: hintText,
              filled: true,
              floatingLabelBehavior: FloatingLabelBehavior.always,
              fillColor: enabled ?? true ? Colors.white : null,
              icon: icon == null ? null : Icon(icon.icon, color: icon.color ?? MyTheme.primaryColor,),
              suffixIcon: suffixIcon == null ? null : Material(
                color: Colors.transparent,
                child: suffixIcon,
              ),
            ),
            validator: required ?? true ? (
                onValidator != null ? onValidator : keyboardType == TextInputType.number ?
                ((value) => value.isEmpty ? 'Por favor, não pode estar vazio' :
                double.tryParse(value) == null ? 'Por favor, insira um valor válido' : null)
                    : (value) => value.isEmpty ? 'Por favor, não pode estar vazio' : null
            ) : null,
            onSaved: onSaved,
            onChanged: onChanged,
          ),
          if ((showNumberCharacters ?? false) && controller != null) Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Text('${(controller.text ?? '').length}/$totalNumberCharacters'),
            ],
          ),
        ],
      ),
    );
  }

}