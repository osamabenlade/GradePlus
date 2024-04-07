import 'package:flutter/material.dart';

class CustomDropdown extends StatefulWidget {
  final dynamic selectedValue;
  final List<dynamic> items;
  final int type;

  CustomDropdown({required this.selectedValue, required this.items, required this.type});

  @override
  _CustomDropdownState createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  dynamic dropdownValue;

  @override
  void initState() {
    super.initState();
    dropdownValue = widget.selectedValue;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<dynamic>(
      value: dropdownValue,
      icon: Icon(Icons.arrow_drop_down),
      iconSize: 24,
      elevation: 16,
      style: TextStyle(color: Colors.deepPurple),
      onChanged: (dynamic newValue) {
        setState(() {
          dropdownValue = newValue;
        });
      },
      items: widget.items.map<DropdownMenuItem<dynamic>>((dynamic item) {
        return DropdownMenuItem<dynamic>(
          value: item,
          child: Text(item.toString()),
        );
      }).toList(),
    );
  }
}
