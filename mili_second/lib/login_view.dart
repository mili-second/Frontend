import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:mili_second/main_view.dart';
import 'package:flutter/foundation.dart';
import 'package:mili_second/model/user_model.dart';
import 'package:provider/provider.dart';
//import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart'; // secure storage can't web
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SignInView extends StatefulWidget {
  const SignInView({super.key});

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  String inputId = "";
  String inputPw = "";
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future<void> _handleCheckId() async {
    // ✨ 1. (안전) await 전에 context/변수 준비
    final userModel = context.read<UserModel>();
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final currentId = inputId; // (중요) inputId는 계속 바뀔 수 있으므로 현재 값을 복사

    // ✨ 2. Model의 함수 호출
    final bool isAvailable = await userModel.checkIdDuplication(currentId);

    // ✨ 3. (안전) mounted 확인
    if (!context.mounted) return;

    // ✨ 4. 결과에 따라 UI 처리
    if (isAvailable) {
      // 성공: "id_ok" 상태를 2로 변경
      setState(() {
        id_ok = 2; // 사용 가능
      });
      // (선택적) SnackBar로 알려주기
      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text("사용 가능한 아이디입니다."),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      // 실패: "id_ok" 상태를 1로 변경
      setState(() {
        id_ok = 1; // 중복됨
      });
      // (선택적) 에러 메시지 표시
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text(userModel.error ?? "알 수 없는 오류"), // Model의 에러 메시지
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _handleSignUp() async {
    // ✨ 1. (안전) await 전에 context/변수 준비
    final userModel = context.read<UserModel>();
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    // ✨ 2. Model의 signUp 함수 호출
    await userModel.signUp(inputId, inputPw);

    // ✨ 3. (안전) mounted 확인
    if (!context.mounted) return;

    // ✨ 4. 결과 처리
    if (userModel.error != null) {
      // 실패 시 에러 표시
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text(userModel.error!), backgroundColor: Colors.red),
      );
    }
    // ✨ 5. 성공 시?
    // 아무것도 안 해도 됩니다!
    // AuthWrapper가 userModel.isLoggedIn == true가 된 것을 감지하고
    // 알아서 MainView로 전환시켜 줍니다.
  }

  @override
  Widget build(BuildContext context) {
    // Model의 로딩 상태를 구독(watch)
    final bool isLoading = context.watch<UserModel>().isLoading;
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
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: kIsWeb ? 280 : 280.w,
                      height: kIsWeb ? 50 : 50.h,
                      child: TextField(
                        onChanged: (String str) {
                          setState(() {
                            id_ok = 0;
                            inputId = str;
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
                              width: kIsWeb ? 1.5 : 1.5.w,
                            ),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFFD1D1D1),
                              width: kIsWeb ? 1.0 : 1.0.w,
                            ),
                          ),
                          hintText: "아이디를 입력하세요",
                        ),
                      ),
                    ),
                    SizedBox(
                      width: kIsWeb ? 80 : 80.w,
                      child: ElevatedButton(
                        onPressed: (id_valid == 0 || isLoading)
                            ? null
                            : _handleCheckId, // 👈 Model 호출 함수로 변경
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF007BFF),
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.all(10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              kIsWeb ? 10.0 : 10.0.r,
                            ),
                          ),
                          textStyle: TextStyle(color: Colors.white),
                        ),
                        child: isLoading
                            ? SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              )
                            : Text("중복확인"),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: kIsWeb ? 3 : 3.h),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    id_valid_comments[id_valid],
                    style: TextStyle(
                      fontSize: kIsWeb ? 12 : 12.r,
                      fontWeight: FontWeight.w500,
                      color: id_valid_comments_color[id_valid],
                    ),
                  ),
                ),
                SizedBox(height: kIsWeb ? 3 : 3.h),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    id_comments[id_ok],
                    style: TextStyle(
                      fontSize: kIsWeb ? 12 : 12.r,
                      fontWeight: FontWeight.w500,
                      color: id_comments_color[id_ok],
                    ),
                  ),
                ),
                SizedBox(height: kIsWeb ? 20 : 20.h),
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
                        inputPw = str;
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
                        width: kIsWeb ? 1.5 : 1.5.w,
                      ),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFFD1D1D1),
                        width: kIsWeb ? 1.0 : 1.0.w,
                      ),
                    ),
                    hintText: "비밀번호를 입력하세요",
                  ),
                ),
                SizedBox(height: kIsWeb ? 3 : 3.h),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    pw_comments[pw_ok],
                    style: TextStyle(
                      fontSize: kIsWeb ? 12 : 12.r,
                      fontWeight: FontWeight.w500,
                      color: pw_comments_color[pw_ok],
                    ),
                  ),
                ),
                SizedBox(height: kIsWeb ? 30 : 0.h),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed:
                        (id_ok == 2 && pw_ok == 1 && !isLoading) // ✨ 로딩 중 아닐 때만
                        ? _handleSignUp // 👈 Model 호출 함수로 변경
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF007BFF),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.all(15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          kIsWeb ? 10.0 : 10.0.r,
                        ),
                      ),
                      textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: kIsWeb ? 20 : 20.r,
                      ),
                    ),
                    child: isLoading
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text("회원가입"),
                  ),
                ),
                SizedBox(height: kIsWeb ? 10 : 10.h),
                Row(
                  children: [
                    SizedBox(width: kIsWeb ? 125 : 125.w),
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
                              bottom: BorderSide(width: kIsWeb ? 0.5 : 0.5.w),
                            ),
                          ),
                          child: Text(
                            "계정이 있으신가요?",
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
              ],
            ),
          ),
        ),
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

  bool isLogin = false;
  String inputId = ""; // 사용자에게 입력받을것!!
  String inputPw = "";

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
                        inputId = str;
                      });
                    },
                    decoration: InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFF0088FF),
                          width: kIsWeb ? 1.5 : 1.5.w,
                        ),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFFD1D1D1),
                          width: kIsWeb ? 1.0 : 1.0.w,
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
                        inputPw = str;
                      });
                    },
                    decoration: InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFF0088FF),
                          width: kIsWeb ? 1.5 : 1.5.w,
                        ),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFFD1D1D1),
                          width: kIsWeb ? 1.0 : 1.0.w,
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
                    onPressed: inputId == "" || inputPw == ""
                        ? null
                        : () async {
                            // (안전) "await"가 시작되기 "전"에
                            //    context에서 필요한 것들을 미리 변수에 담아둡니다.
                            //    (이 시점의 context는 100% 안전합니다.)
                            final userModel = context.read<UserModel>();
                            final scaffoldMessenger = ScaffoldMessenger.of(
                              context,
                            );

                            // Model의 login 함수 호출 (페이지 전환은 auth_wrapper에서 담당)
                            await userModel.login(inputId, inputPw);

                            // --- 3. (비동기 갭 이후) ---
                            //    (이 아래부터는 위젯이 사라졌을 수도 있음 )

                            //    위젯이 화면에 없으면(mounted == false) 즉시 함수를 종료합니다.
                            if (!context.mounted) return;

                            // (안전) 이제 위젯이 살아있음이 보장되었으므로,
                            //    미리 준비해둔 변수들을 안전하게 사용합니다.
                            if (userModel.error != null) {
                              scaffoldMessenger.showSnackBar(
                                SnackBar(
                                  content: Text(userModel.error!),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }

                            // (성공한 경우)
                            // userModel.error == null 이므로, 이 코드는 무시됩니다.
                            // AuthWrapper가 변경된 userModel.isLoggedIn 상태를 감지하고
                            // 알아서 MainView로 전환시켜 줍니다.
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF007BFF),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.all(15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          kIsWeb ? 10 : 10.0.r,
                        ),
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
