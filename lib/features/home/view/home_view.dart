import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
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

    // Fetch near by Hospital location based on their current location
    mapSearchProvider.fetchNearbyHospitals();
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
    final addAmbulanceAddressStatusProvider =
        Provider.of<AddAmbulanceAddressStatusProvider>(context);

    //////////////////////////

    // Current user details
    final User? currentUser = FirebaseAuth.instance.currentUser;
    final currentUserName = currentUser?.displayName ?? "No Name";
    final currentUserEmail = currentUser?.email ?? "No Email";
    final currentUserUid = currentUser?.uid ?? "No UID";

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
                // user profile letter, username, user email
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
                    try {
                      // Sign out via provider
                      final isSignedOut = await emailPasswordAuthProvider
                          .signOutUser(context);

                      // Access Hive boxes
                      final authBox = Hive.box<bool>('userAuthBox');
                      final onBoardingBox = Hive.box<bool>('userOnBoardingBox');

                      // Update Hive values
                      await onBoardingBox.put('userOnBoardingStatus', false);
                      await authBox.put('userAuthStatus', false);

                      if (isSignedOut) {
                        // Show a success toast
                        SnackBarHelper.showSnackBar(
                          context: context,
                          leadingIcon: Icons.logout,
                          backgroundColor: SnackBarHelper.successColor,
                          message: "Logged out successfully",
                        );

                        // on boarding view
                        GoRouter.of(context).pushReplacementNamed("onBoarding");
                      } else {
                        // failure snack bar
                        SnackBarHelper.showSnackBar(
                          context: context,
                          leadingIcon: Icons.error,
                          backgroundColor: SnackBarHelper.errorColor,
                          message: "Logout failed",
                        );
                      }
                    } catch (e) {
                      print("Logout error: $e");
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
                    mapSearchProvider.findRouteFromTo(
                      mapSearchProvider.searchedLocation!,
                      point,
                    );
                  }
                },
              ),
              children: [
                // Base map
                TileLayer(
                  urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                ),

                // Markers (search location + hospitals)
                if (mapSearchProvider.isMapReady &&
                    mapSearchProvider.searchedLocation != null)
                  MarkerLayer(
                    markers: [
                      // Search location marker
                      Marker(
                        point: mapSearchProvider.searchedLocation!,
                        width: 80,
                        height: 80,
                        child: Icon(
                          Icons.location_on,
                          size: 40,
                          color: ColorName.black,
                        ),
                      ),

                      // Hospital markers
                      ...mapSearchProvider.nearbyHospitals.map((hospital) {
                        final LatLng hospitalLocation = LatLng(
                          hospital.latitude,
                          hospital.longitude,
                        );
                        final bool isSelected =
                            mapSearchProvider.selectedHospitalLocation !=
                                null &&
                            mapSearchProvider.selectedHospitalLocation ==
                                hospitalLocation;

                        return Marker(
                          point: hospitalLocation,
                          width: 40,
                          height: 40,
                          child: GestureDetector(
                            onTap: () {
                              mapSearchProvider.selectHospitalAndFindRoute(
                                hospitalLocation,
                              );
                            },
                            onDoubleTap: () {
                              // Double tap: ask for confirmation
                              showDialog(
                                context: context,
                                builder: (BuildContext dialogContext) {
                                  return AlertDialog(
                                    title: Text('Confirm Navigation'),
                                    content: Text(
                                      'Are you sure you want to navigate to ${hospital.name}?',
                                    ),
                                    actions: [
                                      // cancel txt btn
                                      TextButton(
                                        onPressed: () {
                                          GoRouter.of(
                                            dialogContext,
                                          ).pop(); // Cancel
                                        },
                                        child: Text('Cancel'),
                                      ),

                                      // confirm text
                                      TextButton(
                                        onPressed: () {
                                          // want to store the ambulance status to the fire store
                                          addAmbulanceAddressStatusProvider
                                              .saveStatus(
                                                employeeEmail: currentUserEmail,
                                                employeeId: currentUserUid,
                                                hospitalName: hospital.name,
                                                hospitalAddress: hospital.name,
                                                context: context,
                                              );

                                          // pop the dialog
                                          Navigator.of(dialogContext).pop();

                                          // find the hospital route
                                          mapSearchProvider
                                              .selectHospitalAndFindRoute(
                                                hospitalLocation,
                                              ); // Start navigation
                                        },
                                        child: Text('Confirm'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: Tooltip(
                              message:
                                  '${hospital.name}\n${hospital.distanceInKm.toStringAsFixed(2)} km away',
                              child: Icon(
                                Icons.local_hospital,
                                color: isSelected ? Colors.green : Colors.red,
                                size: isSelected ? 36 : 30,
                              ),
                            ),
                          ),
                        );
                      }),
                    ],
                  ),

                // Polyline route
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
            Consumer2<ShowRouteToggleProvider, MapSearchProvider>(
              builder: (context, showRouteProvider, mapSearchProvider, _) {
                return Stack(
                  children: [
                    if (showRouteProvider.showRouteInputFields)
                      Positioned(
                        top: 20,
                        left: 20,
                        right: 20,
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 20.w),
                          child: Column(
                            spacing: 8.h,
                            children: [
                              CustomRouteMapTextField(
                                controller: mapSearchProvider.fromController,
                                hintText: 'From location',
                                onChanged: (value) {
                                  mapSearchProvider.convertAddressToLatLng(
                                    value,
                                    isFrom: true,
                                  );
                                },
                              ),
                              CustomRouteMapTextField(
                                controller: mapSearchProvider.toController,
                                hintText: 'To location',
                                onChanged: (value) {
                                  mapSearchProvider.convertAddressToLatLng(
                                    value,
                                    isFrom: false,
                                  );
                                },
                              ),
                              if (mapSearchProvider.calculatedDistance != null)
                                Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12.r),
                                    color: ColorName.white,
                                  ),
                                  child: Container(
                                    margin: EdgeInsets.symmetric(
                                      horizontal: 12.h,
                                      vertical: 12.w,
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Icon(
                                          Icons.directions,
                                          color: ColorName.primary,
                                          size: 22.h,
                                        ),
                                        SizedBox(width: 10.w),
                                        Column(
                                          spacing: 8.h,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            // From location and to location
                                            Text(
                                              'From: ${mapSearchProvider.fromController.text}\nTo: ${mapSearchProvider.toController.text}',
                                              style: TextStyle(
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.bold,
                                                color: ColorName.black,
                                              ),
                                            ),

                                            // calculated distance
                                            Text(
                                              '${mapSearchProvider.calculatedDistance!.toStringAsFixed(2)} km',
                                              style: TextStyle(
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.w600,
                                                color: ColorName.primary,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
