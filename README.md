# Frontend

## 📁 프로젝트 구조

본 프로젝트는 **MVVM(Model–View–ViewModel)** 아키텍처를 기반으로 구성되어 있으며, 주요 기능별로 `home`, `analyze`, `insight`, `profile`, `setting` 폴더로 구분되어 있습니다.

```
/lib
├── main.dart                              # 앱 진입점
├── main_view.dart                         # 앱 기본 레이아웃 (Header, Footer, 홈/분석/인사이트 이동)
├── header_view.dart                       # 프로필(사진 & 이름) 표시
├── auth_wrapper.dart                      # 로그인 상태에 따라 홈 or 로그인 화면으로 라우팅
├── login_view.dart                        # 로그인 & 회원가입 화면
├── servay_view.dart                       # (현재 미사용)
│
├── home/
│   ├── model/
│   │   └── usage_event_info.dart          # 사용 데이터(Raw Data) 모델 클래스
│   ├── view/
│   │   └── home_view.dart                 # 홈 화면 (아래로 당겨 새로고침 시 raw_data 서버 전송)
│   └── view_model/
│       └── usage_data_view_model.dart     # 안드로이드 네이티브 코드와 통신해 usage data 수집
│
├── analyze/
│   ├── model/
│   │   ├── seven_days_usage_model.dart
│   │   ├── usage_patterns_by_time_of_day_model.dart
│   │   ├── top3_app_usage_model.dart
│   │   └── screentime_category_distribution_model.dart
│   ├── view/
│   │   ├── analyze_view.dart                        # 분석 위젯 관리
│   │   ├── seven_days_usage_trends.dart             # 7일간 사용 트렌드
│   │   ├── usage_patterns_by_time_of_day.dart       # 시간대별 사용 패턴
│   │   ├── top3_app_usage_trends.dart               # Top3 앱 사용 트렌드
│   │   └── screentime_category_distribution.dart    # 스크린타임 카테고리 분포
│   └── view_model/
│       ├── seven_days_usage_view_model.dart
│       ├── usage_patterns_by_time_of_day_view_model.dart
│       ├── top3_app_usage_view_model.dart
│       └── screentime_category_distribution_view_model.dart
│
├── insight/
│   ├── model/
│   │   ├── special_this_weeks_model.dart
│   │   ├── engagement_analysis_model.dart
│   │   ├── pattern_analysis_by_day_of_the_week_model.dart
│   │   └── weekly_changing_trends_model.dart
│   ├── view/
│   │   ├── insight_view.dart                        # 인사이트 위젯 관리
│   │   ├── special_this_weeks.dart                  # 이번 주 특이사항
│   │   ├── engagement_analysis.dart                 # SNS 몰입도 분석
│   │   ├── pattern_analysis_by_day_of_the_week.dart # 요일별 패턴 분석
│   │   └── weekly_changing_trends.dart              # 주간 변화 트렌드
│   └── view_model/
│       ├── special_this_weeks_view_model.dart
│       ├── engagement_analysis_view_model.dart
│       ├── pattern_analysis_by_day_of_the_week_view_model.dart
│       └── weekly_changing_trends_view_model.dart
│
├── profile/
│   ├── model/
│   ├── view/
│   │   ├── profile_info.dart               # 프로필 정보 화면
│   │   └── edit_profile.dart               # 프로필 편집 화면
│   └── view_model/
│       └── profile_provider.dart           # (현재 미사용)
│
├── setting/
│   ├── view/
│   │   ├── setting.dart                    # 설정 화면 (계정 관리 포함)
│   │   ├── account_management.dart         # 계정 관리 (약관 및 정책, 앱 정보)
│   │   ├── terms_and_conditions.dart       # (현재 미사용)
│   │   ├── app_information.dart            # 앱 정보 (회원 탈퇴 포함)
│   │   └── delete_account.dart             # 회원 탈퇴
│
└── model/
    └── user_model.dart                     # 사용자 정보/토큰 및 User API 함수 (로그인, 회원가입 등)
```

---

### 🧠 구조 요약

| 구분             | 설명                             |
| -------------- | ------------------------------ |
| **Model**      | 데이터 구조 정의 및 서버 통신 로직 포함        |
| **View**       | UI 구성 요소 및 화면 정의               |
| **ViewModel**  | View와 Model 간 데이터 바인딩 및 상태 관리  |
| **user_model** | 전역 사용자 상태 관리 및 인증 관련 API 호출 담당 |

