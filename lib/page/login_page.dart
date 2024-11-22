import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:streamly/http/core/hi_error.dart';
import 'package:streamly/http/dao/login_dao.dart';
import 'package:streamly/navigator/hi_navigator.dart';
import 'package:streamly/util/string_util.dart';
import 'package:streamly/widget/appbar.dart';
import 'package:streamly/widget/login_button.dart';
import 'package:streamly/widget/login_input.dart';
import '../util/toast.dart';
import '../widget/login_effect.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool protect = false;
  bool loginEnable = false;
  bool rememberMe = false;
  String? userName;
  String? password;

  @override
  void initState() {
    super.initState();
    _loadSavedUsername();
  }

  /// Load saved username from SharedPreferences
  Future<void> _loadSavedUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('saved_username') ?? '';
      rememberMe = userName!.isNotEmpty;
      if (userName!.isNotEmpty)
        checkInput(); // Enable login if username is loaded
    });
  }

  /// Save username to SharedPreferences
  Future<void> _saveUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (rememberMe) {
      await prefs.setString('saved_username', userName!);
    } else {
      await prefs.remove('saved_username');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar('Login with password', 'Register', () {
        HiNavigator.getInstance().onJumpTo(RouteStatus.login);
      }),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: ListView(
          children: [
            LoginEffect(protect: protect),
            LoginInput(
              'User Name',
              'Please Enter Your User Name',
              onChanged: (text) {
                userName = text;
                checkInput();
              },
              initialValue: userName, // Show saved username if available
            ),
            SizedBox(height: 16), // Add spacing
            LoginInput(
              'Password',
              'Please Enter Your Password',
              obscureText: true,
              onChanged: (text) {
                password = text;
                checkInput();
              },
              focusChanged: (focus) {
                setState(() {
                  protect = focus;
                });
              },
            ),
            Row(
              children: [
                Checkbox(
                  value: rememberMe,
                  onChanged: (value) {
                    setState(() {
                      rememberMe = value!;
                    });
                  },
                ),
                Text('Remember Me'),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: LoginButton(
                'Log In',
                enable: loginEnable,
                onPressed: send,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void checkInput() {
    setState(() {
      loginEnable = isNotEmpty(userName) && isNotEmpty(password);
    });
  }

  void send() async {
    try {
      var result = await LoginDao.login(userName!, password!);
      if (result['code'] == 0) {
        showToast('Login successful');
        await _saveUsername(); // Save the username if "Remember Me" is checked
        HiNavigator.getInstance()
            .onJumpTo(RouteStatus.home); // Use Hinavagator to jump back
      } else {
        showWarnToast(result['msg']);
      }
    } on NeedAuth catch (e) {
      showWarnToast(e.message);
    } on HiNetError catch (e) {
      showWarnToast(e.message);
    }
  }
}
