// utils/category_translator.dart (새 파일)

const Map<String, String> categoryTranslations = {
  'ANDROID_WEAR': '워치 앱',
  'ART_AND_DESIGN': '예술/디자인',
  'AUTO_AND_VEHICLES': '자동차',
  'BEAUTY': '뷰티',
  'BOOKS_AND_REFERENCE': '도서/참조',
  'BUSINESS': '비즈니스',
  'COMICS': '만화',
  'COMMUNICATION': '커뮤니케이션',
  'DATING': '데이트',
  'EDUCATION': '교육',
  'ENTERTAINMENT': '엔터', 
  'EVENTS': '이벤트',
  'FINANCE': '금융',
  'FOOD_AND_DRINK': '음식/음료',
  'HEALTH_AND_FITNESS': '건강/운동',
  'HOUSE_AND_HOME': '주거',
  'LIBRARIES_AND_DEMO': '라이브러리',
  'LIFESTYLE': '라이프스타일',
  'MAPS_AND_NAVIGATION': '지도/내비',
  'MEDICAL': '의료',
  'MUSIC_AND_AUDIO': '음악/오디오',
  'NEWS_AND_MAGAZINES': '뉴스/잡지',
  'PARENTING': '육아',
  'PERSONALIZATION': '맞춤설정',
  'PHOTOGRAPHY': '사진',
  'PRODUCTIVITY': '생산성',
  'SHOPPING': '쇼핑',
  'SOCIAL': '소셜',
  'SPORTS': '스포츠',
  'TOOLS': '도구',
  'TRAVEL_AND_LOCAL': '여행/지역',
  'VIDEO_PLAYERS': '동영상', // 간결하게
  'WATCH_FACE': '워치 페이스',
  'WEATHER': '날씨',
  'GAME': '게임',
  'UNKNOWN': '기타', // 알 수 없는 카테고리 처리
};

String translateCategory(String englishName) {
  return categoryTranslations[englishName] ?? englishName; // Map에 없으면 영어 이름 그대로 반환
}