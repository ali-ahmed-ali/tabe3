import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tabee/resources/repository.dart';
import 'package:tabee/utils/app_builder.dart';
import 'package:tabee/utils/lang.dart';
import 'package:tabee/utils/pref_manager.dart';
import 'package:tabee/utils/utils.dart';
import 'package:tabee/widget/bubble.dart';
import 'package:tabee/widget/rounded_edit_text.dart';

class ChatPage extends StatefulWidget {
  final int threadId;
  final toId;
  final toName;
  final Map<String, dynamic> thread;
  final Map<String, dynamic> customer;

  const ChatPage(
      {Key key,
      @required this.threadId,
      this.toId = -1,
      this.toName,
      this.thread,
      this.customer})
      : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List chat = [];
  String threadName = lang.text("Loading name");

  BubbleStyle styleSomebody;

  BubbleStyle styleMe;

  TextEditingController controller = new TextEditingController();

  ScrollController _scrollController = new ScrollController();

  Map userData = {};

  final int SENDING_STATE = 1;
  final int ERROR_STATE = 2;
  final int READED_STATE = 3;

  final Repository _repository = new Repository();
  final PrefManager _manager = new PrefManager();

  bool loading = false;

  int from = -1;

  Map<String, dynamic> message = {};

  bool sending = false, error = false;

  int firstUnreadMsg = 0, unreadMsgCount = 0;

  Timer _timer;

  @override
  void initState() {
//    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
    print('Conversation: ${widget.thread}');
    print('Customer: ${widget.customer}');
    print('Thread_ID: ${widget.threadId}');
    loadMessages();
//    });
    super.initState();
  }

  @override
  void dispose() {
    if (_timer != null) {
      _timer.cancel();
    }
    super.dispose();
  }

  int currentThreadId = 0;

  void loadMessages() async {
    if (widget.thread != null && widget.thread.containsKey("thread_name")) {
      setState(() {
        threadName = widget.thread["thread_name"];
      });
      currentThreadId = widget.thread["id"];
    } else if (widget.customer != null &&
        widget.customer.containsKey("customer_name")) {
      setState(() {
        threadName = widget.customer["customer_name"];
      });
    } else {
      setState(() {
        threadName = lang.text("Failed to load name");
      });
    }
    setState(() {
      loading = true;
    });
    userData = json.decode(await _manager.get("customer", "{}"));
    if (userData == null || !userData.containsKey("id")) {
      return;
    }
    from = int.parse(userData["id"]);
    Map response = await _repository.readMessages({
      "customer_id": int.parse(userData["id"]),
      "thread_id": widget.threadId,
    });
    setState(() {
      loading = false;
    });
    print('response: $response');
    if (response.containsKey("success") && response["success"]) {
      setState(() {
        chat = response["list_msg"];
        threadName = response["thread_name"];
        chat = chat.reversed.toList();
      });
      chat.asMap().forEach((index, msg) {
        if (msg["from"].toString() == widget.toId.toString() &&
            !msg["readed"]) {
          print('msg >>>>>>>: $msg');
          setState(() {
            unreadMsgCount++;
            if (firstUnreadMsg == 0) {
              firstUnreadMsg = index;
//              Timer(Duration(milliseconds: 300),
//                  () => _scrollController.jumpTo(firstUnreadMsg * 1.0));
            }
          });
        }
      });
      Timer(
          Duration(milliseconds: 300),
          () => _scrollController
              .jumpTo(_scrollController.position.maxScrollExtent));
      List readed = [];
      chat.forEach((element) {
        if (element["from"].toString() != userData["id"].toString() &&
            !element["readed"]) {
          readed.add(int.parse(element["id"].toString()));
        }
      });
      await markAsRead(readed);
    }
  }

  Future<void> markAsRead(List ids) async {
    Map readedResponse = await _repository.markAsRead(
        int.parse(userData["id"]), widget.threadId, ids);
    print('readedResponse: $readedResponse, ids: $ids');
  }

  @override
  Widget build(BuildContext context) {
    double pixelRatio = MediaQuery.of(context).devicePixelRatio;
    double px = 1 / pixelRatio;

    styleSomebody = BubbleStyle(
      nip: BubbleNip.leftTop,
      color: Colors.white,
      elevation: 3 * px,
      margin: BubbleEdges.only(top: 8.0, right: 50.0, left: 8.0),
      alignment: Alignment.topLeft,
    );

    styleMe = BubbleStyle(
      nip: BubbleNip.rightTop,
      color: Color.fromARGB(255, 225, 255, 199),
      elevation: 3 * px,
      margin: BubbleEdges.only(top: 8.0, left: 50.0, right: 8.0),
      alignment: Alignment.topRight,
    );
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withOpacity(0.1),
          image: DecorationImage(
              image: AssetImage("assets/images/chat_pg.jpg"),
              fit: BoxFit.fitHeight,
              repeat: ImageRepeat.repeatY,
              colorFilter: ColorFilter.linearToSrgbGamma())),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: true,
        resizeToAvoidBottomPadding: true,
        appBar: null,
        body: SafeArea(
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
                        SizedBox(width: 4.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                              threadName,
                              style: TextStyle(color: Colors.white),
                            ),
                            SizedBox(height: 4.0),
                            Text(
                              lang.text("Teacher"),
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                        Spacer(),
                        /*IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.call,
                            color: Colors.white,
                          ),
                        ),*/
                      ],
                    ),
                  ),
                  Flexible(
                    fit: FlexFit.tight,
                    child: Container(
                      padding: const EdgeInsets.only(bottom: 64.0),
                      /*decoration: BoxDecoration(
                          color:
                              Theme.of(context).primaryColor.withOpacity(0.1),
                          image: DecorationImage(
                              image: AssetImage("assets/images/chat_pg.jpg"),
                              fit: BoxFit.fitHeight,
                              colorFilter: ColorFilter.linearToSrgbGamma())),*/
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          /*Bubble(
                            alignment: Alignment.center,
                            color: Color.fromARGB(255, 212, 234, 244),
                            elevation: 1 * px,
                            margin: BubbleEdges.only(top: 8.0),
                            child:
                                Text('TODAY', style: TextStyle(fontSize: 10)),
                          ),*/
                          Flexible(
                            child: chat.length > 0
                                ? ListView.separated(
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
                                      if (index == firstUnreadMsg &&
                                          chat[index]["from"].toString() ==
                                              userData["id"].toString() &&
                                          unreadMsgCount > 0) {
                                        return Container(
                                          color: Theme.of(context)
                                              .primaryColor
                                              .withOpacity(.1),
                                          child: Bubble(
                                            alignment: Alignment.center,
                                            color: Colors.white,
                                            elevation: 1 * px,
//                                            margin: BubbleEdges.only(top: 8.0),
                                            radius: Radius.circular(30),
                                            child: Text(
                                              lang.text("Unread messages") +
                                                  " $unreadMsgCount",
                                              style: TextStyle(
                                                fontSize: 10,
                                              ),
                                            ),
                                          ),
                                        );
                                      }
                                      return Container();
                                    },
                                  )
                                : Container(),
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
                            keyboardType: TextInputType.multiline,
                            attachFile: SizedBox(),
                            /*IconButton(
                              onPressed: () {
                                log("send attachments");
                              },
                              icon: Icon(
                                Icons.attach_file,
                                size: 30,
                                color: Theme.of(context).hintColor,
                              ),
                            ),*/
                            focusNode: FocusNode(),
                          ),
                        ),
                        SizedBox(width: 4.0),
                        InkWell(
                          child: CircleAvatar(
                            backgroundColor: Theme.of(context).primaryColor,
                            child: Icon(Icons.send, color: Colors.white),
                          ),
                          onTap: () async {
                            await sendMsg();
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
      style: chat["from"].toString() == userData["id"].toString()
          ? styleMe
          : styleSomebody,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Text(
            chat["msg"],
          ),
          SizedBox(height: 4),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              chat["from"].toString() == userData["id"].toString()
                  ? chat["sending"] != null && chat["sending"]
                      ? Container(
                          margin: getMargin(),
                          child: Icon(
                            Icons.access_time,
                            color: Colors.grey,
                            size: 15,
                          ),
                        )
                      : chat["error"] != null && chat["error"]
                          ? Container(
                              margin: getMargin(),
                              child: Icon(
                                Icons.error_outline,
                                color: Colors.red,
                                size: 15,
                              ),
                            )
                          : chat["readed"] != null && chat["readed"]
                              ? Container(
                                  margin: getMargin(),
                                  child: Icon(
                                    Icons.check,
                                    color: Theme.of(context).primaryColor,
                                    size: 15,
                                  ),
                                )
                              : Container(
                                  margin: getMargin(),
                                  child: Icon(
                                    Icons.check,
                                    color: Colors.grey,
                                    size: 15,
                                  ),
                                )
                  : Container(),
              Text(
                DateFormat('hh:mm a', lang.currentLanguage)
                    .format(DateTime.parse(chat["time"])),
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
        ],
      ),
//      time: chat["time"].toString(),
    );
  }

  Future<void> sendMsg() async {
    log('Send: ${controller.text}');
    DateTime now = DateTime.now();
    if (controller.text != null && controller.text.toString().isNotEmpty) {
      setState(() {
        message["sending"] = true;
        sending = true;
      });

      setState(() {
        message = {
          "to": widget.toId,
          "from": from,
          "msg": controller.text,
          "time": "${now.toIso8601String()}",
          "sending": sending
        };
      });
      chat.add(message);
      controller.clear();
      Timer(
          Duration(milliseconds: 300),
          () => _scrollController
              .jumpTo(_scrollController.position.maxScrollExtent));
      print('message is: $message');
      Map response = await _repository.sendMessage(message);
      print('Send response: $response, message state: $message');
      if (response.containsKey("success") && response["success"]) {
        setState(() {
          message["sending"] = false;
          message["error"] = false;
        });
        loadMessages();
      } else {
        setState(() {
          message["sending"] = false;
          message["error"] = true;
        });
      }
      setState(() {});
      AppBuilder.of(context).rebuild();
    }
  }
}
