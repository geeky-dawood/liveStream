import 'package:face_recognization/features/agora/view/live_stream_view.dart';
import 'package:flutter/material.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Role"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LiveStreamingPage(
                      isHost: true,
                    ),
                  ),
                );
              },
              child: const Text("Join as Host"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LiveStreamingPage(
                      isHost: false,
                    ),
                  ),
                );
              },
              child: const Text("Join as Viewer"),
            ),
          ],
        ),
      ),
    );
  }
}
