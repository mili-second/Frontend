import 'package:flutter/material.dart';
import 'package:mili_second/main_view.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final storage = FlutterSecureStorage();

  bool is_login = false;

  Future<void> check_login() async {
    print("로그인 확인");
    String? value = await storage.read(key: "token");

    setState(() {
      is_login = (value != null);
      print(value);
    });
  }

  Future<void> write_token() async {
    await storage.write(key: "token", value: "ok");
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    check_login();
  }

  @override
  Widget build(BuildContext context) {
    return is_login
        ? MainView()
        : Scaffold(
            body: Center(
              child: ElevatedButton(
                onPressed: () {
                  write_token();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MainView()),
                  );
                },
                child: Text("test"),
              ),
            ),
          );
  }
}
