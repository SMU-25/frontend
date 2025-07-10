import 'package:flutter/material.dart';
import 'package:team_project_front/homecam/component/home_cam_view.dart';
import 'package:team_project_front/homecam/view/update_home_cam.dart';

class HomeCamScreen extends StatefulWidget {
  const HomeCamScreen({super.key});

  @override
  State<HomeCamScreen> createState() => _HomeCamScreenState();
}

class _HomeCamScreenState extends State<HomeCamScreen> {
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('홈캠', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, size: 30),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => UpdateHomeCamScreen()),
              );
            },
          ),
        ],
      ),

      body: const HomeCamView(),
    );
  }
}
