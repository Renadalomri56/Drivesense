import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import '../../app/services/firebase_realtime_db.dart';

class PiCameraStream extends StatefulWidget {
  const PiCameraStream({super.key});

  @override
  State<PiCameraStream> createState() => _PiCameraStreamState();
}

class _PiCameraStreamState extends State<PiCameraStream> {
  final _remoteRenderer = RTCVideoRenderer();
  RTCPeerConnection? _pc;
  final FirebaseDatabaseHelper _databaseHelper =
      FirebaseDatabaseHelper.instance;

  @override
  void initState() {
    super.initState();
    _initRenderer();
    _connectToPi();
  }

  Future<void> _initRenderer() async {
    await _remoteRenderer.initialize();
  }

  Future<void> _connectToPi() async {
    final config = {
      'iceServers': [
        {'urls': 'stun:stun.l.google.com:19302'},
      ],
    };

    _pc = await createPeerConnection(config);

    // When Pi sends a video track, attach it to the renderer
    _pc!.onTrack = (event) {
      if (event.track.kind == 'video' && event.streams.isNotEmpty) {
        setState(() {
          _remoteRenderer.srcObject = event.streams[0];
        });
      }
    };

    final offer = await _pc!.createOffer();
    await _pc!.setLocalDescription(offer);

    final liveMap = await _databaseHelper.read("live");
    final url = Uri.parse("${liveMap['url']}/offer");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"sdp": offer.sdp, "type": offer.type}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final answer = RTCSessionDescription(data["sdp"], data["type"]);
      await _pc!.setRemoteDescription(answer);
    } else {
      print("❌ Failed to connect: ${response.statusCode} ${response.body}");
    }
  }

  @override
  void dispose() {
    _remoteRenderer.dispose();
    _pc?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.greenAccent, width: 3),
      ),
      child: ClipOval(
        child: SizedBox.square(
          dimension: 200,
          child: RTCVideoView(
            _remoteRenderer,
            placeholderBuilder: (context) => Center(
              child: Lottie.asset(
                'assets/lottie/camera.json',
                height: 200,
                width: 200,
                fit: BoxFit.cover,
              ),
            ),
            objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
          ),
        ),
      ),
    );
  }
}
