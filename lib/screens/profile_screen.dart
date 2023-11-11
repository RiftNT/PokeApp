import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trainer Profile'),
        backgroundColor: Colors.red,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 80,
              backgroundImage: AssetImage('assets/images/profile_picture.png'),
            ),
            SizedBox(height: 20),
            Text(
              'Ash Ketchum',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Badge(icon: Icons.star, label: 'Pikachu Fan'),
                SizedBox(width: 10),
                Badge(icon: Icons.star, label: 'Charizard Trainer'),
                SizedBox(width: 10),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class Badge extends StatelessWidget {
  final IconData icon;
  final String label;

  const Badge({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.yellow, size: 30),
        SizedBox(width: 5),
        Text(label),
      ],
    );
  }
}
