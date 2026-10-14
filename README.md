# King

익명으로 의견을 모아 함께 결정하는 앱의 최신 프로토타입입니다. 기존 `project/`의 내용을 저장소 최상위로 옮겼으며, 이전 `apps/mobile`과 `apps/server` 구현은 제거했습니다.

## 프로젝트 구성

```text
king/
├── flutter_app/       Dart + Flutter 앱
├── src/               React 웹 프로토타입
├── .figma/make/       웹 메타데이터
├── index.html
├── package.json
├── pnpm-lock.yaml
└── vite.config.ts
```

두 버전 모두 로컬 상태와 모의 AI 결과를 사용하는 프로토타입입니다. 실제 서버·DB·로그인·LLM API는 연결되어 있지 않으며, 기기 간 방 공유도 아직 지원하지 않습니다. 기존 Node.js 서버도 제거된 상태입니다.

## Flutter 앱

자세한 준비 방법은 [Flutter README](flutter_app/README.md)를 참고하세요. 저장소 루트에서:

```bash
cd flutter_app
flutter pub get
flutter create . --platforms=android,ios
flutter run
```

Android·iOS 실행용 플랫폼 파일은 처음 실행할 때 생성합니다. Mac에서 실행하려면 플랫폼 생성 명령을 `flutter create . --platforms=macos`로 바꾸고 `flutter run -d macos`를 사용하세요.

## 웹 프로토타입

Node.js 22.12 이상과 Corepack을 사용할 수 있는 환경에서 저장소 루트에서 실행합니다.

```bash
corepack pnpm install --frozen-lockfile
corepack pnpm dev
```

브라우저에서 `http://localhost:8443`을 엽니다. 현재 개발 서버는 자동으로 시작되지 않습니다.

```bash
corepack pnpm build
corepack pnpm exec tsc --noEmit
```

## Flutter 검증

```bash
cd flutter_app
flutter pub get
dart analyze lib test
flutter test
```
