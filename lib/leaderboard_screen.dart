import 'package:flutter/material.dart';

class LeaderboardPage extends StatelessWidget {
  final List<Map<String, String>> topVolunteers = [
    {"rank": "1", "name": "Aarav Sharma", "location": "Mumbai", "donations": "284"},
    {"rank": "2", "name": "Priya Patel", "location": "Delhi", "donations": "256"},
    {"rank": "3", "name": "Arjun Kumar", "location": "Bangalore", "donations": "248"},
    {"rank": "4", "name": "Zara Khan", "location": "Chennai", "donations": "235"},
    {"rank": "5", "name": "Advait Mehta", "location": "Pune", "donations": "227"},
    {"rank": "6", "name": "Riya Desai", "location": "Hyderabad", "donations": "215"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Top Volunteers'),
        backgroundColor: Colors.teal,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "Total Donations: 3764 meals shared",
              style: TextStyle(
                fontSize: 16,
                color: Colors.teal,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: topVolunteers.length,
              itemBuilder: (context, index) {
                final volunteer = topVolunteers[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 3,
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 20,
                      backgroundColor: _getRankColor(volunteer["rank"]!),
                      child: Text(
                        "#${volunteer["rank"]}",
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text(
                      volunteer["name"]!,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(volunteer["location"]!),
                    trailing: RichText(
                      textAlign: TextAlign.right,
                      text: TextSpan(
                        text: "${volunteer["donations"]}\n",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                        children: const [
                          TextSpan(
                            text: "donations",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.normal,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Color _getRankColor(String rank) {
    switch (rank) {
      case "1":
        return Colors.orange;
      case "2":
        return Colors.grey;
      case "3":
        return Colors.brown;
      default:
        return Colors.teal;
    }
  }
}
