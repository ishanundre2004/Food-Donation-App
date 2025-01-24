import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String username = "";
  String address = "Fetching location...";

  @override
  void initState() {
    super.initState();
    _fetchUsername();
    _fetchLocation();
  }

  Future<void> _fetchUsername() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final snapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        if (snapshot.exists) {
          setState(() {
            username = snapshot.data()?['name'] ?? "Unnamed User";
          });
        }
      }
    } catch (e) {
      print('Error fetching username: $e');
    }
  }

  Future<void> _fetchLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Location services are disabled. Exiting app.')),
      );
      Future.delayed(const Duration(seconds: 2), () => Navigator.pop(context));
      return;
    }

    // Check for location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Location permission denied. Exiting app.')),
        );
        Future.delayed(
            const Duration(seconds: 2), () => Navigator.pop(context));
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Location permissions are permanently denied. Exiting app.')),
      );
      Future.delayed(const Duration(seconds: 2), () => Navigator.pop(context));
      return;
    }

    // Get the current position
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      // Use reverse geocoding to get the address
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        setState(() {
          address =
              "${place.name},\n${place.subLocality}, ${place.locality}, ${place.administrativeArea}, ${place.postalCode}";
        });
      } else {
        setState(() {
          address = "Unable to fetch address.";
        });
      }
    } catch (e) {
      print('Error fetching location: $e');
      setState(() {
        address = "Error fetching address.";
      });
    }
  }

  void _navigateToProfile() {
    Navigator.pushNamed(context, '/profile');
  }

  void _logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    } catch (e) {
      print('Error logging out: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Row(
      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //     children: [
      //       Column(
      //         crossAxisAlignment: CrossAxisAlignment.start,
      //         children: [
      //           Text(username, style: const TextStyle(fontSize: 16)),
      //           const Text("Andheri, Mumbai", style: TextStyle(fontSize: 14)),
      //         ],
      //       ),
      //       FloatingActionButton(
      //         onPressed: () {
      //           _navigateToProfile();
      //         },
      //         child: const Icon(Icons.person),
      //       ),
      //     ],
      //   ),
      //   backgroundColor: Colors.transparent,
      //   elevation: 0,
      // ),
      body: Expanded(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Text(username, style: const TextStyle(fontSize: 16)),
                        Text(address, style: const TextStyle(fontSize: 14)),
                      ],
                    ),
                    FloatingActionButton(
                      onPressed: () {
                        _navigateToProfile();
                      },
                      child: const Icon(Icons.person),
                    ),
                  ],
                ),
              ),
              Text(
                "Hello, $username",
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "There are 6 NGO's near your location",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.teal,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: [
                    _buildNGOCard(
                      "Feeding India",
                      "Aundh, Pune",
                      "250 People/Day",
                      "4:00 PM - 10:00 PM",
                      "lib/assets/1.jpeg",
                      "1000+ Members",
                    ),
                    _buildNGOCard(
                      "Helping Hands",
                      "Koregaon Park, Pune",
                      "300 People/Day",
                      "10:00 AM - 6:00 PM",
                      "lib/assets/1.jpeg",
                      "800+ Members",
                    ),
                    _buildNGOCard(
                      "Smile Foundation",
                      "Baner, Pune",
                      "150 Children/Day",
                      "9:00 AM - 5:00 PM",
                      "lib/assets/1.jpeg",
                      "500+ Members",
                    ),
                    _buildNGOCard(
                      "Udaan Welfare",
                      "Hingane, Pune",
                      "200 People/Day",
                      "11:00 AM - 7:00 PM",
                      "lib/assets/1.jpeg",
                      "600+ Members",
                    ),
                    _buildNGOCard(
                      "Green Earth",
                      "MG Road, Pune",
                      "500 Trees/Month",
                      "7:00 AM - 3:00 PM",
                      "lib/assets/1.jpeg",
                      "1200+ Members",
                    ),
                    _buildNGOCard(
                      "Care & Share",
                      "Dhayari, Pune",
                      "100 People/Day",
                      "12:00 PM - 8:00 PM",
                      "lib/assets/1.jpeg",
                      "400+ Members",
                    ),
                    // Other NGO cards...
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.leaderboard), label: 'LeaderBoard'),
          BottomNavigationBarItem(
              icon: Icon(Icons.add_circle), label: 'Add Donation'),
        ],
        selectedItemColor: Colors.teal,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _logout,
        child: const Icon(Icons.logout),
      ),
    );
  }

  Widget _buildNGOCard(
    String title,
    String location,
    String peoplePerDay,
    String time,
    String imagePath,
    String members,
  ) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.asset(
              imagePath,
              height: 100,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(location, style: const TextStyle(color: Colors.grey)),
                const SizedBox(height: 4),
                Text(peoplePerDay),
                Text(time),
                const SizedBox(height: 4),
                Text(members, style: const TextStyle(color: Colors.teal)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
