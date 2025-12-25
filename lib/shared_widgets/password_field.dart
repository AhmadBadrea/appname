// lib/shared_widgets/password_field.dart

import 'package:flutter/material.dart';

class PasswordField extends StatefulWidget {
  final String hint;
  const PasswordField({super.key, required this.hint});

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool obscure = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: obscure,
      decoration: InputDecoration(
        hintText: widget.hint,
        prefixIcon: const Icon(Icons.lock),
        suffixIcon: IconButton(
          icon: Icon(obscure ? Icons.visibility_off : Icons.visibility),
          onPressed: () {
            setState(() => obscure = !obscure);
          },
        ),
        filled: true,
        fillColor: Colors.white,
        // هذا التعريف الثابت لم يعد يتضارب مع الثيم العام
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
      ),
    );
  }
}
