import 'package:flutter/material.dart';
import 'package:team_project_front/homecam/component/home_cam_view.dart';
import 'package:team_project_front/homecam/component/no_home_cam_view.dart';
import 'package:team_project_front/homecam/model/home_cam.dart';

class HomeCamScreen extends StatefulWidget {
  const HomeCamScreen({super.key});

  @override
  State<HomeCamScreen> createState() => _HomeCamScreenState();
}

class _HomeCamScreenState extends State<HomeCamScreen> {
  DateTime selectedDate = DateTime.now();

  HomeCam? homeCam;

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: homeCam != null ? HomeCamView() : NoHomeCamView());
  }
}
