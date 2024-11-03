import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:chatapp/components/profile_picture.dart';
import 'package:chatapp/services/chat/chat_service.dart';
import 'package:flutter/material.dart';

class ChatSettings extends StatefulWidget {
  final String receiverName;
  final String receiverId;
  final String receiverEmail;
  final bool friend;

  const ChatSettings({
    super.key,
    required this.receiverName,
    required this.receiverId,
    required this.receiverEmail,
    required this.friend,
  });

  @override
  State<ChatSettings> createState() => _ChatSettingsState();
}

class _ChatSettingsState extends State<ChatSettings> {
  final ChatService _chatService = ChatService();

  ValueNotifier<String> imageSrc = ValueNotifier<String>('');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          const SizedBox(
            height: 20,
          ),
          Center(
            child: ProfilePicture(size: 150, userId: widget.receiverId),
          ),
          const SizedBox(
            height: 20,
          ),
          Center(
            child: Text(
              widget.receiverName,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          infoTile(
            context: context,
            title: 'Name',
            info: Text(widget.receiverName),
          ),
          infoTile(
            context: context,
            title: "Block ${widget.receiverName}",
            info: const Icon(
              Icons.delete,
              color: Colors.red,
            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text("Block ${widget.receiverName}"),
                    content: const Text("Do you want to block the user?"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Cancel"),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                          _chatService.blockuser(widget.receiverId);
                        },
                        child: const Text("Block"),
                      ),
                    ],
                  );
                },
              );
            },
          ),
          !widget.friend
              ? infoTile(
                  context: context,
                  title: 'Add ${widget.receiverName}',
                  info: const Icon(Icons.add),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text("Add User"),
                          content: const Text("Do you want to add the user?"),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text("Cancel"),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                try {
                                  _chatService.addUser(
                                    widget.receiverEmail,
                                    widget.receiverName,
                                    widget.receiverId,
                                  );
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                } catch (e) {
                                  String error = e.toString();
                                  error = error.substring(
                                      error.lastIndexOf(']') + 1, error.length);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor: Colors.transparent,
                                      elevation: 0,
                                      content: AwesomeSnackbarContent(
                                        title: 'Error',
                                        message: error,
                                        contentType: ContentType.failure,
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: const Text("Add"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                )
              : infoTile(
                  context: context,
                  title: "Remove ${widget.receiverName}",
                  info: const Icon(Icons.remove_circle_outline),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text("Remove ${widget.receiverName}"),
                          content: Text(
                              "Are you sure you want to remove ${widget.receiverName}"),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                try {
                                  _chatService.removeUser(widget.receiverId);
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                } catch (e) {
                                  String error = e.toString();
                                  error = error.substring(
                                      error.lastIndexOf(']') + 1, error.length);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: SnackBar(
                                        content: AwesomeSnackbarContent(
                                          title: 'Error',
                                          message: error,
                                          contentType: ContentType.failure,
                                        ),
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: const Text("Remove"),
                            ),
                          ],
                        );
                      },
                    );
                  }),
        ],
      ),
    );
  }

  Widget infoTile({
    required BuildContext context,
    required String title,
    required Widget info,
    Function()? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            info
          ],
        ),
      ),
    );
  }
}
