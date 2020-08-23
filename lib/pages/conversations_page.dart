import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tabee/pages/chat_page.dart';
import 'package:tabee/resources/repository.dart';
import 'package:tabee/utils/lang.dart';
import 'package:tabee/utils/pref_manager.dart';
import 'package:tabee/widget/chat_list_view_item.dart';
import 'package:tabee/widget/empty_widget.dart';
import 'package:tabee/widget/loading_widget.dart';

class ConversationsPage extends StatefulWidget {
  @override
  _ConversationsPageState createState() => _ConversationsPageState();
}

class _ConversationsPageState extends State<ConversationsPage> {
  final PrefManager _manager = new PrefManager();
  final Repository _repository = new Repository();

  List conversations = [];

  Map userData = {};
  bool loading = false;

  bool loadingContact = true;

  @override
  void initState() {
    loadConversations();
    getContacts();
    super.initState();
  }

  Future<void> loadConversations() async {
    setState(() {
      loading = true;
    });
    userData = json.decode(await _manager.get("customer", "{}"));
    if (userData == null || !userData.containsKey("id")) {
      return;
    }

    print('userData: $userData');
    Map response = await _repository.getThread(int.parse(userData["id"]));
    setState(() {
      loading = false;
    });
    print('threads: $response');
    if (response.containsKey("success") && response["success"]) {
      setState(() {
        conversations = (response["data"]);
      });
    } else {
      print(response["msg"]);
    }
  }

  List contacts = [];

  void getContacts() async {
    setState(() {
      loadingContact = true;
    });
    Map response = await _repository.getContacts(9);
    print('contact response: $response');
    setState(() {
      loadingContact = false;
    });
    if (response.containsKey("success") && response["success"]) {
      setState(() {
        contacts = response["available_contact"];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print('userData: $userData');
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
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Map contact = await showContactDialog();
          if (contact != null && contact.containsKey("customer_id")) {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return ChatPage(
                threadId: 0,
                toId: contact["customer_id"] ?? 0,
              );
            }));
          }
        },
        child: Icon(
          Icons.message,
          color: Colors.white,
        ),
      ),
      body: RefreshIndicator(
        onRefresh: loadConversations,
        child: Container(
          padding: const EdgeInsets.only(top: 8),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15.0),
                topRight: Radius.circular(15.0),
              )),
          child: loading
              ? Center(
                  child: LoadingWidget(
                    useLoader: true,
                    size: 24,
                  ),
                )
              : conversations.length > 0
                  ? ListView.separated(
                      itemBuilder: (context, index) {
                        return getChatRow(conversations[index]);
                      },
                      separatorBuilder: (context, index) {
                        return Divider(height: 0.5);
                      },
                      itemCount: conversations.length,
                    )
                  : Container(
                      child: Center(
                        child: EmptyWidget(
                          svgPath: "assets/icons/not-found.svg",
                          size: 64,
                          message: lang.text("No Conversations yet"),
                          subMessage: lang.text(
                              "To start conversation please press the button"),
                        ),
                      ),
                    ),
        ),
      ),
    );
  }

  Widget getChatRow(Map conversation) {
    Map lastMessage = conversation["list_msg"][0];
    print('Last message: $lastMessage');
    int unreadMessages = 0;
    (conversation["list_msg"] as List).forEach((element) {
      if (userData["id"].toString() != element["from"].toString() &&
          !element["readed"]) {
        unreadMessages++;
      }
    });

    return ChatListViewItem(
      name: conversation["thread_name"],
      newMessageCount: unreadMessages,
      hasUnreadMessage: unreadMessages > 0,
      onTap: () async {
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
          int to = -1;
          if (lastMessage["from"].toString() == userData["id"].toString()) {
            to = int.parse(lastMessage["to"].toString());
          } else {
            to = int.parse(lastMessage["from"].toString());
          }
          return ChatPage(
            threadId: conversation["thread_id"],
            toId: to,
          );
        }));
        await loadConversations();
      },
      lastMessage: lastMessage["msg"],
      showTick: lastMessage["from"].toString() == userData["id"].toString(),
      time: DateFormat('hh:mm a', lang.currentLanguage)
          .format(DateTime.parse(lastMessage["time"])),
      image: CachedNetworkImage(
        imageUrl: conversation["image"] ?? "assets/images/person1.jpg",
        placeholder: (error, url) => Image.asset(
          "assets/images/person1.jpg",
          width: 50,
          height: 50,
          fit: BoxFit.cover,
        ),
        width: 50,
        height: 50,
        fit: BoxFit.cover,
      ),
    );
  }

  Future<Map> showContactDialog() async {
    var contact = await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          content: Container(
            width: 330,
            child: getList(),
          ),
        );
      },
    );

    print('Selected contact: $contact');
    return contact;
  }

  Widget getList() {
    if (loadingContact) {
      return Container(
        padding: EdgeInsets.all(16.0),
        child: LoadingWidget(),
      );
    } else {
      if (contacts.length == 0) {
        return Container(
          padding: EdgeInsets.all(16.0),
          child: EmptyWidget(
            size: 128,
          ),
        );
      } else {
        return widgetList();
      }
    }
  }

  Widget widgetList() {
    print("$userData}");
    return ListView.separated(
      itemCount: contacts.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          child: ListTile(
            onTap: () {
              Navigator.of(context).pop(contacts[index]);
            },
            leading: CircleAvatar(
              child: CachedNetworkImage(
                imageUrl:
                    contacts[index]["image"] ?? "assets/images/person1.jpg",
                placeholder: (error, url) => Image.asset(
                  "assets/images/person1.jpg",
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
            ),
            title: Text(contacts[index]["customer_name"] ?? ""),
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return Divider(
          height: 1,
          color: Colors.grey,
        );
      },
    );
  }
}
