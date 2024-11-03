// import packages
import 'package:chatapp/components/profile_picture.dart';
import 'package:flutter/material.dart';

class UserTile extends StatelessWidget {
  final String text;
  final void Function()? onTap;
  final String receiverId;
  const UserTile({
    super.key,
    required this.text,
    required this.onTap,
    required this.receiverId,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(left: 25, right: 25, top: 25),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              ProfilePicture(
                size: 50,
                userId: receiverId,
              ),
              const SizedBox(
                width: 20,
              ),
              Text(
                text,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
