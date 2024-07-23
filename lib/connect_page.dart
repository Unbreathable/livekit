import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:livekit_test/controller.dart';
import 'package:livekit_test/vertical_spacing.dart';

class ConnectPage extends StatefulWidget {
  const ConnectPage({super.key});

  @override
  State<ConnectPage> createState() => _ConnectPageState();
}

class _ConnectPageState extends State<ConnectPage> {
  late final AudioPlayer _player;
  final _url = TextEditingController(), _token = TextEditingController();

  @override
  void initState() {
    _player = AudioPlayer();
    super.initState();
  }

  @override
  void dispose() {
    _player.dispose();
    _url.dispose();
    _token.dispose();
    super.dispose();
  }

  void playTest() async {
    await _player.setAudioSource(AudioSource.asset("assets/audio/test.wav"));
    await _player.play();
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
              verticalSpacing(defaultSpacing),
              ElevatedButton(
                onPressed: () => playTest(),
                child: const Text("Test other audio"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
