// ignore_for_file: use_build_context_synchronously

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reaction_button/flutter_reaction_button.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../constants/app_constants.dart';
import '../../../utils/reaction_emoji.dart';

class LiveStreamingPage extends StatefulWidget {
  final bool isHost;

  const LiveStreamingPage({super.key, required this.isHost});

  @override
  State<LiveStreamingPage> createState() => _LiveStreamingPageState();
}

class _LiveStreamingPageState extends State<LiveStreamingPage> {
  late RtcEngine _engine;
  bool _permissionGranted = false;
  bool _isInitialized = false;
  final Set<int> _users = {};
  int? _hostUid;
  bool _isAnimationPlaying = false;

  Future<void> initAgora() async {
    // Only request permissions for host
    if (widget.isHost) {
      await [Permission.camera, Permission.microphone].request().then((statuses) {
        final allGranted = statuses.values.every((status) => status.isGranted);
        setState(() {
          _permissionGranted = allGranted;
        });
      });

      if (!_permissionGranted) {
        debugPrint('Permissions not granted');
        return;
      }
    } else {
      setState(() {
        _permissionGranted = true;
      });
    }

    try {
      _engine = createAgoraRtcEngine();

      await _engine.initialize(
        const RtcEngineContext(
          appId: AppConstants.appId,
          channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
        ),
      );

      if (widget.isHost) {
        await _engine.setVideoEncoderConfiguration(
          VideoEncoderConfiguration(
            dimensions: VideoDimensions(
              width: MediaQuery.of(context).size.height.toInt(),
              height: MediaQuery.of(context).size.height.toInt(),
            ),
            frameRate: 30,
            bitrate: 1500,
          ),
        );
      }

      _engine.registerEventHandler(
        RtcEngineEventHandler(
          onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
            debugPrint('Successfully joined channel with uid: ${connection.localUid}');
            setState(() {
              if (widget.isHost) {
                _hostUid = connection.localUid;
                _users.add(connection.localUid!);
              }
            });
          },
          onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
            debugPrint("Remote user $remoteUid joined");
            setState(() {
              _users.add(remoteUid);
              if (!widget.isHost && _hostUid == null) {
                _hostUid = remoteUid;
              }
            });
          },
          onUserOffline: (RtcConnection connection, int remoteUid, UserOfflineReasonType reason) {
            debugPrint("Remote user $remoteUid left");
            setState(() {
              _users.remove(remoteUid);
              if (remoteUid == _hostUid) {
                _hostUid = null;
              }
            });
          },
          onError: (err, msg) {
            debugPrint('Error: $err, $msg');
          },
        ),
      );

      // Configure client role
      if (widget.isHost) {
        await _engine.enableVideo();
        await _engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
        try {
          await _engine.startPreview();
        } catch (e) {
          debugPrint('Preview failed: $e');
        }
      } else {
        await _engine.setClientRole(role: ClientRoleType.clientRoleAudience);
      }

      await _engine.joinChannel(
        token: AppConstants.token,
        channelId: AppConstants.channel,
        options: ChannelMediaOptions(
          autoSubscribeVideo: true,
          autoSubscribeAudio: true,
          publishCameraTrack: widget.isHost,
          publishMicrophoneTrack: widget.isHost,
          clientRoleType:
              widget.isHost ? ClientRoleType.clientRoleBroadcaster : ClientRoleType.clientRoleAudience,
          audienceLatencyLevel: AudienceLatencyLevelType.audienceLatencyLevelUltraLowLatency,
        ),
        uid: 0,
      );

      setState(() {
        _isInitialized = true;
      });
    } catch (e) {
      debugPrint('Error initializing Agora: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    initAgora();
  }

  @override
  void dispose() {
    _dispose();
    super.dispose();
  }

  final defaultInitialReaction = const Reaction<String>(
    value: null,
    icon: Icon(
      Icons.favorite_border,
      color: Colors.black,
      size: 30,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.5),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(widget.isHost ? 'Live Streaming - Host' : 'Live Streaming - Viewer'),
        backgroundColor: Colors.red,
      ),
      body: _permissionGranted
          ? _isInitialized
              ? SafeArea(
                  child: Column(
                    children: [
                      Expanded(
                        child: _buildHostView(),
                      ),
                    ],
                  ),
                )
              : const Center(
                  child: CircularProgressIndicator(),
                )
          : const Center(
              child: Text('Permissions not granted'),
            ),
    );
  }

  Widget _buildHostView() {
    if (!widget.isHost && _hostUid == null) {
      return const Center(
        child: Text(
          'Waiting for host to start streaming...',
          style: TextStyle(fontSize: 18),
        ),
      );
    }

    if (_hostUid == null && !widget.isHost) {
      return const Center(
        child: Text(
          'Stream has been closed.',
          style: TextStyle(fontSize: 18, color: Colors.redAccent),
        ),
      );
    }

    return Stack(
      children: [
        AgoraVideoView(
          controller: VideoViewController(
            rtcEngine: _engine,
            canvas: VideoCanvas(
              uid: widget.isHost ? 0 : _hostUid,
              renderMode: RenderModeType.renderModeHidden,
              mirrorMode: VideoMirrorModeType.videoMirrorModeAuto,
            ),
          ),
        ),
        Positioned(
          top: 16,
          left: 16,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.7),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              children: [
                Icon(Icons.circle, color: Colors.white, size: 12),
                SizedBox(width: 8),
                Text(
                  'LIVE',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 16,
          right: 16,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.black45,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.remove_red_eye,
                  color: Colors.white,
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  widget.isHost ? '${_users.length - 1}' : '${_users.length}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 10,
          right: 20,
          child: ReactionButton<String>(
            itemSize: const Size.square(40),
            onReactionChanged: (Reaction<String>? reaction) {
              setState(() {
                _isAnimationPlaying = true;
              });
              debugPrint('Selected value------------------: ${reaction?.value}');
            },
            reactions: reactions,
            placeholder: defaultInitialReaction,
            selectedReaction: reactions.first,
          ),
        ),
        if (_isAnimationPlaying)
          Lottie.asset(
            'assets/animations/love_animation.json',
            onLoaded: (composition) {
              Future.delayed(const Duration(seconds: 2), () {
                setState(() {
                  _isAnimationPlaying = false;
                });
              });
            },
          ),
      ],
    );
  }

  Future<void> _dispose() async {
    try {
      if (widget.isHost) {
        await _engine.stopPreview();
      }
      await _engine.leaveChannel();
      await _engine.release();
    } catch (e) {
      debugPrint('Error disposing Agora engine: $e');
    }
  }
}
