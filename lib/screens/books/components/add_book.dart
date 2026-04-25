import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:library_book/models/image_base64.dart';
import 'package:library_book/screens/books/components/create_qr_code.dart';
import 'package:library_book/screens/notifications/notifications.dart';
import 'package:library_book/screens/widgets/button.dart';
import 'package:library_book/services/apis/books.dart';
import 'package:library_book/services/apis/notifications.dart';
import 'package:library_book/services/routes.dart';
import 'package:path_provider/path_provider.dart';
import '../../../functions/loaders.dart';
import '../../../utils/palettes/app_colors.dart' hide Colors;
import '../../../utils/snackbars/snackbar_message.dart';
import '../../widgets/image_picker.dart';
import 'package:path/path.dart' as path;


class AddBook extends StatefulWidget {
  final Map? details;
  AddBook({this.details});
  @override
  State<AddBook> createState() => _AddBookState();
}

class _AddBookState extends State<AddBook> {
  final ScreenLoaders _screenLoaders = new ScreenLoaders();
  final Routes _routes = new Routes();
  final SnackbarMessage _snackbarMessage = new SnackbarMessage();
  final NotificationApis _notificationApis = new NotificationApis();
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final BooksApi _booksApi = new BooksApi();
  final Materialbutton _materialbutton = new Materialbutton();
  final TextEditingController _subject = TextEditingController();
  final TextEditingController _title = TextEditingController();
  final TextEditingController _author = TextEditingController();
  final TextEditingController _publisher = TextEditingController();
  final TextEditingController _copyright = TextEditingController();
  final TextEditingController _editionNumber = TextEditingController();
  final TextEditingController _pagesNumber = TextEditingController();
  final TextEditingController _isbn = TextEditingController();
  final TextEditingController _stock = TextEditingController();
  final TextEditingController _year = TextEditingController();
  final TextEditingController _shellNumber = TextEditingController();
  final TextEditingController _desc = TextEditingController();
  List<TextEditingController> _categories = [];
  Uint8List? _pickedImageBytes;
  String _base64 = "";
  Uint8List? fileData;

  Future<String?> _convertBase64() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      Uint8List? fileBytes = result.files.first.bytes;
      if (fileBytes != null) {
        setState(() {
          _base64 = base64Encode(fileBytes);
          _pickedImageBytes = result.files.first.bytes;
          print("GET IMAGE BYTE $_pickedImageBytes");
        });
      }
    }
    return null;
  }

  @override
  void initState() {
    // TODO: implement initState
    if(widget.details != null){
      _subject.text = widget.details!["subject"];
      _title.text = widget.details!["title"];
      _author.text = widget.details!["author"];
      _publisher.text = widget.details!["publisher"];
      _copyright.text = widget.details!["copyright"];
      _editionNumber.text = widget.details!["edition_number"];
      _isbn.text = widget.details!["isbn"];
      _pagesNumber.text = widget.details!["pages_number"];
      _stock.text = widget.details!["stock"];
      _shellNumber.text = widget.details!["shell_number"];
      _desc.text = widget.details!["summary"];
      _year.text = widget.details!["year"];
      _base64 = widget.details!["base64Image"];
      _pickedImageBytes = widget.details!["base64Image"] == "" ? null : base64Decode(widget.details!["base64Image"]);
      if(widget.details!["categories"].isNotEmpty){
        for(int x = 0; x < widget.details!["categories"].length; x++){
          _categories.add(TextEditingController()..text="${widget.details!["categories"][x]}");
        }
      }
    }
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _subject.dispose();
    _title .dispose();
    _author.dispose();
    _publisher.dispose();
    _copyright.dispose();
    _editionNumber.dispose();
    _pagesNumber.dispose();
    _isbn.dispose();
    _stock.dispose();
    _shellNumber.dispose();
    _desc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 900,
      height: 900,
      child: Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          ListView(
            children: [
              SizedBox(
                height: 30,
              ),
              Center(
                child: CircleAvatar(
                    minRadius: 50,
                    maxRadius: 70,
                    backgroundColor: Colors.grey.shade100,
                    child: Stack(
                      children: [
                        Center(
                          child: _pickedImageBytes != null ?
                          Image.memory(
                            _pickedImageBytes!,
                            width: 60,
                            height: 110,
                            fit: BoxFit.fill,
                          ) :
                          Image(
                            image: AssetImage("assets/icons/book.png"),
                            width: 55,
                            height: 55,
                            color: Colors.grey.shade500,
                          ),
                        ),
                        Align(
                            alignment: Alignment.bottomRight,
                            child: GestureDetector(
                              onTap: () async{
                                _convertBase64();
                              },
                              child: CircleAvatar(
                                backgroundColor: colors.coffee,
                                child: Icon(Icons.edit,color: colors.umber,),
                              ),
                            )
                        ),
                      ],
                    )
                ),
              ),
              SizedBox(
                height: 50,
              ),
              TextField(
                controller: _title,
                style: TextStyle(fontFamily: "OpenSans"),
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  hintText: 'Title',
                  hintStyle: TextStyle(fontFamily: "OpenSans",color: Colors.grey),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(1000)
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(1000),
                    borderSide: BorderSide(color: colors.umber.withOpacity(0.1)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(1000),
                    borderSide: BorderSide(color: colors.umber.withOpacity(0.4)),
                  ),
                ),
                onChanged: (text) {

                },
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _isbn,
                      style: TextStyle(fontFamily: "OpenSans"),
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'Isbn',
                        hintStyle: TextStyle(fontFamily: "OpenSans",color: Colors.grey),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(1000)
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(1000),
                          borderSide: BorderSide(color: colors.umber.withOpacity(0.1)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(1000),
                          borderSide: BorderSide(color: colors.umber.withOpacity(0.4)),
                        ),
                      ),
                      onChanged: (text) {

                      },
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: TextField(
                      controller: _subject,
                      style: TextStyle(fontFamily: "OpenSans"),
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'Subject',
                        hintStyle: TextStyle(fontFamily: "OpenSans",color: Colors.grey),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(1000)
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(1000),
                          borderSide: BorderSide(color: colors.umber.withOpacity(0.1)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(1000),
                          borderSide: BorderSide(color: colors.umber.withOpacity(0.4)),
                        ),
                      ),
                      onChanged: (text) {

                      },
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  Expanded(
                    child:  TextField(
                      controller: _year,
                      style: TextStyle(fontFamily: "OpenSans"),
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'Published year',
                        hintStyle: TextStyle(fontFamily: "OpenSans",color: Colors.grey),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(1000)
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(1000),
                          borderSide: BorderSide(color: colors.umber.withOpacity(0.1)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(1000),
                          borderSide: BorderSide(color: colors.umber.withOpacity(0.4)),
                        ),
                      ),
                      onChanged: (text) {

                      },
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child:  TextField(
                      controller: _author,
                      style: TextStyle(fontFamily: "OpenSans"),
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        hintText: 'Author',
                        hintStyle: TextStyle(fontFamily: "OpenSans",color: Colors.grey),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(1000)
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(1000),
                          borderSide: BorderSide(color: colors.umber.withOpacity(0.1)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(1000),
                          borderSide: BorderSide(color: colors.umber.withOpacity(0.4)),
                        ),
                      ),
                      onChanged: (text) {

                      },
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _publisher,
                      style: TextStyle(fontFamily: "OpenSans"),
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        hintText: 'Publisher',
                        hintStyle: TextStyle(fontFamily: "OpenSans",color: Colors.grey),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(1000)
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(1000),
                          borderSide: BorderSide(color: colors.umber.withOpacity(0.1)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(1000),
                          borderSide: BorderSide(color: colors.umber.withOpacity(0.4)),
                        ),
                      ),
                      onChanged: (text) {

                      },
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: TextField(
                      controller: _copyright,
                      style: TextStyle(fontFamily: "OpenSans"),
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        hintText: 'Copyright',
                        hintStyle: TextStyle(fontFamily: "OpenSans",color: Colors.grey),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(1000)
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(1000),
                          borderSide: BorderSide(color: colors.umber.withOpacity(0.1)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(1000),
                          borderSide: BorderSide(color: colors.umber.withOpacity(0.4)),
                        ),
                      ),
                      onChanged: (text) {

                      },
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _editionNumber,
                      style: TextStyle(fontFamily: "OpenSans"),
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        hintText: 'Edition number',
                        hintStyle: TextStyle(fontFamily: "OpenSans",color: Colors.grey),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(1000)
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(1000),
                          borderSide: BorderSide(color: colors.umber.withOpacity(0.1)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(1000),
                          borderSide: BorderSide(color: colors.umber.withOpacity(0.4)),
                        ),
                      ),
                      onChanged: (text) {

                      },
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: TextField(
                      controller: _pagesNumber,
                      style: TextStyle(fontFamily: "OpenSans"),
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        hintText: 'Number of pages',
                        hintStyle: TextStyle(fontFamily: "OpenSans",color: Colors.grey),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(1000)
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(1000),
                          borderSide: BorderSide(color: colors.umber.withOpacity(0.1)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(1000),
                          borderSide: BorderSide(color: colors.umber.withOpacity(0.4)),
                        ),
                      ),
                      onChanged: (text) {

                      },
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _stock,
                      style: TextStyle(fontFamily: "OpenSans"),
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        hintText: 'Stock',
                        hintStyle: TextStyle(fontFamily: "OpenSans",color: Colors.grey),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(1000)
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(1000),
                          borderSide: BorderSide(color: colors.umber.withOpacity(0.1)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(1000),
                          borderSide: BorderSide(color: colors.umber.withOpacity(0.4)),
                        ),
                      ),
                      onChanged: (text) {

                      },
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: TextField(
                      controller: _shellNumber,
                      style: TextStyle(fontFamily: "OpenSans"),
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        hintText: 'Shell no.',
                        hintStyle: TextStyle(fontFamily: "OpenSans",color: Colors.grey),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(1000)
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(1000),
                          borderSide: BorderSide(color: colors.umber.withOpacity(0.1)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(1000),
                          borderSide: BorderSide(color: colors.umber.withOpacity(0.4)),
                        ),
                      ),
                      onChanged: (text) {

                      },
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 15,
              ),
              TextField(
                controller: _desc,
                style: TextStyle(fontFamily: "OpenSans"),
                keyboardType: TextInputType.text,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Description',
                  hintStyle: TextStyle(fontFamily: "OpenSans",color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: colors.umber.withOpacity(0.1)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: colors.umber.withOpacity(0.4)),
                  ),
                ),
                onChanged: (text) {

                },
              ),
              SizedBox(
                height: 15,
              ),
              Text("Add Categories: ",style: TextStyle(fontFamily: "OpenSans",fontSize: 15, fontWeight: FontWeight.w600),),
              SizedBox(
                height: 10,
              ),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  for(int x = 0; x < _categories.length; x++)...{
                    SizedBox(
                      width: 350,
                      child: TextField(
                        controller: _categories[x],
                        style: TextStyle(fontFamily: "OpenSans"),
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          hintText: 'Input category',
                          hintStyle: TextStyle(fontFamily: "OpenSans",color: Colors.grey),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(1000),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(1000),
                            borderSide: BorderSide(color: colors.umber.withOpacity(0.1)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(1000),
                            borderSide: BorderSide(color: colors.umber.withOpacity(0.4)),
                          ),
                        ),
                        onChanged: (text) {

                        },
                      ),
                    ),
                  },
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: IconButton(
                      icon: Icon(Icons.add_circle, color: colors.umber, size: 28,),
                      onPressed: (){
                        setState(() {
                          _categories.add(TextEditingController());
                        });
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 50,
              ),
              _materialbutton.materialButton(widget.details != null ? "Update" : "Submit", (){
                List _finalCategories = [];
                for(int x = 0; x < _categories.length; x++){
                  setState(() {
                    _finalCategories.add(_categories[x].text);
                  });
                }
                if(_subject.text.isEmpty || _title.text.isEmpty || _author.text.isEmpty || _publisher.text.isEmpty ||
                    _copyright.text.isEmpty || _editionNumber.text.isEmpty || _pagesNumber.text.isEmpty || _isbn.text.isEmpty ||
                    _stock.text.isEmpty || _shellNumber.text.isEmpty || _desc.text.isEmpty || _categories.isEmpty){
                  _snackbarMessage.snackbarMessage(context, message: "All fields are required.", is_error: true);
                }else{
                  Map _payload = {
                    "subject": _subject.text,
                    "title": _title.text,
                    "author": _author.text,
                    "year": _year.text,
                    "publisher": _publisher.text,
                    "copyright": _copyright.text,
                    "edition_number": _editionNumber.text,
                    "pages_number": _pagesNumber.text,
                    "isbn": _isbn.text,
                    "stock": _stock.text,
                    "overall_stock": _stock.text,
                    "shell_number": _shellNumber.text,
                    "summary": _desc.text,
                    "categories": _finalCategories,
                    "base64Image": _base64,
                  };
                  _screenLoaders.functionLoader(context);
                  if(widget.details != null){
                    _booksApi.edit(old_isbn: widget.details!["isbn"], payload: _payload).whenComplete((){
                      Navigator.of(context).pop(null);
                      _snackbarMessage.snackbarMessage(context, message: "Book details updated successfully!");
                    });
                  }else{
                    print(_payload);
                    _booksApi.add(payload: _payload).whenComplete((){
                      _notificationApis.add(payload: _payload, type: "book_added", content: "New book added on the list, check it out now!");
                      _snackbarMessage.snackbarMessage(context, message: "New book successfully created!");
                      Navigator.of(context).pop(null);
                      showDialog(
                        context: context,
                        builder: (context) => CreateQrCode(isbn: _isbn.text, title: _title.text,),
                      );
                    });
                  }
                }
              }),
              SizedBox(
                height: 20,
              )
            ],
          ),
          Positioned(
            right: -40,
            top: -35,
            child: InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.close, color: colors.umber,),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

