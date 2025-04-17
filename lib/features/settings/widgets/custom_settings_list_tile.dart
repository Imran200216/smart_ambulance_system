import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_ambulance_system/gen/colors.gen.dart';

class CustomSettingsListTile extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;
  final IconData trailingIcon;

  const CustomSettingsListTile({
    super.key,
    required this.title,
    required this.trailingIcon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: ColorName.grey.withOpacity(0.3), width: 1),
        ),
      ),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: ColorName.black.withOpacity(0.7),
          ),
        ),
        trailing: Icon(trailingIcon, color: ColorName.black.withOpacity(0.7)),
        onTap: onTap,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
      ),
    );
  }
}
