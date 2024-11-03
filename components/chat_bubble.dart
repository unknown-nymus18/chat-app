import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:chatapp/services/chat/chat_service.dart';
import 'package:flutter/material.dart';
import 'package:slideable/slideable.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isCurrentUser;
  final String messageId;
  final String userId;
  final Function()? onReply;
  final String replyMessage;
  final String receiverId;

  const ChatBubble({
    super.key,
    required this.message,
    required this.isCurrentUser,
    required this.messageId,
    required this.userId,
    required this.onReply,
    required this.replyMessage,
    required this.receiverId,
  });

  void showOptions(BuildContext context, String messageId, String userId) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
            child: Wrap(
          children: [
            ListTile(
              leading: const Icon(
                Icons.flag,
                color: Colors.red,
              ),
              title: const Text(
                "Report",
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
              onTap: () => _reportMessage(context, messageId, userId),
            ),
            ListTile(
              leading: const Icon(Icons.cancel),
              title: const Text("Cancel"),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ));
      },
    );
  }

  void _reportMessage(BuildContext context, String messageId, String userID) {
    Navigator.pop(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Report Message"),
        content: const Text("Are you sure you want to report this message"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              try {
                Navigator.pop(context);
                ChatService().reportUser(messageId, userId);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    elevation: 0,
                    backgroundColor: Colors.transparent,
                    content: AwesomeSnackbarContent(
                      title: 'Success',
                      message: "Message has bee reported",
                      contentType: ContentType.success,
                    ),
                  ),
                );
              } catch (e) {
                String error = e.toString();
                error =
                    error.substring(error.lastIndexOf(']') + 1, error.length);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: AwesomeSnackbarContent(
                      title: 'Error',
                      message: error,
                      contentType: ContentType.failure,
                    ),
                  ),
                );
              }
            },
            child: const Text("Report"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        if (!isCurrentUser) {
          showOptions(context, messageId, userId);
        }
      },
      // onDoubleTap: () => _deleteChat(context, messageId, receiverId),
      child: Slideable(
        backgroundColor: Theme.of(context).colorScheme.surface,
        items: [
          ActionItems(
            backgroudColor: Theme.of(context).colorScheme.surface,
            icon: Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.keyboard_return,
                color: Theme.of(context).colorScheme.surface,
              ),
            ),
            onPress: onReply!,
          ),
        ],
        child: (replyMessage == '')
            ? Container(
                margin: isCurrentUser
                    ? const EdgeInsets.only(right: 5, left: 70, top: 10)
                    : const EdgeInsets.only(left: 5, right: 10, top: 10),
                padding: const EdgeInsets.only(
                    left: 20, right: 20, top: 15, bottom: 15),
                decoration: BoxDecoration(
                  color: isCurrentUser ? Colors.blue : Colors.green,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  message,
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                ),
              )
            : Container(
                margin: isCurrentUser
                    ? const EdgeInsets.only(right: 5, left: 70, top: 10)
                    : const EdgeInsets.only(left: 5, right: 10, top: 10),
                padding: const EdgeInsets.only(
                    left: 20, right: 20, top: 15, bottom: 15),
                decoration: BoxDecoration(
                  color: isCurrentUser ? Colors.blue : Colors.green,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: isCurrentUser
                            ? Colors.blue[400]
                            : Colors.green[400],
                      ),
                      child: Text(
                        replyMessage,
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.tertiary,
                        ),
                      ),
                    ),
                    Text(
                      message,
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
