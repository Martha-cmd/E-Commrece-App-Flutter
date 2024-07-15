import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:zenith_stores/admin/views/chat/vchat_screen.dart';
import 'package:zenith_stores/models/user.dart';


class UserItem extends StatefulWidget {
  const UserItem({super.key, required this.user});

  final vUserModel user;

  @override
  State<UserItem> createState() => _UserItemState();
}

class _UserItemState extends State<UserItem> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
                builder: (_) =>
                    vChatScreen(userId: widget.user.Id))),
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Stack(
            alignment: Alignment.bottomRight,
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage:
                    NetworkImage(widget.user.image),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: CircleAvatar(
                  backgroundColor: widget.user.isOnline
                      ? Colors.green
                      : Colors.grey,
                  radius: 5,
                ),
              ),
            ],
          ),
          title: Text(
            widget.user.name,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w400,
            ),
          ),
          subtitle: Text(
            'Last Active : ${timeago.format(widget.user.lastActive)}',
            maxLines: 2,
            style: const TextStyle(
              color: Colors.red,
              fontSize: 15,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      );
}
