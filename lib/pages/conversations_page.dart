import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tabee/pages/chat_page.dart';
import 'package:tabee/utils/lang.dart';
import 'package:tabee/widget/chat_list_view_item.dart';

class ConversationsPage extends StatefulWidget {
  @override
  _ConversationsPageState createState() => _ConversationsPageState();
}

class _ConversationsPageState extends State<ConversationsPage> {
  List<Map> chats = [
    {
      "chat_id": 1,
      "name": "Mohammed Osman",
      "newMessageCount": 3,
      "hasUnreadMessage": true,
      "lastMessage":
          "Lorem ipsum dolor sit amet. Sed pharetra ante a blandit ultrices.",
      "time": "19:27 PM",
      "image": "assets/images/person1.jpg",
    },
    {
      "chat_id": 1,
      "name": "Mohammed Osman",
      "newMessageCount": 3,
      "hasUnreadMessage": true,
      "lastMessage":
          "Lorem ipsum dolor sit amet. Sed pharetra ante a blandit ultrices.",
      "time": "19:27 PM",
      "image": "assets/images/person1.jpg",
    },
    {
      "chat_id": 1,
      "name": "Mohammed Osman",
      "newMessageCount": 3,
      "hasUnreadMessage": true,
      "lastMessage":
          "Lorem ipsum dolor sit amet. Sed pharetra ante a blandit ultrices.",
      "time": "19:27 PM",
      "image": "assets/images/person1.jpg",
    },
    {
      "chat_id": 1,
      "name": "Mohammed Osman",
      "newMessageCount": 3,
      "hasUnreadMessage": false,
      "lastMessage":
          "Lorem ipsum dolor sit amet. Sed pharetra ante a blandit ultrices.",
      "time": "19:27 PM",
      "image": "assets/images/person1.jpg",
    },
    {
      "chat_id": 1,
      "name": "Mohammed Osman",
      "newMessageCount": 3,
      "hasUnreadMessage": false,
      "lastMessage":
          "Lorem ipsum dolor sit amet. Sed pharetra ante a blandit ultrices.",
      "time": "19:27 PM",
      "image": "assets/images/person1.jpg",
    },
    {
      "chat_id": 1,
      "name": "Mohammed Osman",
      "newMessageCount": 3,
      "hasUnreadMessage": false,
      "lastMessage":
          "Lorem ipsum dolor sit amet. Sed pharetra ante a blandit ultrices.",
      "time": "19:27 PM",
      "image": "assets/images/person1.jpg",
    },
    {
      "chat_id": 1,
      "name": "Mohammed Osman",
      "newMessageCount": 3,
      "hasUnreadMessage": false,
      "lastMessage":
          "Lorem ipsum dolor sit amet. Sed pharetra ante a blandit ultrices.",
      "time": "19:27 PM",
      "image": "assets/images/person1.jpg",
    },
    {
      "chat_id": 1,
      "name": "Mohammed Osman",
      "newMessageCount": 3,
      "hasUnreadMessage": false,
      "lastMessage":
          "Lorem ipsum dolor sit amet. Sed pharetra ante a blandit ultrices.",
      "time": "19:27 PM",
      "image": "assets/images/person1.jpg",
    },
    {
      "chat_id": 1,
      "name": "Mohammed Osman",
      "newMessageCount": 3,
      "hasUnreadMessage": false,
      "lastMessage":
          "Lorem ipsum dolor sit amet. Sed pharetra ante a blandit ultrices.",
      "time": "19:27 PM",
      "image": "assets/images/person1.jpg",
    },
    {
      "chat_id": 1,
      "name": "Mohammed Osman",
      "newMessageCount": 3,
      "hasUnreadMessage": false,
      "lastMessage":
          "Lorem ipsum dolor sit amet. Sed pharetra ante a blandit ultrices.",
      "time": "19:27 PM"
    },
    {
      "chat_id": 1,
      "name": "Mohammed Osman",
      "newMessageCount": 3,
      "hasUnreadMessage": false,
      "lastMessage":
          "Lorem ipsum dolor sit amet. Sed pharetra ante a blandit ultrices.",
      "time": "19:27 PM",
      "image": "assets/images/person1.jpg",
    },
    {
      "chat_id": 1,
      "name": "Mohammed Osman",
      "newMessageCount": 3,
      "hasUnreadMessage": false,
      "lastMessage":
          "Lorem ipsum dolor sit amet. Sed pharetra ante a blandit ultrices.",
      "time": "19:27 PM",
      "image": "assets/images/person1.jpg",
    },
    {
      "chat_id": 1,
      "name": "Mohammed Osman",
      "newMessageCount": 3,
      "hasUnreadMessage": false,
      "lastMessage":
          "Lorem ipsum dolor sit amet. Sed pharetra ante a blandit ultrices.",
      "time": "19:27 PM",
      "image": "assets/images/person1.jpg",
    },
    {
      "chat_id": 1,
      "name": "Mohammed Osman",
      "newMessageCount": 3,
      "hasUnreadMessage": false,
      "lastMessage":
          "Lorem ipsum dolor sit amet. Sed pharetra ante a blandit ultrices.",
      "time": "19:27 PM",
      "image": "assets/images/person1.jpg",
    },
    {
      "chat_id": 1,
      "name": "Mohammed Osman",
      "newMessageCount": 3,
      "hasUnreadMessage": false,
      "lastMessage":
          "Lorem ipsum dolor sit amet. Sed pharetra ante a blandit ultrices.",
      "time": "19:27 PM",
      "image": "assets/images/person1.jpg",
    },
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        centerTitle: true,
        title: Text(
          lang.text("Chats"),
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.only(top: 8),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15.0),
              topRight: Radius.circular(15.0),
            )),
        child: ListView.separated(
          itemBuilder: (context, index) {
            return getChatRow(chats[index]);
          },
          separatorBuilder: (context, index) {
            return Divider(height: 0.5);
          },
          itemCount: chats.length,
        ),
      ),
    );
  }

  Widget getChatRow(Map chat) {
    return ChatListViewItem(
      name: chat["name"],
      newMessageCount: chat["newMessageCount"],
      hasUnreadMessage: chat["hasUnreadMessage"],
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return ChatPage(userId: chat["chat_id"].toString());
        }));
      },
      lastMessage: chat["lastMessage"],
      time: chat["time"],
      image: AssetImage(chat["image"] ?? "assets/images/person1.jpg"),
    );
  }
}
