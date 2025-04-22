import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:smart_ambulance_system/features/auth/auth_exports.dart';
import 'package:smart_ambulance_system/features/home/home_exports.dart';
import 'package:smart_ambulance_system/core/core_exports.dart';
import 'package:smart_ambulance_system/gen/colors.gen.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  // Search controller
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Fetch current location when the widget is created
    final mapSearchProvider = Provider.of<MapSearchProvider>(
      context,
      listen: false,
    );

    // Fetch current location asynchronously
    mapSearchProvider.getCurrentLocation();
  }

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Provider instances
    final employeeDetailsProvider = Provider.of<EmployeeDetailsProvider>(
      context,
    );
    final emailPasswordAuthProvider = Provider.of<EmailPasswordProvider>(
      context,
    );
    final searchToggleProvider = Provider.of<SearchToggleProvider>(context);
    final mapSearchProvider = Provider.of<MapSearchProvider>(context);
    final showRouteProvider = Provider.of<ShowRouteToggleProvider>(context);
    final emailLaunchProvider = Provider.of<EmailLauncherProvider>(context);
    final termsPrivacyProvider = Provider.of<TermsPrivacyLauncherProvider>(
      context,
    );
    final appVersionProvider = Provider.of<AppInfoProvider>(context);

    //////////////////////////

    // Current user details
    final User? currentUser = FirebaseAuth.instance.currentUser;
    final currentUserName = currentUser?.displayName ?? "No Name";
    final currentUserEmail = currentUser?.email ?? "No Email";

    // app version
    final appVersion = appVersionProvider.version;

    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (showRouteProvider.showRouteInputFields) {
              // Currently visible → hide + clear route
              showRouteProvider.toggleRouteFieldsVisibility();
              mapSearchProvider.clearRoute();
            } else {
              // Currently hidden → show input fields
              showRouteProvider.toggleRouteFieldsVisibility();
            }
          },

          backgroundColor: ColorName.primary,
          child: Icon(
            showRouteProvider.showRouteInputFields
                ? Icons.clear
                : Icons.location_city,
            color: ColorName.black,
          ),
        ),
        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.black),
          actions: [
            IconButton(
              icon: Icon(
                searchToggleProvider.isSearching ? Icons.close : Icons.search,
                color: Colors.black,
              ),
              onPressed: () {
                searchToggleProvider.toggleSearch();
                if (!searchToggleProvider.isSearching) {
                  searchController.clear();
                }
              },
            ),
          ],
          title:
              searchToggleProvider.isSearching
                  ? CustomSearchLocationTextField(
                    controller: searchController,
                    onSubmitted: (query) async {
                      await mapSearchProvider.searchPlace(query);
                    },
                  )
                  : Text(
                    'Home',
                    style: TextStyle(
                      color: ColorName.black,
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
                CustomDrawerHeader(
                  fullName: currentUserName,
                  email: currentUserEmail,
                  profileFirstUserName: currentUserEmail[0],
                ),

                // terms and privacy
                CustomDrawerTile(
                  icon: Icons.info,
                  title: 'Terms and privacy',
                  onTap: () {
                    termsPrivacyProvider.launchTermsOrPrivacy(
                      context: context,
                      url: "https://www.youtube.com/watch?v=OYCde4qKYCg&t=212s",
                    );
                  },
                ),

                // help center
                CustomDrawerTile(
                  icon: Icons.help_center,
                  title: 'Help and Support',
                  onTap: () {
                    emailLaunchProvider.sendEmail(
                      context: context,
                      mailId: "imranbabuji162002@gmail.com",
                      subject: "hi how are you",
                      message: "how are you, i think you should be fine",
                    );
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
                      GoRouter.of(context).pushReplacementNamed("onBoarding");
                    }
                  },
                ),
                const Spacer(),

                // app version
                Text(
                  appVersion,
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
        body: Stack(
          children: [
            // Flutter Map
            FlutterMap(
              mapController: mapSearchProvider.mapController,
              options: MapOptions(
                onMapReady: () {
                  mapSearchProvider.onMapReady();
                },
                initialCenter:
                    mapSearchProvider.searchedLocation ??
                    const LatLng(11.9139, 79.8145),
                initialZoom:
                    mapSearchProvider.searchedLocation != null ? 14 : 12,
                minZoom: 0,
                maxZoom: 100,
                interactionOptions: const InteractionOptions(
                  flags: InteractiveFlag.all,
                ),
                onTap: (tapPosition, point) {
                  if (mapSearchProvider.searchedLocation == null) {
                    mapSearchProvider.searchedLocation = point;
                  } else {
                    mapSearchProvider.findRoute(
                      mapSearchProvider.searchedLocation!,
                      point,
                    );
                  }
                },
              ),
              children: [
                TileLayer(
                  urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                ),

                if (mapSearchProvider.isMapReady &&
                    mapSearchProvider.searchedLocation != null)
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: mapSearchProvider.searchedLocation!,
                        width: 80,
                        height: 80,
                        child: Icon(
                          Icons.location_on,
                          size: 40,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),

                if (mapSearchProvider.routePoints.isNotEmpty)
                  PolylineLayer(
                    polylines: [
                      Polyline(
                        points: mapSearchProvider.routePoints,
                        strokeWidth: 4.0,
                        color: Colors.blueAccent,
                      ),
                    ],
                  ),
              ],
            ),

            // ⬇️ Your Conditional From/To Input Fields
            if (showRouteProvider.showRouteInputFields)
              Positioned(
                top: 20,
                left: 20,
                right: 20,
                child: Column(
                  children: [
                    // from location
                    CustomRouteMapTextField(
                      hintText: 'From location',
                      onChanged: (value) {},
                    ),

                    SizedBox(height: 10.h),

                    // to location
                    CustomRouteMapTextField(
                      hintText: 'To location',
                      onChanged: (value) {},
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
