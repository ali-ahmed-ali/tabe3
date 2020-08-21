import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tabee/utils/utils.dart';
import 'package:tabee/widget/circle_image.dart';

class ChatListViewItem extends StatelessWidget {
  final Widget image;
  final String name;
  final String lastMessage;
  final String time;
  final bool hasUnreadMessage;
  final int newMessageCount;
  final bool showTick;

  final VoidCallback onTap;

  const ChatListViewItem(
      {Key key,
      this.image,
      this.name,
      this.lastMessage,
      this.time,
      this.hasUnreadMessage,
      this.newMessageCount,
      this.onTap,
      this.showTick = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                flex: 10,
                child: ListTile(
                  title: Text(
                    name ?? "",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  subtitle: Row(
                    children: <Widget>[
                      showTick
                          ? Container(
                              margin: getMargin(),
                              child: Icon(
                                Icons.done,
                                size: 15,
                                color: Theme.of(context).primaryColor,
                              ))
                          : Container(),
                      Flexible(
                        child: Text(
                          lastMessage,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                  leading: CircleImage(
                    child: image,
                    borderWidth: 0.0,
                  ),
                  trailing: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        time,
                        style: TextStyle(fontSize: 12),
                      ),
                      hasUnreadMessage
                          ? Container(
                              margin: const EdgeInsets.only(top: 5.0),
                              height: 18,
                              width: 18,
                              decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColorDark,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(25.0),
                                  )),
                              child: Center(
                                  child: Text(
                                newMessageCount.toString(),
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.white,
                                ),
                              )),
                            )
                          : SizedBox()
                    ],
                  ),
                  onTap: onTap,
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
