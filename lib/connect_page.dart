import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:livekit_test/controller.dart';
import 'package:livekit_test/vertical_spacing.dart';

class ConnectPage extends StatefulWidget {
  const ConnectPage({super.key});

  @override
  State<ConnectPage> createState() => _ConnectPageState();
}

class _ConnectPageState extends State<ConnectPage> {
  final _url = TextEditingController(), _token = TextEditingController();

  @override
  void dispose() {
    _url.dispose();
    _token.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _url.text = "ws://localhost:7880";
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 300,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("LiveKit Server", style: Get.theme.textTheme.headlineMedium),
              TextField(
                decoration: const InputDecoration(
                  hintText: "URL",
                ),
                controller: _url,
              ),
              TextField(
                decoration: const InputDecoration(
                  hintText: "Token",
                ),
                controller: _token,
              ),
              verticalSpacing(defaultSpacing),
              ElevatedButton(
                onPressed: () {
                  Get.find<CallController>().connect(_url.text, _token.text);
                },
                child: const Text("Connect"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
