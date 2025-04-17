import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:uuid/uuid.dart';
import 'package:smart_ambulance_system/gen/colors.gen.dart';

class CustomTextField extends StatefulWidget {
  final bool readOnly;
  final String hintText;
  final String prefixIcon;
  final bool isPassword;
  final bool hasBorder;
  final TextEditingController? textEditingController;
  final VoidCallback? onTap;
  final TextInputType? keyboardType;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final EdgeInsetsGeometry? contentPadding;
  final double topRightRadius;
  final double bottomLeftRadius;
  final double topLeftRadius;
  final double bottomRightRadius;
  final bool isUidGenerate;

  const CustomTextField({
    super.key,
    required this.hintText,
    required this.prefixIcon,
    this.isPassword = false,
    this.hasBorder = false,
    this.textEditingController,
    this.onTap,
    this.keyboardType,
    this.validator,
    this.onChanged,
    this.readOnly = false,
    this.contentPadding,
    this.topRightRadius = 6.0,
    this.bottomLeftRadius = 6.0,
    this.topLeftRadius = 6.0,
    this.bottomRightRadius = 6.0,
    this.isUidGenerate = false,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _isObscure = true;

  final Uuid _uuid = const Uuid();

  void _handleGenerateUid() {
    // Generate a full UUID
    final fullUuid = _uuid.v4().replaceAll('-', '');

    // Filter to keep only alphanumeric characters and take first 6
    final uid =
        fullUuid
            .replaceAll(RegExp(r'[^a-zA-Z0-9]'), '')
            .substring(0, 6)
            .toUpperCase();

    widget.textEditingController?.text = uid;
    if (widget.onChanged != null) {
      widget.onChanged!(uid);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autocorrect: true,
      readOnly: widget.readOnly,
      onChanged: widget.onChanged,
      validator: widget.validator,
      cursorColor: ColorName.primary,
      keyboardType: widget.keyboardType,
      onTap: widget.onTap,
      controller: widget.textEditingController,
      style: TextStyle(color: ColorName.black, fontWeight: FontWeight.w500),
      obscureText: widget.isPassword ? _isObscure : false,
      decoration: InputDecoration(
        fillColor: ColorName.white,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide:
              widget.hasBorder
                  ? BorderSide(color: ColorName.texFieldBorderColor, width: 1.w)
                  : BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide:
              widget.hasBorder
                  ? BorderSide(color: ColorName.texFieldBorderColor, width: 1.w)
                  : BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide:
              widget.hasBorder
                  ? BorderSide(color: ColorName.texFieldBorderColor, width: 1.w)
                  : BorderSide.none,
        ),
        hintText: widget.hintText,
        hintStyle: TextStyle(
          color: ColorName.texFieldHintColor,
          fontWeight: FontWeight.w500,
        ),
        prefixIcon: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
          child: SizedBox(
            height: 18.h,
            width: 18.w,
            child: SvgPicture.asset(
              widget.prefixIcon,
              fit: BoxFit.contain,
              color: ColorName.texFieldPrefixIconColor,
            ),
          ),
        ),
        suffixIcon:
            widget.isPassword
                ? IconButton(
                  icon: Icon(
                    _isObscure ? Icons.visibility_off : Icons.visibility,
                    color: ColorName.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _isObscure = !_isObscure;
                    });
                  },
                )
                : widget.isUidGenerate
                ? IconButton(
                  icon: Icon(Icons.refresh, color: ColorName.primary),
                  tooltip: 'Generate UID',
                  onPressed: _handleGenerateUid,
                )
                : null,
        contentPadding:
            widget.contentPadding ??
            EdgeInsets.symmetric(vertical: 6.h, horizontal: 12.w),
        errorStyle: TextStyle(
          color: ColorName.authErrorColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
