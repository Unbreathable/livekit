import 'package:get/get.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:livekit_test/call_page.dart';
import 'package:livekit_test/vertical_spacing.dart';

class CallController extends GetxController {
  final members = <Member>[].obs;

  final room = Room();

  void connect(String url, String token) async {
    //final keyProvider = await BaseKeyProvider.create();
    await room.connect(
      url,
      token,
    );
    //await keyProvider.setKey("hello hello");

    // Add self
    members.add(Member(room.localParticipant!));

    // Add everyone already in the room
    for (var part in room.remoteParticipants.values) {
      members.add(Member(part));

      // Subscribe to their audio tracks
      // part.audioTrackPublications.firstOrNull?.subscribe();
    }

    // Create listener
    room.createListener()
      ..on<ParticipantConnectedEvent>((e) {
        if (e.participant.identity == room.localParticipant!.identity) {
          sendLog("connection event called for self");
          return;
        }
        members.add(Member(e.participant));
        sendLog("member connected ${e.participant.identity}");
      })
      ..on<ParticipantDisconnectedEvent>((e) {
        sendLog("member disconencted ${e.participant.identity}");
        members.removeWhere((mem) => mem.participant.identity == e.participant.identity);
      })
      ..on<TrackPublishedEvent>((e) {
        sendLog("member ${e.participant.identity} published a track of kind ${e.publication.kind}");
        final member = members.firstWhereOrNull((mem) => mem.participant.identity == e.participant.identity);
        if (member == null) {
          sendLog("member wasn't found?");
          return;
        }
      })
      ..on<TrackUnpublishedEvent>((e) {
        sendLog("member ${e.participant.identity} unpublished a track of kind ${e.publication.kind}");
        final member = members.firstWhereOrNull((mem) => mem.participant.identity == e.participant.identity);
        if (member == null) {
          sendLog("member wasn't found?");
          return;
        }
      })
      ..on<ActiveSpeakersChangedEvent>((e) {
        if (e.speakers.isEmpty) {
          for (var member in members) {
            member.talking.value = false;
          }
          sendLog("no-one speaking");
        } else {
          for (var speaker in e.speakers) {
            final member = members.firstWhere((mem) => mem.participant.identity == speaker.identity);
            member.talking.value = true;
          }
          sendLog("currently speaking: ${e.speakers.first.identity}");
        }
      });

    // Open the room page
    Get.offAll(const CallPage());
  }
}

class Member {
  final talking = false.obs;
  Participant participant;

  Member(this.participant);
}
