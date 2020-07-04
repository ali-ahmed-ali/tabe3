import 'package:flutter/material.dart';
import 'package:tabee/utils/lang.dart';

class TuitionsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TuitionsState();
  }
}

class _TuitionsState extends State<TuitionsPage> {
  int _totalPrice;
  List<Map<String, dynamic>> all = [
    {'title': lang.text('Tuitions Fees'), 'value': true, 'price': 5000},
    {'title': lang.text('Uniform'), 'value': true, 'price': 500},
    {'title': lang.text('Books'), 'value': true, 'price': 1000},
    {'title': lang.text('School Bus'), 'value': true, 'price': 2000},
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(lang.text('Tuitions pill')),
        leading: IconButton(
            icon: Icon(
              Icons.chevron_left,
              size: 30,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: Container(
        margin: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Text(
                'First Second Third',
                style: TextStyle(fontSize: 17),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Center(
              child: Text(
                lang.text('Sixth Class'),
                style: TextStyle(fontSize: 15),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            _buildChechBoxes(0),
            _buildChechBoxes(1),
            _buildChechBoxes(2),
            _buildChechBoxes(3),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(right: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                            child: Text(
                          lang.text('Total'),
                        )),
                        Text(
                          '\$${_getTotal().toString()}',
                          style: TextStyle(color: Colors.blueGrey,fontSize: 20),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      child: RaisedButton(
                          color: Theme.of(context).primaryColor,
                          child: Text(
                            lang.text('Fee Approve'),
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {}),
                    ),
                    SizedBox(
                      height: 20,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildChechBoxes(int index) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Text(lang.text(all[index]['title'])),
        ),
        SizedBox(
          width: 20,
        ),
        Text(
          all[index]['price'].toString(),
          style: TextStyle(color: Colors.blueGrey,fontSize: 15),
        ),
        SizedBox(
          width: 20,
        ),
        Checkbox(
            value: all[index]['value'],
            onChanged: (value) {
              setState(() {
                _getTotal();
                all[index]['value'] = value;
              });
            }),
      ],
    );
  }

  int _getTotal() {
    _totalPrice = 0;
    for (var i = 0; i < all.length; i++) {
      if (all[i]['value']) {
        _totalPrice += all[i]['price'];
      }
    }
    return _totalPrice;
  }
}
