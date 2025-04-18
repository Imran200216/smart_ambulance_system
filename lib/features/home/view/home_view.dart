import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:smart_ambulance_system/features/auth/auth_exports.dart';
import 'package:smart_ambulance_system/features/home/home_exports.dart';
import 'package:smart_ambulance_system/gen/colors.gen.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    // provider
    final employeeDetailsProvider = Provider.of<EmployeeDetailsProvider>(
      context,
    );
    final emailPasswordAuthProvider = Provider.of<EmailPasswordProvider>(
      context,
    );

    // current user
    final User? currentUser = FirebaseAuth.instance.currentUser;

    // current user name
    final currentUserName = currentUser?.displayName ?? "No Name";
    // current user email
    final currentUserEmail = currentUser?.email ?? "No Email";
    debugPrint(currentUserName);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.black),
          title: Text(
            'Home',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          elevation: 0,
        ),
        drawer: Drawer(
          child: Container(
            margin: EdgeInsets.only(bottom: 20.h),
            child: Column(
              children: [
                // profile photo
                CustomDrawerHeader(
                  fullName: currentUserName,
                  email: currentUserEmail,
                  profileImageUrl: 'https://i.pravatar.cc/150?img=3',
                ),

                // settings
                CustomDrawerTile(
                  icon: Icons.settings,
                  title: 'Settings',
                  onTap: () {
                    // setting view
                    GoRouter.of(context).pushNamed("settings");
                  },
                ),

                // settings
                CustomDrawerTile(
                  icon: Icons.info,
                  title: 'Terms and privacy',
                  onTap: () {
                    // setting view
                    GoRouter.of(context).pushNamed("settings");
                  },
                ),

                // settings
                CustomDrawerTile(
                  icon: Icons.help_center,
                  title: 'Help and Support',
                  onTap: () {
                    // setting view
                    GoRouter.of(context).pushNamed("settings");
                  },
                ),

                // log out
                CustomDrawerTile(
                  icon: Icons.logout,
                  title: 'Logout',
                  onTap: () async {
                    final isSignedOut = await emailPasswordAuthProvider
                        .signOutUser(context);

                    if (isSignedOut) {
                      // auth login view
                      GoRouter.of(context).pushReplacementNamed("authLogin");
                    }
                  },
                ),

                const Spacer(),

                // app version info
                Text(
                  "Version 1.0.0",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: ColorName.primary,
                    fontSize: 10.sp,
                  ),
                ),
              ],
            ),
          ),
        ),
        body: Container(
          margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text("hi", style: TextStyle(fontSize: 18.sp))],
          ),
        ),
      ),
    );
  }
}
