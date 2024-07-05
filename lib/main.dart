import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:livekit_test/connect_page.dart';
import 'package:livekit_test/controller.dart';

void main() {
  runApp(const MyApp());
  Get.put(CallController());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark(useMaterial3: true),
      home: const ConnectPage(),
    );
  }
}
