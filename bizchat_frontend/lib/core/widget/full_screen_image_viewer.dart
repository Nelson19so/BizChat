import 'package:flutter/material.dart';

class FullScreenImageViewer extends StatelessWidget {
  // Change type from String to ImageProvider
  final ImageProvider imageProvider;

  const FullScreenImageViewer({super.key, required this.imageProvider});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Hero(
          tag: 'profile_pic_hero', // Keep this tag unique and matching
          child: InteractiveViewer(
            panEnabled: true,
            minScale: 0.5,
            maxScale: 4.0,
            child: Image(
              image: imageProvider, // Uses the provider directly
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
