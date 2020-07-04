import 'package:flutter/material.dart';
import 'package:tabee/utils/lang.dart';

class NewsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> news = [
      {
        'title': "First New",
        'date': '7/3/2020',
        'body': 'jnkjfs fjhfbh hjbjh fhjd j vv'
      },
      {
        'title': "Second New",
        'date': '7/3/2020',
        'body': 'jnkjfs fjhfbh hjbjh fhjd j vv'
      },
      {
        'title': "Third New",
        'date': '7/3/2020',
        'body': 'jnkjfs fjhfbh hjbjh fhjd j vv'
      }
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text(lang.text('News')),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.chevron_left,
            size: 30,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.favorite_border),
            onPressed: () {},
          )
        ],
      ),
      body: Container(
        margin: EdgeInsets.all(20),
        child: ListView.builder(
            itemCount: news.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                child: Column(
                  children: <Widget>[
                    /*Row(
                      children: <Widget>[
                        Icon(Icons.public),
                        SizedBox(
                          width: 10,
                        ),
                        Text(news[index]['title']),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Text(
                            news[index]['date'],
                            textAlign: TextAlign.end,
                          ),
                        )
                      ],
                    ),*/
                    ListTile(
                      leading: Icon(Icons.public),
                      title: Text(news[index]['title'],),
                      trailing: Text(news[index]['date'],),
                      subtitle: Text(news[index]['body'],),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    /*Text(news[index]['body']),
                    SizedBox(
                      height: 20,
                    ),*/
                    Divider(),
                  ],
                ),
              );
            }),
      ),
    );
  }
}
