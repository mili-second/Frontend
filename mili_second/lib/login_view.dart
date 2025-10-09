import 'package:flutter/material.dart';
import 'package:mili_second/main_view.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  String user_id = "";
  int id_ok =
      0; // 아이디 사용 가능 여부 (회원가입 가능 여부) 0 : 중복확인 안함  //  1 : 중복아이디  // 2 : 사용가능 아이디
  List<String> id_comments = ["중복확인을 해주세요", "중복아이디입니다", "사용가능합니다"];
  List<Color> id_comments_color = [Colors.black, Colors.red, Colors.green];

  final storage = FlutterSecureStorage();

  bool is_login = false;

  Future<void> check_login() async {
    print("로그인 확인");
    String? value = await storage.read(key: "token");

    setState(() {
      is_login = (value != null);
    });

    // 화면전환 navigator로 통일
    if (is_login && mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainView()),
      );
    }
  }

  Future<void> write_token() async {
    await storage.write(key: "token", value: "ok");
    setState(() {
      is_login = true;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    check_login();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("밀리!!")),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Container(height: 1.h, color: Color(0xFFCDCBCB)),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            children: [
              SizedBox(height: 10),
              Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "서비스 이용을 위해",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          "회원가입",
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "이 필요합니다.",
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "아이디",
                  style: TextStyle(color: Colors.blue, fontSize: 15),
                ),
              ),
              SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 300,
                    height: 50,
                    child: TextField(
                      onChanged: (String str) {
                        setState(() {
                          id_ok = 0;
                          user_id = str;
                        });
                      },
                      decoration: InputDecoration(labelText: "아이디를 입력하세요"),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: user_id == ""
                        ? null
                        : () => id_duplicate_check(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.all(10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      textStyle: TextStyle(color: Colors.white),
                    ),
                    child: Text("중복확인"),
                  ),
                ],
              ),
              SizedBox(height: 3),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  id_comments[id_ok],
                  style: TextStyle(
                    fontSize: 12,
                    color: id_comments_color[id_ok],
                  ),
                ),
              ),
              SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: id_ok == 2
                      ? () {
                          write_token();
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => MainView()),
                          );
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.all(15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    textStyle: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  child: Text("확인"),
                ),
              ),
              SizedBox(height: 5),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => OnlyLoginView()),
                  );
                },
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    decoration: BoxDecoration(
                      border: BoxBorder.fromLTRB(
                        bottom: BorderSide(width: 0.5),
                      ),
                    ),
                    child: Text("계정이 있으신가요?", style: TextStyle(fontSize: 15)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<dynamic> id_duplicate_check(BuildContext context) {
    String alertContent = "";

    if (user_id == "test") {
      setState(() {
        alertContent = "이미 사용중인 아이디입니다. \n다른 아이디를 사용하세요";
        id_ok = 1;
      });
    } else {
      setState(() {
        alertContent = "사용가능";
        id_ok = 2;
      });
    }

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("중복확인"),
        content: Text(alertContent),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, 'OK'),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

class OnlyLoginView extends StatefulWidget {
  const OnlyLoginView({super.key});

  @override
  State<OnlyLoginView> createState() => _OnlyLoginViewState();
}

class _OnlyLoginViewState extends State<OnlyLoginView> {
  final storage = FlutterSecureStorage();

  bool is_login = false;
  String user_id = "";

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(child: Text("밀리!!")),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Container(height: 1.h, color: Color(0xFFCDCBCB)),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            children: [
              SizedBox(height: 10),
              Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "서비스 이용을 위해",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          "로그인",
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "이 필요합니다.",
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "아이디",
                  style: TextStyle(color: Colors.blue, fontSize: 15),
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: TextField(
                  onChanged: (String str) {
                    setState(() {
                      user_id = str;
                    });
                  },
                  decoration: InputDecoration(labelText: "아이디를 입력하세요"),
                ),
              ),

              SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: user_id == ""
                      ? null
                      : () {
                          write_token();
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => MainView()),
                          );
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.all(15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    textStyle: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  child: Text("로그인"),
                ),
              ),
              SizedBox(height: 5),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    decoration: BoxDecoration(
                      border: BoxBorder.fromLTRB(
                        bottom: BorderSide(width: 0.5),
                      ),
                    ),
                    child: Text("회원가입", style: TextStyle(fontSize: 15)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
