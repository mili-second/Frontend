import 'package:flutter/material.dart';
import 'package:mili_second/main_view.dart';
import 'package:flutter/foundation.dart';
//import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart'; // secure storage can't web
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SignInView extends StatefulWidget {
  const SignInView({super.key});

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  String user_id = "";
  String user_pw = "";
  int id_ok =
      0; // 아이디 사용 가능 여부 (회원가입 가능 여부) 0 : 중복확인 안함  //  1 : 중복아이디  // 2 : 사용가능 아이디
  int id_valid = 0;
  List<String> id_valid_comments = [
    "아이디는 영문과 숫자 조합으로 5~20자 이내여야 합니다.",
    "사용 가능한 아이디입니다.",
  ];
  List<String> id_comments = ["아이디 중복확인을 해주세요", "중복된 아이디 입니다", "사용가능한 아이디입니다"];
  List<Color> id_comments_color = [Colors.black, Colors.red, Colors.green];
  List<Color> id_valid_comments_color = [Colors.red, Colors.green];
  RegExp regExp_id = RegExp(r'^[a-zA-Z0-9]{5,20}$');

  int pw_ok = 0; // 0 : 사용불가    1 : 사용가능
  List<String> pw_comments = [
    "비밀번호는 8~20자이며, 영문, 숫자, 특수문자를 모두 포함해야 합니다.",
    "사용 가능한 비밀번호입니다.",
  ];
  List<Color> pw_comments_color = [Colors.red, Colors.green];

  // 비밀번호 유효성 검사를 위한 정규식
  RegExp regExp_pw = RegExp(r'^(?=.*[a-zA-Z])(?=.*\d)(?=.*[\W_]).{8,20}$');

  //final storage = FlutterSecureStorage();

  bool is_login = false;

  Future<void> write_token() async {
    //await storage.write(key: "token", value: "ok");

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', 'ok');
    setState(() {
      is_login = true;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Center(child: Text("밀리!!")),
      //   bottom: PreferredSize(
      //     preferredSize: Size.fromHeight(1),
      //     child: Container(height: 1.h, color: Color(0xFFCDCBCB)),
      //   ),
      // ),
      body: Padding(
        padding: EdgeInsets.only(top: kIsWeb ? 40.0 : 40.0.h),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              children: [
                SizedBox(height: kIsWeb ? 10 : 10.h),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "서비스 이용을 위해",
                        style: TextStyle(
                          fontSize: kIsWeb ? 25 : 25.r,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            "회원가입",
                            style: TextStyle(
                              color: Color(0xFF007BFF),
                              fontSize: kIsWeb ? 25 : 25.r,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            "이 필요합니다.",
                            style: TextStyle(
                              fontSize: kIsWeb ? 25 : 25.r,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 40.h),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "아이디",
                    style: TextStyle(
                      color: Color(0xFF007BFF),
                      fontSize: 15.r,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 280.w,
                      height: 50.h,
                      child: TextField(
                        onChanged: (String str) {
                          setState(() {
                            id_ok = 0;
                            user_id = str;
                          });

                          if (str.length < 5 || str.length >= 20) {
                            // 유효하지 않음 (너무 짧거나 길다)
                            setState(() {
                              id_valid = 0;
                            });
                          } else if (regExp_id.hasMatch(str)) {
                            // 조건에 일치
                            setState(() {
                              id_valid = 1;
                            });
                          } else {
                            setState(() {
                              id_valid = 0;
                            });
                          }
                        },
                        decoration: InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFF0088FF),
                              width: 1.5,
                            ),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFFD1D1D1),
                              width: 1.0,
                            ),
                          ),
                          hintText: "아이디를 입력하세요",
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 80.w,
                      child: ElevatedButton(
                        onPressed: id_valid == 0
                            ? null
                            : () => id_duplicate_check(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF007BFF),
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.all(10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0.r),
                          ),
                          textStyle: TextStyle(color: Colors.white),
                        ),
                        child: Text("중복확인"),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 3.h),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    id_valid_comments[id_valid],
                    style: TextStyle(
                      fontSize: 12.r,
                      fontWeight: FontWeight.w500,
                      color: id_valid_comments_color[id_valid],
                    ),
                  ),
                ),
                SizedBox(height: 3),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    id_comments[id_ok],
                    style: TextStyle(
                      fontSize: 12.r,
                      fontWeight: FontWeight.w500,
                      color: id_comments_color[id_ok],
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "비밀번호",
                    style: TextStyle(
                      color: Color(0xFF007BFF),
                      fontSize: 15.r,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                TextField(
                  onChanged: (String str) {
                    if (str.length < 8 || str.length >= 20) {
                      // 유효하지 않음 (너무 짧거나 길다)
                      setState(() {
                        pw_ok = 0;
                      });
                    } else if (regExp_pw.hasMatch(str)) {
                      // 조건에 일치
                      setState(() {
                        user_pw = str;
                        pw_ok = 1;
                      });
                    } else {
                      setState(() {
                        pw_ok = 0;
                      });
                    }
                  },
                  decoration: InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFF0088FF),
                        width: 1.5,
                      ),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFFD1D1D1),
                        width: 1.0,
                      ),
                    ),
                    hintText: "비밀번호를 입력하세요",
                  ),
                ),
                SizedBox(height: 3.h),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    pw_comments[pw_ok],
                    style: TextStyle(
                      fontSize: 12.r,
                      fontWeight: FontWeight.w500,
                      color: pw_comments_color[pw_ok],
                    ),
                  ),
                ),
                SizedBox(height: 30.h),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: id_ok == 2 && pw_ok == 1
                        ? () {
                            write_token();
                            // 최초 회원가입 시 설문조사 페이지로 넘어감
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    // SurveyView(user_id: user_id),
                                    MainView(),
                              ),
                            );
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF007BFF),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.all(15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0.r),
                      ),
                      textStyle: TextStyle(color: Colors.white, fontSize: 20.r),
                    ),
                    child: Text("확인"),
                  ),
                ),
                SizedBox(height: 10.h),
                Row(
                  children: [
                    SizedBox(width: 125.w),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginView()),
                        );
                      },
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          decoration: BoxDecoration(
                            border: BoxBorder.fromLTRB(
                              bottom: BorderSide(width: 0.5.w),
                            ),
                          ),
                          child: Text(
                            "계정이 있으신가요?",
                            style: TextStyle(
                              fontSize: 15.r,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<dynamic> id_duplicate_check(BuildContext context) {
    String alertContent = "";

    if (user_id == "test") {
      setState(() {
        alertContent = "이미 사용중인 닉네임입니다. \n다른 닉네임을 사용하세요";
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

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  //final storage = FlutterSecureStorage();

  bool is_login = false;
  String user_id = "";
  String user_pw = "";

  Future<void> check_login() async {
    print("로그인 확인");
    //String? value = await storage.read(key: "token");

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? value = prefs.getString('token');

    setState(() {
      is_login = (value != null);
      print(value);
    });
  }

  Future<void> write_token() async {
    //await storage.write(key: "token", value: "ok");

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', 'ok');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   automaticallyImplyLeading: false,
      //   title: Center(child: Text("밀리!!")),
      //   bottom: PreferredSize(
      //     preferredSize: Size.fromHeight(1),
      //     child: Container(height: 1.h, color: Color(0xFFCDCBCB)),
      //   ),
      // ),
      body: Padding(
        padding: EdgeInsets.only(top: kIsWeb ? 40.0 : 40.0.h),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              children: [
                SizedBox(height: kIsWeb ? 10 : 10.h),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "서비스 이용을 위해",
                        style: TextStyle(
                          fontSize: kIsWeb ? 25 : 25.r,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            "로그인",
                            style: TextStyle(
                              color: Color(0xFF007BFF),
                              fontSize: kIsWeb ? 25 : 25.r,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            "이 필요합니다.",
                            style: TextStyle(
                              fontSize: kIsWeb ? 25 : 25.r,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: kIsWeb ? 40 : 40.h),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "아이디",
                    style: TextStyle(
                      color: Color(0xFF007BFF),
                      fontSize: kIsWeb ? 15 : 15.r,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(height: kIsWeb ? 10 : 10.h),
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: TextField(
                    onChanged: (String str) {
                      setState(() {
                        user_id = str;
                      });
                    },
                    decoration: InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFF0088FF),
                          width: 1.5,
                        ),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFFD1D1D1),
                          width: 1.0,
                        ),
                      ),
                      hintText: "아이디를 입력하세요",
                    ),
                  ),
                ),

                SizedBox(height: kIsWeb ? 10 : 10.h),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "비밀번호",
                    style: TextStyle(
                      color: Color(0xFF007BFF),
                      fontSize: kIsWeb ? 15 : 15.r,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(height: kIsWeb ? 10 : 10.h),
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: TextField(
                    onChanged: (String str) {
                      setState(() {
                        user_pw = str;
                      });
                    },
                    decoration: InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFF0088FF),
                          width: 1.5,
                        ),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFFD1D1D1),
                          width: 1.0,
                        ),
                      ),
                      hintText: "비밀번호를 입력하세요",
                    ),
                  ),
                ),

                SizedBox(height: kIsWeb ? 30 : 30.h),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: user_id == "" || user_pw == ""
                        ? null
                        : () {
                            write_token();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MainView(),
                              ),
                            );
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF007BFF),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.all(15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: kIsWeb ? 20 : 20.r,
                      ),
                    ),
                    child: Text("로그인"),
                  ),
                ),
                SizedBox(height: kIsWeb ? 10 : 10.h),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignInView()),
                    );
                  },
                  child: Align(
                    alignment: Alignment.center,
                    child: Container(
                      decoration: BoxDecoration(
                        border: BoxBorder.fromLTRB(
                          bottom: BorderSide(width: kIsWeb ? 0.5 : 0.5.w),
                        ),
                      ),
                      child: Text(
                        "회원가입",
                        style: TextStyle(
                          fontSize: kIsWeb ? 15 : 15.r,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
