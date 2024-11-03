import 'package:chatapp/pages/show_picture.dart';
import 'package:chatapp/services/storage/image_storage.dart';
import 'package:flutter/material.dart';

class ProfilePicture extends StatefulWidget {
  final double size;
  final String userId;
  const ProfilePicture({
    super.key,
    required this.size,
    required this.userId,
  });

  @override
  State<ProfilePicture> createState() => _ProfilePictureState();
}

class _ProfilePictureState extends State<ProfilePicture> {
  final ImageStorage _imageStorage = ImageStorage();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(2),
      height: widget.size,
      width: widget.size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Theme.of(context).colorScheme.secondary,
      ),
      child: FutureBuilder(
        future: _imageStorage.retrieveImageUser(widget.userId),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Icon(
              Icons.person,
              color: Theme.of(context).colorScheme.surface,
              size: widget.size - 20,
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Icon(
              Icons.person,
              color: Theme.of(context).colorScheme.surface,
              size: widget.size - 20,
            );
          }
          if (snapshot.data! == '') {
            return Icon(
              Icons.person,
              color: Theme.of(context).colorScheme.surface,
              size: widget.size - 20,
            );
          }
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ShowPicture(imageUrl: snapshot.data!),
                ),
              );
            },
            child: ClipOval(
              child: Hero(
                tag: 'profilePicture',
                child: Image.network(
                  snapshot.data!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.person,
                      color: Theme.of(context).colorScheme.surface,
                      size: widget.size - 20,
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
