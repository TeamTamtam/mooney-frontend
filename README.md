# mooney frontend repo
<br>

## 📚 사용한 오픈소스 프레임워크

본 프로젝트는 **Flutter** 프레임워크를 기반으로 개발되었습니다.

- Flutter SDK: **3.5.3**
- Dart SDK: **3.5.3**
- Flutter 공식 사이트: [flutter.dev](https://flutter.dev)

<br><br>


## 📚 사용한 오픈소스 라이브러리

| 패키지명 | 버전 | 설명 | 링크 |
|----------|--------|------|------|
| flutter_svg | ^1.0.0 | SVG 이미지 렌더링 지원 | [pub.dev/flutter_svg](https://pub.dev/packages/flutter_svg) |
| table_calendar | ^3.0.8 | 커스터마이징 가능한 캘린더 위젯 | [pub.dev/table_calendar](https://pub.dev/packages/table_calendar) |
| fl_chart | ^0.65.0 | 다양한 차트 UI (막대, 선, 원형 등) 지원 | [pub.dev/fl_chart](https://pub.dev/packages/fl_chart) |
| dio | ^5.7.0 | HTTP 클라이언트 (API 요청용) | [pub.dev/dio](https://pub.dev/packages/dio) |
| flutter_secure_storage | ^9.2.2 | 암호화된 안전한 로컬 스토리지 (토큰 저장 등) | [pub.dev/flutter_secure_storage](https://pub.dev/packages/flutter_secure_storage) |
| shared_preferences | ^2.5.0 | Key-Value 로컬 저장소 | [pub.dev/shared_preferences](https://pub.dev/packages/shared_preferences) |
| flutter_riverpod | ^2.6.1 | 상태 관리 라이브러리 (Provider 기반) | [pub.dev/flutter_riverpod](https://pub.dev/packages/flutter_riverpod) |
| flutter_dotenv | ^5.2.1 | `.env` 환경 변수 파일 로딩용 | [pub.dev/flutter_dotenv](https://pub.dev/packages/flutter_dotenv) |
| android_intent_plus | ^4.0.1 | Android 앱 외부 인텐트 실행용 | [pub.dev/android_intent_plus](https://pub.dev/packages/android_intent_plus) |
| flutter_lints | ^4.0.0 | 권장 린트 규칙 세트 (코드 품질 검사용) | [pub.dev/flutter_lints](https://pub.dev/packages/flutter_lints) |
| flutter_test | (SDK 포함) | 테스트 작성용 공식 Flutter 도구 | [flutter.dev/testing](https://docs.flutter.dev/testing) |

> ✅ 위 라이브러리들은 모두 [pub.dev](https://pub.dev)에서 공개된 오픈소스 패키지이며, pubspec.yaml 기준 최신 안정 버전을 명시했습니다.

<br><br>

## 📦 Git 클론 후 앱 설치 및 실행 방법 (re-generate 가능)

이 항목에서는 GitHub에서 본 프로젝트를 클론한 사용자가  
**로컬에서 앱을 설치하고 실행할 수 있도록** 단계별로 안내합니다. 
설치(Git 클론 -> 필요 설정) 와 앱 실행의 두 단계로 나누어 설명합니다.

---

### 1️⃣ 프로젝트 설치



### 1. 레포지토리 클론
먼저 아래 작업은 **Android Studio를 열기 전에**, **윈도우 명령 프롬프트(cmd)** 또는 **터미널(터미널 앱)**에서 진행합니다.
```bash
git clone https://github.com/TeamTamtam/mooney-frontend.git # 프로젝트 코드를 내 컴퓨터에 복사(clone)합니다.
cd mooney-frontend                                            # 복사된 프로젝트 폴더로 이동합니다.
```

> 💡 참고: Git이 설치되어 있지 않다면 먼저 [Git 설치하기](https://git-scm.com/downloads)를 참고하세요.

<br>

### 2. Android Studio로 프로젝트 열기

1. Android Studio를 실행합니다.  
2. 첫 화면 또는 상단 메뉴에서 `File > Open`을 클릭합니다.  
3. 방금 클론한 폴더(`mooney-frontend`)를 찾아 선택합니다.  
4. 프로젝트가 열리면, 하단에 **"Terminal"** 탭을 클릭합니다.  
   (또는 상단 메뉴에서 `View > Tool Windows > Terminal`)
<br>


### 3. 패키지 설치

Android Studio의 **하단 터미널(Terminal)** 창에 아래 명령어를 입력합니다:

```bash
flutter pub get  # 앱 실행에 필요한 외부 라이브러리(패키지)를 설치합니다.
```

> ✅ 이 명령어는 Flutter SDK가 설치되어 있어야 작동합니다.  
> Flutter가 설치되어 있지 않다면 [Flutter 설치 가이드](https://docs.flutter.dev/get-started/install)를 참고해 주세요.

<br>

### 4. 환경 변수 파일 생성

계속해서 Android Studio 하단의 **Terminal**에서 아래 명령어를 입력합니다:

```bash
cp .env.example .env  # 환경 설정 예시 파일을 복사하여 실제 환경 설정 파일(.env)로 만듭니다.
```

그런 다음, 프로젝트 내 `.env` 파일을 열어 아래처럼 **실제 API 서버 주소를 입력**해 주세요:

```
BASE_URL=https://[서버주소를_여기에_입력하세요]
```

> ❗ 정확한 BASE_URL 값은 팀원이나 관리자에게 직접 문의해서 받아야 합니다.  
> 이 값이 없으면 앱에서 API 요청이 실패할 수 있습니다.
> 보안 사유로 API의 BASE_URL은 외부에 공개하지 않았으므로, BASE_URL을 원하시는 분은 jhjh2002109@ewhain.net으로 문의 바랍니다.

<br><br>



## 2️⃣ 앱 실행 및 테스트 방법

### ✅ 방법 1: Android Studio에서 실행 (에뮬레이터 또는 실기기 사용)

1. Android Studio에서 프로젝트(`mooney-frontend`)가 열린 상태에서,
2. 상단 툴바에서 실행할 디바이스(에뮬레이터 또는 USB 연결된 스마트폰)를 선택합니다.
3. ▶ Run 버튼(또는 `Shift + F10`)을 클릭하면 앱이 자동으로 빌드되어 선택한 디바이스에서 실행됩니다.

> 💡 참고: 에뮬레이터가 없다면 `Tools > Device Manager > Create Device`에서 가상 디바이스를 생성할 수 있습니다.  
> 실기기에서는 USB 디버깅이 활성화되어 있어야 합니다 (`설정 > 개발자 옵션 > USB 디버깅`).

<br>

### ✅ 방법 2: APK 파일로 빌드 후 설치 (안드로이드 스마트폰 사용)

#### 1. Android Studio 하단 터미널에서 아래 명령어를 입력:

```bash
flutter build apk --release  # 최적화된 릴리즈용 APK 파일을 생성합니다.
```

#### 2. 빌드된 APK 파일 경로:

```
build/app/outputs/flutter-apk/app-release.apk
```

#### 3. 생성된 `app-release.apk` 파일을 스마트폰으로 전송하고 설치

- 이메일 / 카카오톡 / USB / 클라우드(예: Google Drive) 등을 통해 APK를 디바이스에 복사합니다.
- 스마트폰에서 파일을 열면 설치 창이 나타납니다.
- "출처를 알 수 없는 앱 허용" 설정이 필요할 수 있습니다.

> ✅ APK 설치 후 앱 아이콘이 홈 화면에 나타나며 일반 앱처럼 실행할 수 있습니다.
> 서비스의 모든 api 사용을 위해서는, 와이파이/데이터 등 인터넷이 연결된 환경에서 사용해주시길 바랍니다.
