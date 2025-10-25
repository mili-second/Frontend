import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/foundation.dart';
import 'package:mili_second/model/user_model.dart';
import 'package:provider/provider.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  // 닉네임 수정 데이터 처리
  late TextEditingController _currentUserNickNameController;
  String user_id = "";
  int id_ok =
      0; // 아이디 사용 가능 여부 (회원가입 가능 여부) 0 : 중복확인 안함  //  1 : 중복아이디  // 2 : 사용가능 아이디
  List<String> id_comments = ["중복확인을 해주세요", "중복된 닉네임 입니다", "사용가능한 닉네임입니다"];
  List<Color> id_comments_color = [Colors.black, Colors.red, Colors.green];

  // 성별 수정 데이터 처리
  final List<String> userGender = ['남성', '여성'];
  int? _selectedGenderIndex;

  // 직업 수정 데이터 처리
  final List<String> userJob = ['학생', '회사원', '프리랜서'];
  int? _selectedJobIndex;

  TextEditingController _userJobController = TextEditingController();

  // 프로필 수정 데이터 처리
  final List<String> userProfilesPaths = [
    'assets/icons/profile/profile1.png',
    'assets/icons/profile/profile2.png',
    'assets/icons/profile/profile3.png',
    'assets/icons/profile/profile4.png',
    'assets/icons/profile/profile5.png',
    'assets/icons/profile/profile6.png',
    'assets/icons/profile/profile7.png',
    'assets/icons/profile/profile8.png',
  ];
  int? _selectedProfileIndex;

  @override
  void initState() {
    super.initState();

    // 1. initState 맨 위에서 UserModel을 *한 번만* 읽어옵니다.
    final userModel = context.read<UserModel>();

    // 2. 이제 'userModel' 변수를 사용해 모든 값을 초기화합니다.

    // 닉네임 초기화
    String initialUserId = userModel.userId ?? "Default User";
    _currentUserNickNameController = TextEditingController(text: initialUserId);

    // 성별 초기화
    _selectedGenderIndex = userGender.indexOf(userModel.userGender ?? "성별없음");

    // 직업 초기화
    _userJobController = TextEditingController();
    if (userModel.userJob != null && userModel.userJob!.isNotEmpty) {
      int index = userJob.indexOf(userModel.userJob!);
      if (index != -1) {
        _selectedJobIndex = index;
        _userJobController.text = ''; // 기존 로직 유지
      } else {
        _selectedJobIndex = null;
        _userJobController.text = userModel.userJob ?? "직업 선택 안함";
      }
    }

    // 프로필 이미지 초기화
    _selectedProfileIndex = userProfilesPaths.indexOf(
      userModel.userProfileImage ?? 'assets/icons/profile_default.png',
    );
    if (_selectedProfileIndex == -1) {
      _selectedProfileIndex = null;
    }
  }

  // 직업 선택(버튼 or 텍스트필드)
  String getSelectedJob() {
    if (_selectedJobIndex != null) {
      return userJob[_selectedJobIndex!];
    } else {
      return _userJobController.text;
    }
  }

  @override
  Widget build(BuildContext contet) {
    return Scaffold(
      appBar: AppBar(
        title: SizedBox(
          child: Row(
            children: [
              SizedBox(width: kIsWeb ? 80 : 80.w),
              Text(
                '프로필 수정',
                style: TextStyle(
                  color: Color(0xFF000000),
                  fontSize: kIsWeb ? 20 : 20.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        toolbarHeight: kIsWeb ? 100 : 100.h,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Container(height: kIsWeb ? 1 : 1.h, color: Color(0xFFCDCBCB)),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(
          top: kIsWeb ? 30 : 30.h,
          bottom: kIsWeb ? 20 : 20.h,
          left: kIsWeb ? 38 : 38.w,
          right: kIsWeb ? 20 : 20.w,
        ),
        child: Column(
          children: [
            // 닉네임 수정
            SizedBox(
              width: kIsWeb ? 340 : 340.w,
              height: kIsWeb ? 30 : 30.h,
              child: Text(
                '닉네임',
                style: TextStyle(
                  color: Color(0xFF0090FF),
                  fontSize: kIsWeb ? 17 : 17.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            SizedBox(height: kIsWeb ? 15 : 15.h),
            SizedBox(
              width: kIsWeb ? 340 : 340.w,
              height: kIsWeb ? 50 : 50.h,
              child: Row(
                children: [
                  SizedBox(
                    width: kIsWeb ? 250 : 250.w,
                    child: TextField(
                      controller: _currentUserNickNameController,
                      style: TextStyle(
                        color: Color(0xFF000000),
                        fontSize: kIsWeb ? 20 : 20.sp,
                        fontWeight: FontWeight.w500,
                      ),
                      cursorColor: Color(0xFF007BFF),
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
                        hintText: "닉네임을 입력하세요",
                      ),
                    ),
                  ),
                  SizedBox(width: kIsWeb ? 10 : 10.h),
                  // 중복 확인 버튼
                  SizedBox(
                    width: kIsWeb ? 80 : 80.w,
                    height: kIsWeb ? 60 : 60.h,
                    child: ElevatedButton(
                      onPressed:
                          _currentUserNickNameController.text.trim().isEmpty
                          ? null
                          : () => id_duplicate_check(context),
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
                      child: Text(
                        "중복확인",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: kIsWeb ? 5 : 5.h),
            SizedBox(
              width: kIsWeb ? 340 : 340.w,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  id_comments[id_ok],
                  style: TextStyle(
                    fontSize: kIsWeb ? 12 : 12.sp,
                    fontWeight: FontWeight.w500,
                    color: id_comments_color[id_ok],
                  ),
                ),
              ),
            ),

            SizedBox(height: kIsWeb ? 25 : 25.h),

            // 성별 수정
            // SizedBox(
            //   width: 329.w,
            //   height: 30.h,
            //   child: Text(
            //     '성별',
            //     style: TextStyle(
            //       color: Color(0xFF0090FF),
            //       fontSize: 17.sp,
            //       fontWeight: FontWeight.w700,
            //     ),
            //   ),
            // ),
            // SizedBox(height: 15.h),
            // SizedBox(
            //   width: 329.w,
            //   height: 50.h,
            //   child: Row(
            //     children: List.generate(userGender.length, (index) {
            //       bool isSelected = _selectedGenderIndex == index;
            //       return Padding(
            //         padding: EdgeInsets.only(right: index == 0 ? 8.w : 0),
            //         child: GestureDetector(
            //           onTap: () {
            //             setState(() {
            //               _selectedGenderIndex = index;
            //             });
            //           },
            //           child: Container(
            //             width: 155.w,
            //             height: 45.h,
            //             decoration: BoxDecoration(
            //               color: isSelected
            //                   ? Color(0xFF3A86FF)
            //                   : Color(0xFFD1D1D1),
            //               borderRadius: BorderRadius.circular(6.r),
            //             ),
            //             alignment: Alignment.center,
            //             child: Text(
            //               userJob[index],
            //               style: TextStyle(
            //                 color: Colors.white,
            //                 fontSize: 20.sp,
            //                 fontWeight: FontWeight.w500,
            //               ),
            //             ),
            //           ),
            //         ),
            //       );
            //     }),
            //   ),
            // ),

            // SizedBox(height: 25.h),

            // 직업 수정
            // SizedBox(
            //   width: 329.w,
            //   height: 30.h,
            //   child: Text(
            //     '직업',
            //     style: TextStyle(
            //       color: Color(0xFF0090FF),
            //       fontSize: 17.sp,
            //       fontWeight: FontWeight.w700,
            //     ),
            //   ),
            // ),
            // SizedBox(height: 15.h),
            // SizedBox(
            //   width: 329.w,
            //   height: 45.h,
            //   child: Row(
            //     children: List.generate(userJob.length, (index) {
            //       bool isSelected = _selectedJobIndex == index;
            //       return Padding(
            //         padding: EdgeInsets.only(right: 8.w),
            //         child: GestureDetector(
            //           onTap: () {
            //             setState(() {
            //               if (_selectedJobIndex == index) {
            //                 // 이미 선택된 버튼 취소
            //                 _selectedJobIndex = null;
            //               } else {
            //                 _selectedJobIndex = index; // 새로운 선택
            //                 _userJobController.clear(); // 텍스트 필드 초기화
            //               }
            //             });
            //           },
            //           child: Container(
            //             width: 100.w,
            //             height: 45.h,
            //             decoration: BoxDecoration(
            //               color: isSelected
            //                   ? Color(0xFF0088FF)
            //                   : Color(0xFFD1D1D1),
            //               borderRadius: BorderRadius.circular(6.r),
            //             ),
            //             alignment: Alignment.center,
            //             child: Text(
            //               userJob[index],
            //               style: TextStyle(
            //                 color: Color(0xFFFFFFFF),
            //                 fontSize: 20.sp,
            //                 fontWeight: FontWeight.w500,
            //               ),
            //             ),
            //           ),
            //         ),
            //       );
            //     }),
            //   ),
            // ),
            // SizedBox(height: 15.h),
            // SizedBox(
            //   width: 329.w,
            //   child: Text(
            //     '그 외 (직접입력)',
            //     style: TextStyle(
            //       color: Color(0xFF616161),
            //       fontSize: 15.sp,
            //       fontWeight: FontWeight.w600,
            //     ),
            //   ),
            // ),
            // SizedBox(height: 10.h),
            // SizedBox(
            //   width: 329.w,
            //   height: 30.h,
            //   child: TextField(
            //     controller: _userJobController,
            //     enabled: _selectedJobIndex == null,
            //     style: TextStyle(
            //       color: Color(0xFF000000),
            //       fontSize: 20.sp,
            //       fontWeight: FontWeight.w600,
            //     ),
            //     decoration: InputDecoration(
            //       contentPadding: EdgeInsets.symmetric(vertical: 15.h),
            //       focusedBorder: UnderlineInputBorder(
            //         borderSide: BorderSide(
            //           color: Color(0xFF0088FF),
            //           width: 1.5,
            //         ),
            //       ),
            //       enabledBorder: UnderlineInputBorder(
            //         borderSide: BorderSide(
            //           color: Color(0xFFD1D1D1),
            //           width: 1.0,
            //         ),
            //       ),
            //     ),
            //   ),
            // ),

            // SizedBox(height: 25.h),

            // 프로필 사진 수정
            SizedBox(
              width: kIsWeb ? 340 : 340.w,
              height: kIsWeb ? 30 : 30.h,
              child: Text(
                '프로필 사진',
                style: TextStyle(
                  color: Color(0xFF0090FF),
                  fontSize: kIsWeb ? 17 : 17.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            SizedBox(height: kIsWeb ? 15 : 15.h),
            SizedBox(
              width: kIsWeb ? 340 : 340.w,
              height: kIsWeb ? 200 : 200.h,
              child: GridView.count(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 4,
                crossAxisSpacing: 5,
                mainAxisSpacing: 8,
                children: List.generate(userProfilesPaths.length, (index) {
                  bool isSelected = _selectedProfileIndex == index;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedProfileIndex = index;
                      });
                    },
                    child: Container(
                      width: kIsWeb ? 70 : 70.w,
                      height: kIsWeb ? 70 : 70.h,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: isSelected
                              ? Color(0xFF0088FF)
                              : Color(0xFFD1D1D1),
                          width: isSelected ? 3 : 1,
                        ),
                        borderRadius: BorderRadius.circular(kIsWeb ? 41 : 41.r),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(kIsWeb ? 8 : 8.r),
                        child: Image.asset(
                          userProfilesPaths[index],
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),

            SizedBox(height: kIsWeb ? 50 : 50.h),

            // 수정된 정보 저장
            SizedBox(
              width: kIsWeb ? 329 : 329.w,
              child: GestureDetector(
                onTap: () {
                  // 닉네임, 프로필 저장하기
                  // 프로필 저장은 프론트에서 처리하고 백엔드에는 enum으로 1,2,3,4.. 로 보내기
                  // 저장 완료 후 이전 화면으로 돌아가기 (프로필 정보 화면)
                  // if (success){
                  // Navigator.pop(context, true);
                  // }
                  // else {

                  // }
                  Navigator.pop(context, true);
                },
                child: Container(
                  width: kIsWeb ? 340 : 340.w,
                  height: kIsWeb ? 60 : 60.h,
                  decoration: BoxDecoration(
                    color: Color(0xFF0088FF),
                    borderRadius: BorderRadius.circular(kIsWeb ? 10 : 10.r),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '확인',
                    style: TextStyle(
                      color: Color(0xFFFFFFFF),
                      fontSize: kIsWeb ? 20 : 20.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ],
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
