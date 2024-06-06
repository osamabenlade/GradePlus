



import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../constants/constants.dart';
import '../screens/login_detail_screen.dart';

List<Color> _colors = [kPrimaryColor, kPrimaryLightColor];
List<double> _stops = [1.8, 0.0];

class CustomDropdown extends StatefulWidget {
  String text;
  int type; // 1 for semester, 2 for batch , 3 for branch
  List<dynamic> list;

  CustomDropdown(
      {  required this.text, required this.list, required this.type});
  @override
  _CustomDropdownState createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  late MediaQueryData _mediaQueryData;
  late double screenHeight;
  late GlobalKey actionKey;
  bool isDropDownOpen = false;
  late OverlayEntry floatingDropdown;
  late double height, width, xPosition, yPosition;
  String t = "";

  void findDropDownData() {
    RenderBox? renderBox = actionKey.currentContext?.findRenderObject() as RenderBox?;
    height = renderBox!.size.height;
    width = renderBox!.size.width;
    Offset offset = renderBox.localToGlobal(Offset.zero);
    xPosition = offset.dx;
    yPosition = offset.dy;
    //print(height);
    //print(width);
    //print(xPosition);
    //print(yPosition);
  }

  OverlayEntry _createFloatingDropdown() {
    _mediaQueryData = MediaQuery.of(context);
    screenHeight = _mediaQueryData.size.height;
    //print(screenHeight);
    //print(yPosition + 4 * height + 40);
    return OverlayEntry(builder: (context) {
      return Positioned(
        left: xPosition,
        width: width,
        top: yPosition + height,
        height: (yPosition + 4 * height + 40 < screenHeight)
            ? 4 * height + 40
            : screenHeight - yPosition - 70.0,
        child: Card(
          elevation: 8.0,
          shape: RoundedRectangleBorder(
            borderRadius: const BorderRadius.all(
              Radius.circular(8.0),
            ),
          ),
          margin: EdgeInsets.only(left: 24.0, right: 24.0, top: 8.0),
          child: Scrollbar(
            child: ListView.separated(
              padding: EdgeInsets.all(0.0),
              separatorBuilder: (BuildContext context, int index) => Padding(
                  padding: EdgeInsets.only(
                      left: 15.0, right: 15.0, top: 0.0, bottom: 0.0),
                  child: Divider(
                      thickness: 2, height: 5, color: kPrimaryLightColor)),
              itemBuilder: (context, index) {
                bool isSelected = false;
                final item = widget.list[index];
                if (t == item.toString()) isSelected = true;
                //print(item.toString());
                return Material(
                  color: isSelected ? kPrimaryLightColor : Colors.white,
                  child: ListTile(
                      title: Text(
                        item.toString(),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onTap: () {
                        int temp = widget.type;
                        //print(temp);
                        if (temp == 1) {
                          semester = item;
                          t = item.toString();
                          setState(() {
                            widget.text = item.toString();
                            floatingDropdown.remove();
                            isDropDownOpen = !isDropDownOpen;
                          });
                          //print(semester);
                        } else if (temp == 2) {
                          batch = item;
                          t = item.toString();
                          setState(() {
                            widget.text = item.toString();
                            floatingDropdown.remove();
                            isDropDownOpen = !isDropDownOpen;
                          });
                          //print(batch);
                        } else if (temp == 3) {
                          branch = item;
                          t = item.toString();
                          setState(() {
                            widget.text = item.toString();
                            floatingDropdown.remove();
                            isDropDownOpen = !isDropDownOpen;
                          });
                          //print(branch);
                        }
                      }),
                );
              },
              itemCount: widget.list.length,
            ),
          ),
        ),
      );
    });
  }

  @override
  void initState() {
    actionKey = LabeledGlobalKey(widget.text);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: GestureDetector(
        key: actionKey,
        onTap: () {
          setState(() {
            findDropDownData();
            if (isDropDownOpen) {
              floatingDropdown.remove();
            } else {
              floatingDropdown = _createFloatingDropdown();
              Overlay.of(context).insert(floatingDropdown);
            }
          });
          isDropDownOpen = !isDropDownOpen;
        },
        child: Container(
          height: 50.0,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              gradient: LinearGradient(colors: [
                kPrimaryLightColor,
                Colors.amber.shade900
              ])),
          padding: EdgeInsets.symmetric(horizontal: 25, vertical: 8),
          child: Row(
            children: [
              Text(
                widget.text,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold),
              ),
              Spacer(),
              Icon(
                Icons.expand_more,
                color: Colors.white,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class DropDown extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
