import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:library_book/credentials/register.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/admin.dart';
import '../models/converter.dart';
import '../models/users.dart';
import '../screens/landing.dart';
import '../screens/widgets/button.dart';
import '../services/routes.dart';
import '../utils/palettes/app_colors.dart' hide Colors;
import '../utils/snackbars/snackbar_message.dart';
import '../widgets/curve.dart';

class Login extends StatefulWidget {
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _email = new TextEditingController();
  final TextEditingController _pass = new TextEditingController();
  final Materialbutton _materialbutton = new Materialbutton();
  final SnackbarMessage _snackbarMessage = new SnackbarMessage();
  final Routes _routes = new Routes();
  bool _showPassword = true;
  String _userValidation = "";
  String _passValidation  = "";
  bool _isLoading = false;
  bool _isLogin = true;

  Future _login({required String user, required String pass})async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('email', user);
    prefs.setString('pass', pass);
    _routes.navigator_pushreplacement(context, Landing());
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _email.dispose();
    _pass.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image(
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.fill,
              image: AssetImage("assets/images/login_back.jpg"),
          ),
          Container(
            width: double.infinity,
            height: double.infinity,
            color: colors.umber.withOpacity(0.8),
            child: Center(
              child: Container(
                width: 1000,
                height: 700,
                color: Colors.white,
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Container(
                        color: colors.umber,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image(
                                width: 150,
                                image: AssetImage("assets/logos/ssu_logo.png"),
                              ),
                              Image(
                                height: 300,
                                width: 300,
                                color: Colors.white,
                                image: AssetImage("assets/logos/transparent_back_logo.png"),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                        flex: 3,
                        child: Stack(
                          children: [
                            CustomPaint(
                                painter: HeaderPainter(),
                                child: Container(
                                  height: 180,
                                )
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 80,vertical: 80),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 80,
                                  ),
                                  if(_isLogin)...{
                                    Text("Welcome Back!",style: TextStyle(fontFamily: "OpenSans",fontSize: 32),),
                                    Text("Glad to see you again.",style: TextStyle(fontFamily: "OpenSans",fontSize: 17),),
                                    SizedBox(
                                      height: 30,
                                    ),
                                    Text("Username",style: TextStyle(fontFamily: "regular",fontSize: 16,color: Colors.black),),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    TextField(
                                      controller: _email,
                                      style: TextStyle(fontFamily: "OpenSans"),
                                      decoration: InputDecoration(
                                        hintText: "Enter username",
                                        hintStyle: TextStyle(fontFamily: "OpenSans", color: Colors.grey),
                                        focusedBorder:OutlineInputBorder(
                                          borderSide: BorderSide(color: colors.umber  , width: 1),
                                          borderRadius: BorderRadius.circular(10.0),
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10.0),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    _userValidation == "" ? Container() : Row(
                                      children: [
                                        Icon(Icons.error_outline,color: Colors.red,),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(_userValidation,style: TextStyle(fontFamily: "OpenSans",color: Colors.red),)
                                      ],
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Text("Password",style: TextStyle(fontFamily: "OpenSans",fontSize: 16,color: Colors.black),),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    TextField(
                                      controller: _pass,
                                      style: TextStyle(fontFamily: "OpenSans"),
                                      decoration: InputDecoration(
                                        hintText: "Enter password",
                                        hintStyle: TextStyle(fontFamily: "OpenSans", color: Colors.grey),
                                        focusedBorder:OutlineInputBorder(
                                          borderSide: BorderSide(color: colors.umber, width: 1),
                                          borderRadius: BorderRadius.circular(10.0),
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10.0),
                                        ),
                                        suffixIcon: IconButton(
                                          icon: !_showPassword ? Icon(Icons.visibility_off,color: Colors.grey.shade700,) : Icon(Icons.visibility,color: Colors.grey.shade700,),
                                          onPressed: (){
                                            setState(() {
                                              _showPassword = !_showPassword;
                                            });
                                          },
                                        ),
                                      ),
                                      obscureText: _showPassword,
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    _passValidation == "" ? Container() : Row(
                                      children: [
                                        Icon(Icons.error_outline,color: Colors.red,),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(_passValidation,style: TextStyle(fontFamily: "OpenSans",color: Colors.red),)
                                      ],
                                    ),
                                    Spacer(),
                                    _isLoading ?
                                    Container(
                                      width: double.infinity,
                                      height: 55,
                                      decoration: BoxDecoration(
                                          color: colors.umber,
                                          borderRadius: BorderRadius.circular(1000)
                                      ),
                                      child: Center(
                                          child: SizedBox(
                                            width: 25,
                                            height: 25,
                                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3,),
                                          )
                                      ),
                                    ) :
                                    _materialbutton.materialButton("Login", ()async{
                                      setState(() {
                                        _userValidation = "";
                                        _passValidation = "";
                                        if(_email.text.isEmpty){
                                          _userValidation = "Username is required.";
                                        }else if(_pass.text.isEmpty){
                                          _passValidation = "Password is required.";
                                        }else{
                                          _isLoading = true;
                                          Future.delayed(const Duration(seconds: 3), () async{
                                            List _user = adminModel.value.where((s) => s["email"] == _email.text && converterModels.hexToString(s["pass"]) == _pass.text).toList();
                                            print("USER RETURN ${converterModels.hexToString(adminModel.value.first["pass"])}");
                                            if(_user.isEmpty){
                                              setState(() {
                                                _isLoading = false;
                                              });
                                              _snackbarMessage.snackbarMessage(context, message: "Invalid credentials!" ,is_error: true);
                                            }else{
                                              usersModel.updateUser(data: _user.first);
                                              _login(user: _email.text, pass: _pass.text);
                                            }
                                          });
                                        }
                                      });
                                    }),
                                  }else...{
                                    AdminRegister(onBack: (){
                                      setState(() {
                                        _isLogin = true;
                                      });
                                    },)
                                  },
                                  Divider(color: Colors.grey.shade100,),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(_isLogin ? "Don't have an account?" : "Already have an account?", style: TextStyle(fontFamily: "OpenSans"),),
                                      TextButton(
                                        child: Text(_isLogin ? "Register" : "Login", style: TextStyle(fontFamily: "OpenSans", color: colors.umber,fontWeight: FontWeight.w600),),
                                        onPressed: (){
                                          setState(() {
                                            _isLogin = !_isLogin;
                                          });
                                        },
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        )
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
