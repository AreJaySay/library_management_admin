import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:library_book/models/notifications.dart';
import 'package:library_book/services/apis/notifications.dart';
import 'package:library_book/utils/palettes/app_colors.dart' hide Colors;

import '../widgets/appbar.dart';

class Notifications extends StatefulWidget {
  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  final NotificationApis _notificationApis = new NotificationApis();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: notificationModel.subject,
      builder: (context, snapshot) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
              elevation: 1,
              shadowColor: Colors.grey.shade200,
              centerTitle: false,
              backgroundColor: Colors.white,
              flexibleSpace: Appbar(isReservation: true,isBook: true,title: "NOTIFICATIONS",onchange: (text){
                setState(() {

                });
              }, onPrint: (){}, onAdd: (){},)
          ),
          body: !snapshot.hasData ?
          Center(
            child: CircularProgressIndicator(color: colors.umber,),
          ) :
          snapshot.data!.isEmpty ?
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image(
                  width: 200,
                  height: 200,
                  image: AssetImage("assets/icons/no_data_found.jpg"),
                ),
                Text("No Data Found !",style: TextStyle(fontFamily: "OpenSans",fontSize: 20,color: Colors.grey.shade400),)
              ],
            ),
          ) : ListView(
            children: [
              for(int x = 0; x < snapshot.data!.length; x++)...{
                snapshot.data![x]["type"] == "book_reservation" ? _bookReservation(details: snapshot.data![x]) : SizedBox(),
              }
            ],
          ),
        );
      }
    );
  }
  Widget _addUserWidget(){
    return Row(
      children: [
        CircleAvatar(
          child: Icon(Icons.person_add, color: Colors.green,),
          backgroundColor: Colors.grey.shade200,
        ),
        SizedBox(
          width: 30,
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: Text("New student added",style: TextStyle(fontFamily: "OpenSans", fontSize: 12, color: Colors.white),),
                decoration: BoxDecoration(
                    color: Colors.lightGreen,
                    borderRadius: BorderRadius.circular(5)
                ),
                padding: EdgeInsets.symmetric(horizontal: 5,vertical: 3),
              ),
              SizedBox(
                height: 5,
              ),
              Text("New student registered using mobile application!",style: TextStyle(fontFamily: "OpenSans"),),
              SizedBox(
                height: 5,
              ),
              Text("Tap to view",style: TextStyle(fontFamily: "OpenSans", color: Colors.grey,fontSize: 12),),
            ],
          ),
        ),
        RichText(
          textAlign: TextAlign.end,
          text: TextSpan(
            children: [
              WidgetSpan(child: Icon(Icons.access_time_outlined, size: 18, color: Colors.grey,)),
              WidgetSpan(child: SizedBox(width: 5,)),
              TextSpan(text: DateFormat("dd MMM yyyy").format(DateTime.now()), style: TextStyle(fontFamily: "OpenSans", color: Colors.grey.shade700),),
              TextSpan(text: "\n${DateFormat("h:mm a").format(DateTime.now())}", style: TextStyle(fontFamily: "OpenSans", color: Colors.grey, fontSize: 13),)
            ],
          ),
        ),
        SizedBox(
          width: 10,
        )
      ],
    );
  }

  Widget _logBooksWidget(){
    return Row(
      children: [
        CircleAvatar(
          child: Icon(Icons.sensors, color: colors.umber,),
          backgroundColor: Colors.grey.shade200,
        ),
        SizedBox(
          width: 30,
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: Text("Student Logbooks",style: TextStyle(fontFamily: "OpenSans", fontSize: 12, color: Colors.white),),
                decoration: BoxDecoration(
                    color: colors.umber,
                    borderRadius: BorderRadius.circular(5)
                ),
                padding: EdgeInsets.symmetric(horizontal: 5,vertical: 3),
              ),
              SizedBox(
                height: 5,
              ),
              Text("Student Marian Bautista 2nd year student ... scanned his/her card to login!",style: TextStyle(fontFamily: "OpenSans"),),
              SizedBox(
                height: 5,
              ),
              Text("Tap to view",style: TextStyle(fontFamily: "OpenSans", color: Colors.grey,fontSize: 12),),
            ],
          ),
        ),
        RichText(
          textAlign: TextAlign.end,
          text: TextSpan(
            children: [
              WidgetSpan(child: Icon(Icons.access_time_outlined, size: 18, color: Colors.grey,)),
              WidgetSpan(child: SizedBox(width: 5,)),
              TextSpan(text: DateFormat("dd MMM yyyy").format(DateTime.now()), style: TextStyle(fontFamily: "OpenSans", color: Colors.grey.shade700),),
              TextSpan(text: "\n${DateFormat("h:mm a").format(DateTime.now())}", style: TextStyle(fontFamily: "OpenSans", color: Colors.grey, fontSize: 13),)
            ],
          ),
        ),
        SizedBox(
          width: 10,
        )
      ],
    );
  }

  Widget _returnBook(){
    return Row(
      children: [
        CircleAvatar(
          child: Icon(Icons.book, color: colors.clay,),
          backgroundColor: Colors.grey.shade200,
        ),
        SizedBox(
          width: 30,
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: Text("Book Returned",style: TextStyle(fontFamily: "OpenSans", fontSize: 12, color: Colors.white),),
                decoration: BoxDecoration(
                    color: colors.clay,
                    borderRadius: BorderRadius.circular(5)
                ),
                padding: EdgeInsets.symmetric(horizontal: 5,vertical: 3),
              ),
              SizedBox(
                height: 5,
              ),
              Text("Student Maria Bautista returned Title of book borrowed by August 22, 2025 due date on August 30, 2025!",style: TextStyle(fontFamily: "OpenSans"),),
              SizedBox(
                height: 5,
              ),
              Text("Tap to view",style: TextStyle(fontFamily: "OpenSans", color: Colors.grey,fontSize: 12),),
            ],
          ),
        ),
        RichText(
          textAlign: TextAlign.end,
          text: TextSpan(
            children: [
              WidgetSpan(child: Icon(Icons.access_time_outlined, size: 18, color: Colors.grey,)),
              WidgetSpan(child: SizedBox(width: 5,)),
              TextSpan(text: DateFormat("dd MMM yyyy").format(DateTime.now()), style: TextStyle(fontFamily: "OpenSans", color: Colors.grey.shade700),),
              TextSpan(text: "\n${DateFormat("h:mm a").format(DateTime.now())}", style: TextStyle(fontFamily: "OpenSans", color: Colors.grey, fontSize: 13),)
            ],
          ),
        ),
        SizedBox(
          width: 10,
        )
      ],
    );
  }

  Widget _bookReservation({required Map details}){
    return InkWell(
      onTap: (){
        _notificationApis.seen(id: details["id"]).whenComplete((){
          _notificationApis.get();
        });
      },
      child: Container(
        margin: EdgeInsets.only(top: 5),
        decoration: BoxDecoration(
          color: details["is_read"] == "1" ? Colors.white : colors.umber.withOpacity(0.2),
          border: Border(
            bottom: BorderSide(color: Colors.grey.shade200)
          )
        ),
        padding: EdgeInsets.symmetric(horizontal: 20,vertical: 15),
        child: Row(
          children: [
            CircleAvatar(
              child: Icon(Icons.calendar_month, color: colors.umber,),
              backgroundColor: Colors.grey.shade200,
            ),
            SizedBox(
              width: 30,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Text("Book Reservation",style: TextStyle(fontFamily: "OpenSans", fontSize: 12, color: Colors.white),),
                    decoration: BoxDecoration(
                        color: colors.umber,
                        borderRadius: BorderRadius.circular(5)
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 5,vertical: 3),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text("${details["content"]}",style: TextStyle(fontFamily: "OpenSans"),),
                  SizedBox(
                    height: 5,
                  ),
                  Text("Tap to read",style: TextStyle(fontFamily: "OpenSans", color: Colors.grey,fontSize: 12),),
                ],
              ),
            ),
            RichText(
              textAlign: TextAlign.end,
              text: TextSpan(
                children: [
                  WidgetSpan(child: Icon(Icons.access_time_outlined, size: 18, color: Colors.grey,)),
                  WidgetSpan(child: SizedBox(width: 5,)),
                  TextSpan(text: DateFormat("dd MMM yyyy").format(DateTime.parse(details["created_at"])), style: TextStyle(fontFamily: "OpenSans", color: Colors.grey.shade700),),
                  TextSpan(text: "\n${DateFormat("h:mm a").format(DateTime.parse(details["created_at"]))}", style: TextStyle(fontFamily: "OpenSans", color: Colors.grey, fontSize: 13),)
                ],
              ),
            ),
            SizedBox(
              width: 10,
            )
          ],
        ),
      ),
    );
  }
}
