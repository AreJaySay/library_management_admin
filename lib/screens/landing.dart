import 'package:flutter/material.dart';
import 'package:flutter_side_menu/flutter_side_menu.dart';
import 'package:intl/intl.dart';
import 'package:library_book/screens/books/books.dart';
import 'package:library_book/screens/logbooks/logbooks.dart';
import 'package:library_book/screens/users/users.dart';
import 'package:library_book/utils/palettes/app_colors.dart' hide Colors;

class Landing extends StatefulWidget {
  @override
  State<Landing> createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  final SideMenuController _sideMenuController = SideMenuController();
  List<String> _title = ["Students","Logbooks","Books"];
  List<String> _icons = ["users","logbooks","books"];
  List<Widget> _pages = [Users(),LogBooks(),Books()];
  int _selected = 0;
  bool _isCollapsed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        children: [
          SideMenu(
            maxWidth: 300,
            minWidth: 110,
            hasResizer: false,
            backgroundColor: Colors.white,
            controller: _sideMenuController,
            builder: (data) => SideMenuData(
              header: Padding(
                padding: EdgeInsets.only(left: 20, right: 20, top: 20,bottom: 30),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: AssetImage("assets/logos/main_logo.png"),
                    ),
                    if(!_isCollapsed)...{
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            text: "SSU",
                            style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15,fontFamily: "OpenSans"),
                            children: <TextSpan>[
                              TextSpan(text: ' Library Management \nwith', style: TextStyle(fontSize: 15,fontFamily: "OpenSans",fontWeight: FontWeight.w400)),
                              TextSpan(text: ' RFID', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15,fontFamily: "OpenSans")),
                            ],
                          ),
                        ),
                      ),
                    }
                  ],
                ),
              ),
              items: [
                for(int x = 0; x < _title.length; x++)...{
                  SideMenuItemDataTile(
                    isSelected: _selected == x,
                    onTap: () {
                      setState(() {
                        _selected = x;
                      });
                    },
                    title: _title[x],
                    icon: Center(
                      child: Image(
                        width: 30,
                        height: 30,
                        color: _selected == x ? Colors.white : colors.umber,
                        image: AssetImage("assets/icons/${_icons[x]}.png"),
                      ),
                    ),
                    titleStyle: TextStyle(fontFamily: "OpenSans",fontSize: 15,fontWeight: FontWeight.w500),
                    selectedTitleStyle: TextStyle(color: Colors.white),
                    itemHeight: 55,
                    borderRadius: BorderRadiusGeometry.circular(10),
                    hasSelectedLine: false,
                    highlightSelectedColor: colors.umber,
                    margin: EdgeInsetsDirectional.symmetric(horizontal: 20,vertical: 3)
                  ),
                }
              ],
              footer: Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                child: FloatingActionButton(
                  backgroundColor: colors.coffee,
                  shape: const CircleBorder(),
                  child: _isCollapsed ? Icon(Icons.keyboard_arrow_right,color: colors.umber,size: 30,) : Icon(Icons.keyboard_arrow_left,color: colors.umber,size: 30,),
                  onPressed: (){
                    setState(() {
                      _sideMenuController!.toggle();
                      _isCollapsed = !_isCollapsed;
                    });
                  },
                ),
              )
            ),
            hasResizerToggle: false,
          ),
          VerticalDivider(),
          Expanded(
            child: _pages[_selected],
          )
        ],
      ),
    );
  }
}
