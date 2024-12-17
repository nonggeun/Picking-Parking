import 'package:flutter/material.dart';

class Input extends StatelessWidget {
  final String? buttonText;
  final Future<void> Function()? onPressed;
  final TextInputType? inputType;
  final bool? obscure;
  final Function? onTap;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final FormFieldSetter<String>? onSaved;
  final bool? readonly;
  final String? hint;

  const Input({
    super.key,
    this.inputType,
    this.buttonText,
    this.onPressed,
    this.obscure,
    this.onTap,
    this.controller,
    this.validator,
    this.onSaved,
    this.readonly,
    this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 3,
        bottom: 7,
        right: 10,
        left: 10,
      ),
      child: TextFormField(
        controller: controller,
        onTap: onTap != null ? onTap as void Function() : null,
        onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
        keyboardType: inputType,
        obscureText: obscure ?? false,
        readOnly: readonly ?? false,
        validator: validator,
        onSaved: onSaved,
        decoration: InputDecoration(
          hintText: hint,
          suffixIcon: buttonText != null
              ? Padding(
                  padding: const EdgeInsets.only(
                    right: 7,
                    top: 3,
                    bottom: 3,
                  ),
                  child: ElevatedButton(
                    onPressed: onPressed,
                    style: ButtonStyle(
                        padding: WidgetStateProperty.all<EdgeInsets>(
                          const EdgeInsets.symmetric(
                            horizontal: 10,
                          ),
                        ),
                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10))),
                        backgroundColor: WidgetStateProperty.all<Color>(
                          Theme.of(context).primaryColor,
                        )),
                    child: Text(
                      buttonText!,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                )
              : null,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.black45),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
      ),
    );
  }
}
