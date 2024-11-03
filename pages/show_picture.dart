import 'package:flutter/material.dart';

class ShowPicture extends StatelessWidget {
  final String imageUrl;
  const ShowPicture({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: Hero(
          tag: 'profilePicture',
          child: Image.network(
            imageUrl,
            fit: BoxFit.fitWidth,
          ),
        ),
      ),
    );
  }
}
