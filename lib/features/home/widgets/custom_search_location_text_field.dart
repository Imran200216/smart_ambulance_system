import 'package:flutter/material.dart';

class CustomSearchLocationTextField extends StatelessWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onSubmitted;

  const CustomSearchLocationTextField({
    super.key,
    this.controller,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      autofocus: true,
      onSubmitted: onSubmitted,
      decoration: const InputDecoration(
        hintText: 'Search location...',
        border: InputBorder.none,
      ),
    );
  }
}
