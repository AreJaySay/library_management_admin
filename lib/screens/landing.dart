import 'package:flutter/material.dart';
import 'package:flutter_side_menu/flutter_side_menu.dart';
import 'package:intl/intl.dart';
import 'package:library_book/models/notifications.dart';
import 'package:library_book/models/page_navigators.dart';
import 'package:library_book/screens/books/books.dart';
import 'package:library_book/screens/logbooks/logbooks.dart';
import 'package:library_book/screens/notifications/notifications.dart';
import 'package:library_book/screens/users/users.dart';
import 'package:library_book/services/apis/notifications.dart';
import 'package:library_book/utils/palettes/app_colors.dart' hide Colors;

import '../utils/snackbars/notification_modal.dart';

class Landing extends StatefulWidget {
  @override
  State<Landing> createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  final SideMenuController _sideMenuController = SideMenuController();
  final NotificationApis _notificationApis = new NotificationApis();
  List<String> _title = ["Students","Logbooks","Books"];
  List<String> _icons = ["users","logbooks","books"];
  List<Widget> _pages = [Users(),LogBooks(),Books()];
  int _selected = 0;
  bool _isCollapsed = false;

  @override
  void initState() {
    // TODO: implement initState
    pageNavigatorsModel.update(data: false);
    _notificationApis.get();
    _notificationChecker();
    super.initState();
  }

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
                child: CircleAvatar(
                  maxRadius: 60,
                  minRadius: 40,
                  backgroundImage: AssetImage("assets/logos/ssu_logo.png"),
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
                      pageNavigatorsModel.update(data: false);
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
          StreamBuilder(
            stream: pageNavigatorsModel.subject,
            builder: (context, snapshot) {
              return Expanded(
                child: snapshot.data! ?
                Notifications() :
                _pages[_selected],
              );
            }
          )
        ],
      ),
    );
  }
  void _notificationChecker(){
    Future.delayed(const Duration(seconds: 10), () {
      _notificationApis.get().whenComplete((){
        List _res = notificationModel.value.where((s) => s["is_showed"] == "0").toList();
        if(_res.isNotEmpty){
          print("NOTIFICATIONS SHOW NOW ${_res.first}");
          notificationModal.showNotificModal(context, "${_res.first["content"]}");
          _notificationApis.showed(id: _res.first["id"]);
        }
        _notificationChecker();
      });
    });
  }
}
