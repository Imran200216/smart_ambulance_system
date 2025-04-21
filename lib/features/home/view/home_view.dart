import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
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
  // OpenStreetMap controller
  final MapController mapController = MapController();

  // Search controller
  final TextEditingController searchController = TextEditingController();

  // This will store if the map is ready to be moved
  bool isMapReady = false;

  @override
  void initState() {
    super.initState();
    // Fetch current location when the widget is created
    final mapSearchProvider = Provider.of<MapSearchProvider>(
      context,
      listen: false,
    );

    // Fetch current location asynchronously
    mapSearchProvider.getCurrentLocation().then((_) {
      setState(() {
        // Set the map as ready once location is fetched
        isMapReady = true;
      });
    });
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

    // Current user details
    final User? currentUser = FirebaseAuth.instance.currentUser;
    final currentUserName = currentUser?.displayName ?? "No Name";
    final currentUserEmail = currentUser?.email ?? "No Email";

    return SafeArea(
      child: Scaffold(
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
                  ? TextField(
                    onSubmitted: (query) async {
                      await mapSearchProvider.searchPlace(query);
                    },
                    controller: searchController,
                    autofocus: true,
                    decoration: const InputDecoration(
                      hintText: 'Search...',
                      border: InputBorder.none,
                    ),
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
                  profileImageUrl: 'https://i.pravatar.cc/150?img=3',
                ),
                CustomDrawerTile(
                  icon: Icons.settings,
                  title: 'Settings',
                  onTap: () {
                    GoRouter.of(context).pushNamed("settings");
                  },
                ),
                CustomDrawerTile(
                  icon: Icons.info,
                  title: 'Terms and privacy',
                  onTap: () {
                    GoRouter.of(context).pushNamed("settings");
                  },
                ),
                CustomDrawerTile(
                  icon: Icons.help_center,
                  title: 'Help and Support',
                  onTap: () {
                    GoRouter.of(context).pushNamed("settings");
                  },
                ),
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
        body: Stack(
          children: [
            // Flutter Map
            FlutterMap(
              mapController: mapController,
              options: MapOptions(
                initialCenter:
                    mapSearchProvider.searchedLocation ??
                    const LatLng(11.9139, 79.8145),
                // Default to Puducherry
                initialZoom:
                    mapSearchProvider.searchedLocation != null ? 14 : 12,
                minZoom: 0,
                maxZoom: 100,
                interactionOptions: const InteractionOptions(
                  flags: InteractiveFlag.all,
                ),
              ),
              children: [
                TileLayer(
                  urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                ),
                // Current location layer
                if (isMapReady && mapSearchProvider.searchedLocation != null)
                  MarkerLayer(
                    markers: [
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
                    ],
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
