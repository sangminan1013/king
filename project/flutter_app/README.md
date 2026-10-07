# King Flutter app

Flutter-based, local-state MVP for King. It contains the complete prototype flow:

- create or join a council
- submit an anonymous opinion
- review a simulated AI verdict and its rationale
- view the final archived decision

## Run locally

Install Flutter 3.22 or newer, then run:

```sh
cd flutter_app
flutter create . --platforms=android,ios
flutter pub get
flutter run
```

`flutter create` adds the generated Android and iOS runner projects without replacing
the existing `lib/` source.

## Backend status

This version intentionally uses in-memory state and a simulated verdict. No server,
database, authentication provider, or LLM API is connected yet.
