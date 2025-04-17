import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_ambulance_system/gen/assets.gen.dart';
import 'package:smart_ambulance_system/gen/colors.gen.dart';
import 'package:smart_ambulance_system/features/settings/settings_exports.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: ColorName.transparent,
          elevation: 0,
          leading: IconButton(
            icon: SvgPicture.asset(
              Assets.icon.svg.back,
              height: 40.h,
              width: 40.w,
            ),
            onPressed: () {
              GoRouter.of(context).pop();
            },
          ),
          centerTitle: true,
          title: Text(
            "Settings",
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: ColorName.black,
            ),
          ),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // account text
                Text(
                  "Account",
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.normal,
                    color: ColorName.primary,
                  ),
                ),

                SizedBox(height: 10),

                // edit profile list tile
                CustomSettingsListTile(
                  title: 'Edit Profile',
                  trailingIcon: Icons.arrow_forward_ios,
                  onTap: () {},
                ),

                SizedBox(height: 10),

                // password list tile
                CustomSettingsListTile(
                  title: 'Password',
                  trailingIcon: Icons.arrow_forward_ios,
                  onTap: () {},
                ),

                SizedBox(height: 20),

                // support text
                Text(
                  "Support",
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.normal,
                    color: ColorName.primary,
                  ),
                ),

                SizedBox(height: 10),

                // Terms of Service & Privacy list tile
                CustomSettingsListTile(
                  title: 'Terms of Service & Privacy',
                  trailingIcon: Icons.arrow_forward_ios,
                  onTap: () {},
                ),

                SizedBox(height: 10),

                // Help and Support list tile
                CustomSettingsListTile(
                  title: 'Help and Support',
                  trailingIcon: Icons.arrow_forward_ios,
                  onTap: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
