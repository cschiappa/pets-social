import 'package:flutter/material.dart';

class TextFieldInput extends StatefulWidget {
  final TextEditingController textEditingController;
  final bool isPass;
  final String labelText;
  final String? initialValue;
  final Function(String)? onChanged;

  final TextInputType textInputType;
  const TextFieldInput({Key? key, required this.textEditingController, this.isPass = false, required this.labelText, required this.textInputType, this.initialValue, this.onChanged}) : super(key: key);

  @override
  State<TextFieldInput> createState() => _TextFieldInputState();
}

class _TextFieldInputState extends State<TextFieldInput> {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return TextFormField(
      onTapOutside: (event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      controller: widget.textEditingController,
      decoration: InputDecoration(
        labelText: widget.labelText,
        border: const OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: theme.colorScheme.secondary),
        ),
        contentPadding: const EdgeInsets.all(10),
      ),
      keyboardType: widget.textInputType,
      obscureText: widget.isPass,
      initialValue: widget.initialValue,
      onChanged: widget.onChanged,
    );
  }
}
