import 'package:flutter/material.dart';

class CustomDropdownList extends StatelessWidget {
  final String label;
  final List labels;
  final String displayLabel;
  final Function(dynamic data) onChange;
  final String selectedId;
  final String selectedKey;
  final IconData icon;
  final Color backgroundColor;
  final Widget prefix;
  final bool isLoading;

  CustomDropdownList({
    Key key,
    this.icon = Icons.arrow_drop_down,
    @required this.onChange,
    @required this.labels,
    this.label,
    this.selectedId = "0",
    this.selectedKey = "id",
    @required this.displayLabel,
    this.backgroundColor,
    this.prefix,
    this.isLoading = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var dropdownValue = labels[0];
    print('selected id: $selectedId');
    for (int i = 0; i < labels.length; i++) {
      if (labels[i][selectedKey].toString() == selectedId.toString()) {
        dropdownValue = labels[i];
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        label != null
            ? Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 4),
                child: Text(
                  label,
                  textAlign: TextAlign.start,
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
              )
            : Container(),
        Card(
          color: backgroundColor,
          margin: EdgeInsets.all(8.0),
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
          ),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                prefix ?? Container(),
                SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<dynamic>(
                      icon: Icon(icon),
                      value: dropdownValue,
                      isExpanded: true,
                      onChanged: (dynamic newValue) {
                        onChange(newValue);
                      },
                      items: labels
                          .map<DropdownMenuItem<dynamic>>((dynamic value) {
                        return DropdownMenuItem<dynamic>(
                          value: value,
                          child: Row(
                            children: [
                              value["icon"] != null
                                  ? value["icon"]
                                  : Container(),
                              value["icon"] != null
                                  ? SizedBox(
                                      width: 12,
                                    )
                                  : Container(),
                              Expanded(child: Text(value[displayLabel] ?? "")),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
