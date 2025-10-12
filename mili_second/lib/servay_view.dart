import 'package:flutter/material.dart';
import 'package:mili_second/main_view.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SurveyView extends StatefulWidget {
  SurveyView({super.key, required this.user_id});

  String user_id;

  @override
  State<SurveyView> createState() => _SurveyViewState();
}

class _SurveyViewState extends State<SurveyView> {
  // user info
  String nickname = "";
  int gender = -1; // 0 : 남자, 1 : 여자
  String job = ""; // 직접입력때문에 string으로 받음

  int user_step = 0; // 0 : 닉넴임 입력단계
  // 1 : 성별 입력단계
  // 2 : 직업 입력단계
  // -> 여기서 확인 누르면 회원가입 완료!
  bool can_next = false;

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    user_step == 0
                        ? "닉네임"
                        : user_step == 1
                        ? "성별"
                        : "직업",
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 25.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "을 입력해주세요",
                    style: TextStyle(
                      fontSize: 25.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              Padding(
                padding: EdgeInsets.all(5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("아이디", style: TextStyle(color: Colors.black45)),
                    SizedBox(
                      height: 30,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          widget.user_id,
                          style: TextStyle(fontSize: 18.sp),
                        ),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      "닉네임",
                      style: TextStyle(
                        color: user_step == 0 ? Colors.blue : Colors.black45,
                      ),
                    ),
                    SizedBox(
                      height: 40.h,
                      child: user_step == 0
                          ? TextField(
                              onChanged: (String str) {
                                setState(() {
                                  nickname = str;
                                  can_next = nickname == "" ? false : true;
                                });
                              },
                              decoration: InputDecoration(
                                hintText: "닉네임을 입력하세요",
                              ),
                            )
                          : Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                nickname,
                                style: TextStyle(fontSize: 18.sp),
                              ),
                            ),
                    ),
                    SizedBox(height: 10.h),
                    user_step > 0
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "성별",
                                style: TextStyle(
                                  color: user_step == 0
                                      ? Colors.blue
                                      : Colors.black45,
                                ),
                              ),
                              SizedBox(height: 15.h),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 2.4,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          gender = 1;
                                          can_next = true;
                                        });
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: gender == 1
                                            ? Colors
                                                  .blue // 선택됐을 때 파란색
                                            : Colors.grey[300], // 선택 안 됐을 때 회색
                                        foregroundColor: gender == 1
                                            ? Colors
                                                  .white // 선택됐을 때 글자색
                                            : Colors.black54, // 선택 안 됐을 때 글자색
                                        // 버튼 크기
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            10.0,
                                          ),
                                        ),
                                        padding: EdgeInsets.all(15),
                                      ),
                                      child: Text("여자"),
                                    ),
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 2.4,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          gender = 0;
                                          can_next = true;
                                        });
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: gender == 0
                                            ? Colors
                                                  .blue // 선택됐을 때 파란색
                                            : Colors.grey[300], // 선택 안 됐을 때 회색
                                        foregroundColor: gender == 0
                                            ? Colors
                                                  .white // 선택됐을 때 글자색
                                            : Colors.black54, // 선택 안 됐을 때 글자색
                                        // 버튼 크기
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            10.0,
                                          ),
                                        ),
                                        padding: EdgeInsets.all(15),
                                      ),
                                      child: Text("남자"),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20.h),
                              user_step > 1
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "직업",
                                          style: TextStyle(
                                            color: user_step == 0
                                                ? Colors.blue
                                                : Colors.black45,
                                          ),
                                        ),
                                        SizedBox(height: 15.h),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            SizedBox(
                                              width:
                                                  MediaQuery.of(
                                                    context,
                                                  ).size.width /
                                                  3.5,
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  setState(() {
                                                    job = "학생";
                                                    can_next = true;
                                                  });
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: job == "학생"
                                                      ? Colors
                                                            .blue // 선택됐을 때 파란색
                                                      : Colors
                                                            .grey[300], // 선택 안 됐을 때 회색
                                                  foregroundColor: job == "학생"
                                                      ? Colors
                                                            .white // 선택됐을 때 글자색
                                                      : Colors
                                                            .black54, // 선택 안 됐을 때 글자색
                                                  // 버튼 크기
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          10.0.r,
                                                        ),
                                                  ),
                                                  padding: EdgeInsets.all(15),
                                                ),
                                                child: Text("학생"),
                                              ),
                                            ),
                                            SizedBox(
                                              width:
                                                  MediaQuery.of(
                                                    context,
                                                  ).size.width /
                                                  3.5,
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  setState(() {
                                                    job = "회사원";
                                                    can_next = true;
                                                  });
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: job == "회사원"
                                                      ? Colors
                                                            .blue // 선택됐을 때 파란색
                                                      : Colors
                                                            .grey[300], // 선택 안 됐을 때 회색
                                                  foregroundColor: job == "회사원"
                                                      ? Colors
                                                            .white // 선택됐을 때 글자색
                                                      : Colors
                                                            .black54, // 선택 안 됐을 때 글자색
                                                  // 버튼 크기
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          10.0.r,
                                                        ),
                                                  ),
                                                  padding: EdgeInsets.all(15),
                                                ),
                                                child: Text("회사원"),
                                              ),
                                            ),
                                            SizedBox(
                                              width:
                                                  MediaQuery.of(
                                                    context,
                                                  ).size.width /
                                                  3.5,
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  setState(() {
                                                    job = "프리랜서";
                                                    can_next = true;
                                                  });
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: job == "프리랜서"
                                                      ? Colors
                                                            .blue // 선택됐을 때 파란색
                                                      : Colors
                                                            .grey[300], // 선택 안 됐을 때 회색
                                                  foregroundColor: job == "프리랜서"
                                                      ? Colors
                                                            .white // 선택됐을 때 글자색
                                                      : Colors
                                                            .black54, // 선택 안 됐을 때 글자색
                                                  // 버튼 크기
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          10.0,
                                                        ),
                                                  ),
                                                  padding: EdgeInsets.all(15),
                                                ),
                                                child: Text("프리랜서"),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 5.h),
                                        Text("그 외 (직접입력)"),
                                        TextField(
                                          onChanged: (String str) {
                                            setState(() {
                                              job = str;
                                              can_next = job == ""
                                                  ? false
                                                  : true;
                                            });
                                          },
                                          decoration: InputDecoration(
                                            hintText: "직업을 입력하세요",
                                          ),
                                        ),
                                      ],
                                    )
                                  : SizedBox.shrink(),
                            ],
                          )
                        : SizedBox.shrink(),
                  ],
                ),
              ),
              SizedBox(height: 10.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: can_next
                      ? () {
                          setState(() {
                            user_step++;
                            can_next = false;
                          });
                          if (user_step > 2) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MainView(),
                              ),
                            );
                          }
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.all(15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0.r),
                    ),
                    textStyle: TextStyle(color: Colors.white, fontSize: 20.sp),
                  ),
                  child: Text("확인"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
