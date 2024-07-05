import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:livekit_test/controller.dart';
import 'package:livekit_test/vertical_spacing.dart';

class CallPage extends StatefulWidget {
  const CallPage({super.key});

  @override
  State<CallPage> createState() => _CallPageState();
}

class _CallPageState extends State<CallPage> {
  final _speakers = <MediaDevice>[].obs;
  final _microphones = <MediaDevice>[].obs;

  @override
  void initState() {
    Hardware.instance.audioInputs().then((l) => _updateMics(l));
    Hardware.instance.audioOutputs().then((l) => _updateSpeakers(l));
    super.initState();
  }

  void _updateMics(List<MediaDevice> devices) {
    _microphones.value = devices;
  }

  void _updateSpeakers(List<MediaDevice> devices) {
    _speakers.value = devices;
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CallController>();

    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 500,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Members", style: Get.textTheme.labelLarge),
              Obx(() {
                return Column(
                  children: List.generate(controller.members.length, (index) {
                    final member = controller.members[index];
                    return Padding(
                      padding: const EdgeInsets.only(top: defaultSpacing),
                      child: Obx(() => Text("Member ${member.participant.identity} ${member.talking.value}")),
                    );
                  }),
                );
              }),
              verticalSpacing(sectionSpacing),
              Text("Microphone", style: Get.textTheme.labelLarge),
              Obx(() {
                return Column(
                  children: List.generate(_microphones.length, (index) {
                    final device = _microphones[index];
                    return Padding(
                      padding: const EdgeInsets.only(top: defaultSpacing),
                      child: ElevatedButton(
                        onPressed: () {
                          Hardware.instance.selectAudioInput(device);
                          controller.room.setAudioInputDevice(device);
                        },
                        child: Text("Select ${device.label}"),
                      ),
                    );
                  }),
                );
              }),
              verticalSpacing(defaultSpacing),
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        controller.room.localParticipant!.setMicrophoneEnabled(
                          true,
                          audioCaptureOptions: const AudioCaptureOptions(
                            echoCancellation: false,
                            highPassFilter: false,
                          ),
                        );
                      },
                      child: const Text("Activate mic"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        controller.room.localParticipant!.setMicrophoneEnabled(false);
                      },
                      child: const Text("Deactivate mic"),
                    ),
                  ],
                ),
              ),
              verticalSpacing(sectionSpacing),
              Text("Speaker", style: Get.textTheme.labelLarge),
              Obx(() {
                return Column(
                  children: List.generate(_speakers.length, (index) {
                    final device = _speakers[index];
                    return Padding(
                      padding: const EdgeInsets.only(top: defaultSpacing),
                      child: ElevatedButton(
                        onPressed: () {
                          Hardware.instance.selectAudioOutput(device);
                          controller.room.setAudioOutputDevice(device);
                        },
                        child: Text("Select ${device.label}"),
                      ),
                    );
                  }),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
