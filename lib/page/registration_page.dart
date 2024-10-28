import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../http/core/hi_error.dart';
import '../http/dao/login_dao.dart';
import '../util/toast.dart';
import '../widget/appBar.dart';
import '../widget/login_input.dart';
import '../util/string_util.dart';
import '../widget/login_button.dart';

class RegistrationPage extends StatefulWidget {
  final VoidCallback? onJumpToLogin;

  const RegistrationPage({super.key, this.onJumpToLogin});

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  bool project = false;
  bool loginEnable = false;
  String? userName;
  String? password;
  String? rePassword;
  String? imoocId;
  String? orderId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar("Register", "Log In", widget.onJumpToLogin),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: ListView(
          children: [
            SizedBox(height: 20),
            LoginInput(
              "User Name",
              "Please input your user name",
              onChanged: (text) {
                userName = text;
                checkInput();
              },
            ),
            SizedBox(height: 20),
            LoginInput(
              "Password",
              "Please input your password",
              obscureText: true,
              onChanged: (text) {
                password = text;
                checkInput();
              },
            ),
            SizedBox(height: 20),
            LoginInput(
              "Confirm Password",
              "Please confirm your password again",
              obscureText: true,
              onChanged: (text) {
                rePassword = text;
                checkInput();
              },
              focusChanged: (focus) {
                setState(() {
                  project = focus;
                });
              },
            ),
            SizedBox(height: 20),
            LoginInput(
              "Secure ID",
              "Please input your Secure ID",
              keyboardType: TextInputType.number,
              obscureText: true,
              onChanged: (text) {
                imoocId = text;
                checkInput();
              },
            ),
            SizedBox(height: 20),
            LoginInput(
              "Order ID",
              "Please input your Order ID",
              keyboardType: TextInputType.number,
              obscureText: true,
              onChanged: (text) {
                orderId = text;
                checkInput();
              },
            ),
            Padding(
              padding: EdgeInsets.only(top: 20, left: 20, right: 20),
              child: LoginButton('Register',
                  enable: loginEnable, onPressed: checkParams),
            ),
          ],
        ),
      ),
    );
  }

  void checkInput() {
    setState(() {
      loginEnable = isNotEmpty(userName) &&
          isNotEmpty(password) &&
          isNotEmpty(rePassword) &&
          isNotEmpty(imoocId) &&
          isNotEmpty(orderId);
    });
  }

  Widget _loginButton() {
    return LoginButton(
      "Register", // Positional argument for title
      enable: loginEnable,
      onPressed: () {
        if (loginEnable) {
          checkParams();
        } else {
          print("loginEnable is false");
        }
      },
    );
  }

  void send() async {
    try {
      var result =
          await LoginDao.registration(userName!, password!, imoocId!, orderId!);
      print(result);
      if (result['code'] == 0) {
        print('Successful Registered');
        showToast('Successful Registered');
        if (widget.onJumpToLogin != null) {
          widget.onJumpToLogin!();
        }
      } else {
        print(result['msg']);
        showWarnToast(result['msg']);
      }
    } on NeedAuth catch (e) {
      print(e);
      showWarnToast(e.message);
    } on HiNetError catch (e) {
      print(e);
      showWarnToast(e.message);
    }
  }

  void checkParams() {
    String? tips;
    if (password != rePassword) {
      tips = 'The passwords do not match';
    } else if (orderId?.length != 4) {
      tips = "Please enter the last four digits of the order ID";
    }
    if (tips != null) {
      showError(tips);
      return;
    }
    send();
  }

  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
