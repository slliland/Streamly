import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hi_net/core/hi_error.dart';
import 'package:streamly/http/dao/login_dao.dart';
import 'package:streamly/navigator/hi_navigator.dart';
import 'package:streamly/util/toast.dart';
import 'package:streamly/widget/login_button.dart';
import 'package:streamly/widget/login_input.dart';
import '../widget/appBar.dart';
import '../widget/login_effect.dart';
import 'package:hi_base/string_util.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Whether to show password protection effect (animated) on the login screen
  bool protect = false;
  // Whether the login button is enabled
  bool loginEnable = false;
  // Whether the "Remember Me" checkbox is checked
  bool rememberMe = false;
  // Store the user name
  String? userName;
  // Store the password
  String? password;

  @override
  void initState() {
    super.initState();
    // Load any previously saved username from SharedPreferences on initialization
    _loadSavedUsername();
  }

  /// Load saved username from SharedPreferences and set the widget states accordingly.
  Future<void> _loadSavedUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      // Retrieve saved username or an empty string if not found
      userName = prefs.getString('saved_username') ?? '';
      // If a non-empty username is found, rememberMe is set to true
      rememberMe = userName!.isNotEmpty;
      // Enable the login button if a userName was found
      if (userName!.isNotEmpty) {
        checkInput();
      }
    });
  }

  /// Save or remove username based on the "Remember Me" checkbox.
  Future<void> _saveUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (rememberMe) {
      // If user wants to remember the username, save it
      await prefs.setString('saved_username', userName!);
    } else {
      // Otherwise, remove it from SharedPreferences
      await prefs.remove('saved_username');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Detect if the current theme is dark mode
    var isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      // Use the custom appBar(...) function here:
      appBar: appBar(
        // Title to show on the left side of the AppBar
        'Login with Password',
        // Text to display on the right side of the AppBar
        'Register',
        // Callback function when the right-side text is pressed
        () {
          // Navigate to the registration page
          HiNavigator.getInstance().onJumpTo(RouteStatus.registration);
        },
        key: Key('registration'),
      ),
      body: Container(
        // Background color changes with dark mode
        color: isDarkMode ? Colors.grey[850] : Colors.white,
        // Padding around the content
        padding: EdgeInsets.symmetric(horizontal: 20),
        // Use ListView to allow scrolling if content is long
        child: ListView(
          children: [
            // An animated effect widget on the login screen
            LoginEffect(
              protect: protect,
            ),
            // A custom TextField for user name
            LoginInput(
              'User Name',
              'Please Enter Your User Name',
              onChanged: (text) {
                userName = text;
                checkInput();
              },
              // If a userName is already loaded, display it by default
              initialValue: userName,
            ),
            SizedBox(height: 16),
            // A custom TextField for password
            LoginInput(
              'Password',
              'Please Enter Your Password',
              obscureText: true, // Hide the password
              onChanged: (text) {
                password = text;
                checkInput();
              },
              focusChanged: (focus) {
                setState(() {
                  // Show/hide the password protection animation depending on focus
                  protect = focus;
                });
              },
            ),
            // A row containing a "Remember Me" checkbox and label
            Row(
              children: [
                Checkbox(
                  value: rememberMe,
                  onChanged: (value) {
                    setState(() {
                      rememberMe = value!;
                    });
                  },
                  // Change color of the checkbox based on dark/light mode
                  activeColor: isDarkMode ? Colors.blueAccent : Colors.blue,
                ),
                Text(
                  'Remember Me',
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
              ],
            ),
            // A custom login button
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: LoginButton(
                'Log In',
                enable: loginEnable, // Whether the button is clickable
                onPressed: send, // The function to call when clicked
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Check whether both userName and password are not empty.
  /// If so, enable the login button.
  void checkInput() {
    setState(() {
      loginEnable = isNotEmpty(userName) && isNotEmpty(password);
    });
  }

  /// Perform the login logic when the login button is pressed.
  /// Handles saving username, showing toast messages, and navigation after successful login.
  void send() async {
    try {
      // Attempt login using the provided credentials
      var result = await LoginDao.login(userName!, password!);
      if (result['code'] == 0) {
        // If login success, show toast, save username if needed, and navigate to the home page
        showToast('Login successful');
        await _saveUsername();
        HiNavigator.getInstance().onJumpTo(RouteStatus.home);
      } else {
        // If the server returns an error code, show the warning toast
        showWarnToast(result['msg']);
      }
    } on NeedAuth catch (e) {
      // Handle authentication errors
      showWarnToast(e.message);
    } on HiNetError catch (e) {
      // Handle any other network errors
      showWarnToast(e.message);
    }
  }
}
