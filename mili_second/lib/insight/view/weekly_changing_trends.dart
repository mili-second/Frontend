import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/foundation.dart';

class WeeklyChangingTrends extends StatelessWidget {
  final String comment;
  final String totalUsageTime;
  final List<List> categoryUsageTime;

  const WeeklyChangingTrends({
    super.key,
    required this.comment,
    required this.totalUsageTime,
    required this.categoryUsageTime,
  });

  @override
  Widget build(BuildContext context) {
    Color totalUsageColor = Color(0xFFFF6565); // 기본값
    if (totalUsageTime.startsWith('+')) {
      totalUsageColor = Colors.green;
    } else if (totalUsageTime.startsWith('-')) {
      totalUsageColor = Color(0xFF51B4FF);
    }

    List<Widget> categoryWidgets = categoryUsageTime
        .take(3)
        .map<Widget>((categoryData) {
          Color changeColor = Color(0xFFFF8551);
          if (categoryData.length > 1) {
            if (categoryData[1].startsWith('+')) {
              changeColor = Colors.green;
            } else if (categoryData[1].startsWith('-')) {
              changeColor = Color(0xFF51B4FF);
            }
          }
          return SizedBox(
            width: kIsWeb ? 80 : 80.w,
            height: kIsWeb ? 95 : 95.h,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  categoryData.isNotEmpty ? categoryData[0] : 'N/A',
                  style: TextStyle(
                    color: Color(0xFF000000),
                    fontSize: kIsWeb ? 14 : 14.r,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: kIsWeb ? 5 : 5.h),
                Text(
                  categoryData.length > 1 ? categoryData[1] : 'N/A',
                  style: TextStyle(
                    color: changeColor,
                    fontSize: kIsWeb ? 20 : 20.r,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          );
        })
        .expand((widget) => [
              widget,
              SizedBox(width: kIsWeb ? 20 : 20.w)
            ])
        .toList();

    // 마지막 간격 제거
    if (categoryWidgets.isNotEmpty) {
      categoryWidgets.removeLast();
    }

    // ✨ 2. 아이템 개수에 따라 정렬 방식 결정
    MainAxisAlignment rowAlignment = categoryUsageTime.length < 3
        ? MainAxisAlignment.center // 3개 미만이면 가운데 정렬
        : MainAxisAlignment.start;  // 3개면 왼쪽 정렬 (또는 spaceBetween 등)

    return Container(
      width: kIsWeb ? 362 : 362.w,
      height: kIsWeb ? 340 : 340.h,
      decoration: BoxDecoration(
        color: Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(kIsWeb ? 10 : 10.r),
        border: Border.all(color: Color(0xFFA2A2A2), width: kIsWeb ? 1 : 1.w),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          top: kIsWeb ? 15 : 15.h,
          left: kIsWeb ? 20 : 20.w,
          right: kIsWeb ? 20 : 20.w,
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/icons/weeklyChangeGraph.png',
                  width: kIsWeb ? 42 : 42.w,
                  height: kIsWeb ? 42 : 42.h,
                ),
                SizedBox(width: kIsWeb ? 10 : 10.w),
                Text(
                  '주간 변화 트렌드',
                  style: TextStyle(
                    color: Color(0xFF000000),
                    fontSize: kIsWeb ? 17 : 17.r,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            SizedBox(height: kIsWeb ? 5 : 5.h),
            Container(
              width: kIsWeb ? 310 : 310.w,
              height: kIsWeb ? 1 : 1.h,
              decoration: BoxDecoration(color: Color(0xFFBEBEBE)),
            ),
            SizedBox(height: kIsWeb ? 15 : 15.h),
            SizedBox(
              width: kIsWeb ? 280 : 280.w,
              height: kIsWeb ? 60 : 60.h,
              child: Text(
                comment.replaceAllMapped(
                  RegExp(r'([.!?])\s*'), // . 또는 ! 또는 ? 뒤의 공백까지 매칭
                  (match) => '${match[1]}\n', // 그 기호 뒤에 줄바꿈 추가
                ),
                style: TextStyle(
                  color: Color(0xFF000000),
                  fontSize: kIsWeb ? 15 : 15.r,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            SizedBox(
              width: kIsWeb ? 240 : 240.w,
              height: kIsWeb ? 70 : 70.h,
              child: Row(
                children: [
                  Text(
                    '총 사용 시간',
                    style: TextStyle(
                      color: Color(0xFF000000),
                      fontSize: kIsWeb ? 20 : 20.r,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: kIsWeb ? 20 : 20.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        totalUsageTime,
                        style: TextStyle(
                          color: Color(0xFFFF6565),
                          fontSize: kIsWeb ? 24 : 24.r,
                          fontWeight: FontWeight.w700,
                        ),
                      ),

                      Text(
                        '(전주 대비)',
                        style: TextStyle(
                          color: Color(0xFFFF6565),
                          fontSize: kIsWeb ? 15 : 15.r,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: kIsWeb ? 10 : 10.h),
            Stack(
              children: [
                Container(
                  width: kIsWeb ? 300 : 300,
                  height: kIsWeb ? 100 : 100.h,
                  decoration: BoxDecoration(
                    color: Color(0xFFD9D9D9).withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(kIsWeb ? 10 : 10.r),
                  ),
                ),
                Positioned(
                  top: 0, // 상단 정렬
                  bottom: 0, // 하단 정렬 (Stack 높이 내에서 중앙 정렬 위함)
                  left: 0, // 왼쪽 끝
                  right: 0, // 오른쪽 끝
                  child: Padding(
                    // 내부 여백은 Row가 아닌 Padding으로 조절
                    padding: EdgeInsets.symmetric(
                      horizontal: kIsWeb ? 15 : 15.w, // 좌우 여백
                      vertical: kIsWeb ? 2.5 : 2.5.h, // 상하 여백 (SizedBox 높이와 연관)
                    ),
                    child: Row(
                      // ✨ 3. 결정된 정렬 방식 적용
                      mainAxisAlignment: rowAlignment,
                      children: categoryWidgets, // ✨ 4. 미리 생성된 위젯 리스트 사용
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
