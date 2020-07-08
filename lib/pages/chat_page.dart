import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tabee/utils/app_builder.dart';
import 'package:tabee/utils/lang.dart';
import 'package:tabee/widget/bubble.dart';
import 'package:tabee/widget/rounded_edit_text.dart';

class ChatPage extends StatefulWidget {
  final String userId;

  const ChatPage({Key key, @required this.userId}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<Map> chat;

  BubbleStyle styleSomebody;

  BubbleStyle styleMe;

  TextEditingController controller = new TextEditingController();

  ScrollController _scrollController = new ScrollController();


  @override
  void initState() {
    loadMessages();
    super.initState();
  }

  void loadMessages() async {
    chat = [
      {
        "from": "me",
        "to": "other",
        "time": "19:50 AM",
        "content": "Hello Mr. Mohammed Osman",
      },
      {
        "from": "me",
        "to": "other",
        "time": "19:50 AM",
        "content": "I would like to ask you some questions about my son",
      },
      {
        "from": "me",
        "to": "other",
        "time": "19:50 AM",
        "content": "If you are free",
      },
      {
        "from": "other",
        "to": "me",
        "time": "19:50 AM",
        "content": "Hello Mr. Yousif",
      },
      {
        "from": "other",
        "to": "me",
        "time": "19:50 AM",
        "content": "your son doing a great job",
      },
      {
        "from": "other",
        "to": "me",
        "time": "19:50 AM",
        "content":
            "Your son is very calm, non-contentious, regular in his lessons, his grades are among the highest in the class, I hope God will protect him for you",
      },
      {
        "from": "me",
        "to": "other",
        "time": "19:50 AM",
        "content": "It is even very annoying at home, annoying his brothers and neighbors lol",
      },
      {
        "from": "other",
        "to": "me",
        "time": "19:50 AM",
        "content": "I don't think so, he's so cute",
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    double pixelRatio = MediaQuery.of(context).devicePixelRatio;
    double px = 1 / pixelRatio;

    styleSomebody = BubbleStyle(
      nip: BubbleNip.leftTop,
      color: Colors.white,
      elevation: 1 * px,
      margin: BubbleEdges.only(top: 8.0, right: 50.0),
      alignment: Alignment.topLeft,
    );

    styleMe = BubbleStyle(
      nip: BubbleNip.rightTop,
      color: Color.fromARGB(255, 225, 255, 199),
      elevation: 1 * px,
      margin: BubbleEdges.only(top: 8.0, left: 50.0),
      alignment: Alignment.topRight,
    );
    return Scaffold(
      resizeToAvoidBottomInset: true,
      resizeToAvoidBottomPadding: true,
      appBar: null,
      body: Container(
        child: SafeArea(
          child: Stack(
            fit: StackFit.loose,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    height: 56,
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(16.0),
                            bottomRight: Radius.circular(16.0))),
                    child: Row(
                      children: <Widget>[
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(
                            Icons.chevron_left,
                            color: Colors.white,
                          ),
                        ),
                        CircleAvatar(
                          backgroundImage:
                              AssetImage("assets/images/person1.jpg"),
                        ),
                        SizedBox(width: 8.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                              "Mohammed Osman",
                              style: TextStyle(color: Colors.white),
                            ),
                            SizedBox(height: 8.0),
                            Text(
                              "Math teacher",
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                        Spacer(),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.call,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    fit: FlexFit.tight,
                    child: Container(
                      padding: const EdgeInsets.only(bottom: 64.0),
                      decoration: BoxDecoration(
                          color:
                              Theme.of(context).primaryColor.withOpacity(0.1),
                          image: DecorationImage(
                              image: AssetImage("assets/images/chat_pg.jpg"),
                              fit: BoxFit.cover,
                              colorFilter: ColorFilter.linearToSrgbGamma())),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Bubble(
                            alignment: Alignment.center,
                            color: Color.fromARGB(255, 212, 234, 244),
                            elevation: 1 * px,
                            margin: BubbleEdges.only(top: 8.0),
                            child:
                                Text('TODAY', style: TextStyle(fontSize: 10)),
                          ),
                          Flexible(
                            child: ListView.separated(
                              controller: _scrollController,
                              itemBuilder: (context, index) {
                                return buildMessageRow(chat[index]);
                              },
                              itemCount: chat.length,
                              shrinkWrap: true,
                              primary: false,
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                if (index == chat.length) {
                                  return SizedBox(
                                    height: 64.0,
                                  );
                                }
                                return Container();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: <Widget>[
                        Flexible(
                            child: RoundedEditText(
                          controller: controller,
                          hint: lang.text('Type a message'),
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.text,
                          attachFile: IconButton(
                            onPressed: () {
                              log("send attachments");
                            },
                            icon: Icon(
                              Icons.attach_file,
                              size: 30,
                              color: Theme.of(context).hintColor,
                            ),
                          ),
                        )),
                        SizedBox(width: 4.0),
                        InkWell(
                          child: CircleAvatar(
                            backgroundColor: Theme.of(context).primaryColor,
                            child: Icon(Icons.send, color: Colors.white),
                          ),
                          onTap: () {
                            sendMsg();
                          },
                        ),
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildMessageRow(Map chat) {
    return Bubble(
      style: chat["from"] == "me" ? styleMe : styleSomebody,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Text(
            chat["content"],
          ),
          SizedBox(height: 4),
          Text(
            chat["time"],
            style: TextStyle(fontSize: 12),
          ),
        ],
      ),
//      time: chat["time"].toString(),
    );
  }

  void sendMsg() async {
    log('Send: ${controller.text}');
    if (controller.text != null && controller.text.toString().isNotEmpty) {
      chat.add({
        "to": "other",
        "from": "me",
        "content": controller.text,
        "time": "10:25 AM",
      });
      Timer(
          Duration(milliseconds: 300),
          () => _scrollController
              .jumpTo(_scrollController.position.maxScrollExtent));
      controller.clear();
      setState(() {});
      AppBuilder.of(context).rebuild();
    }
  }
}
