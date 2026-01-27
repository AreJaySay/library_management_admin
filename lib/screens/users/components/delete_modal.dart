import 'package:flutter/material.dart';
import 'package:library_book/services/apis/users.dart';

import '../../../functions/loaders.dart';
import '../../widgets/button.dart';

class DeleteModal extends StatefulWidget {
  final Map details;
  DeleteModal({required this.details});
  @override
  State<DeleteModal> createState() => _DeleteModalState();
}

class _DeleteModalState extends State<DeleteModal> {
  final UsersApi _studentApis = new UsersApi();
  final ScreenLoaders _screenLoaders = new ScreenLoaders();
  final Materialbutton _materialbutton = new Materialbutton();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 500,
      height: 150,
      child: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Text("Delete student?", style: TextStyle(fontFamily: "OpenSans", fontWeight: FontWeight.w600,fontSize: 16),),
          SizedBox(
            height: 5,
          ),
          Text("Are you sure you want to delete this student?", style: TextStyle(fontFamily: "OpenSans"),),
          Spacer(),
          Row(
            children: [
              Expanded(
                child: _materialbutton.materialButton("Cancel", (){
                  Navigator.of(context).pop(null);
                }),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: _materialbutton.materialButton("Delete", (){
                  _screenLoaders.functionLoader(context);
                  _studentApis.delete(id: widget.details["id"]).whenComplete((){
                    Navigator.of(context).pop(null);
                    Navigator.of(context).pop(null);
                  });
                }, textColor: Colors.red),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
