import 'package:flutter/material.dart';

import '../utils/app_theme.dart';
import '../widgets/login_button_widget.dart';
import '../widgets/login_header_widge.dart';
import '../widgets/login_main_image_widget.dart';
import '../widgets/login_subtitle_widget.dart';
import '../widgets/login_text_input_widget.dart';
import '../widgets/login_version_widget.dart';
import 'chat_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  TextEditingController usernameTextController = TextEditingController();

  onTapButton() {
    if (usernameTextController.text.isEmpty) {
      const snackBar = SnackBar(
        duration: Duration(seconds: 2),
        content: Text(
          'Hãy nhập tên để tiếp tục nhé!',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        backgroundColor: Colors.redAccent,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      Navigator.push(
        context,
        MaterialPageRoute<void>(
          builder: (BuildContext context) =>
              ChatPage(usernameTextController.text),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        decoration: AppTheme.loginContainerBoxdecoration,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: SizedBox(
            height: size.height,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                loginHeaderWidget(),
                loginSubtitleWidget(),
                loginMainImageWidget(size),
                loginTextInputWidget(size, usernameTextController),
                loginButtonWidget(size, onTapButton),
                loginCreditWidget()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
