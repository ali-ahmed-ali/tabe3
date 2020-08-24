import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tabee/widget/wavy_header.dart';

class CustomTable extends StatefulWidget {
  final List<Widget> columnData;
  final List<Widget> firstColumnData;
  final List data;
  final title;
  final TextStyle titleStyle;

  final double divider;

  final double columnSpacing;

  const CustomTable(
      {Key key,
      @required this.columnData,
      @required this.firstColumnData,
      @required this.data,
      @required this.title,
      this.titleStyle,
      this.divider = 2,
      this.columnSpacing = 8.0})
      : super(key: key);

  @override
  _CustomTableState createState() => _CustomTableState();
}

class _CustomTableState extends State<CustomTable> {
  List<DataColumn> dataColumn = [];
  List<DataRow> dataRow = [];
  List<DataCell> firstColumn = [];
  List<List<DataCell>> allCells = [];

  @override
  void initState() {
    init();
    super.initState();
  }

  void init() {
    dataColumn =
        widget.columnData.map((wid) => DataColumn(label: wid)).toList();

    firstColumn = widget.firstColumnData.map((e) => DataCell(e)).toList();
    int cols = widget.columnData.length;
    int rows = widget.firstColumnData.length;
    for (int r = 0; r < rows; r++) {
      List<DataCell> cells = [];
      cells.add(firstColumn[r]);
      // TODO:  Put first  col to @firstColumnData;
      (widget.data[r] as List).forEach((element) {
        print('Element $element');
        cells.add(DataCell(element));
        print('Cells: $cells');
      });
      dataRow.add(new DataRow(cells: cells));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: .5, color: Theme.of(context).primaryColor),
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        children: <Widget>[
          WavyHeader(
            child: widget.title is String
                ? Text(
                    widget.title,
                    style: widget.titleStyle ??
                        TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 18.0,
                        ),
                  )
                : widget.title,
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                //dividerThickness: widget.divider,
                columnSpacing: widget.columnSpacing,
                columns: dataColumn,
                rows: dataRow,
              ),
            ),
          )
        ],
      ),
    );
  }
}
