# King Flutter app

Flutter-based prototype for King. It contains the complete demonstration flow:

- create or join a council
- enter with a Supabase anonymous guest session, without registration
- submit an anonymous opinion
- review an OpenRouter verdict and its rationale, with a local fallback
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

## Supabase and AI

The app uses Supabase anonymous authentication. Rooms, memberships, opinions,
verdicts, and final records are stored by the connected Supabase Edge Function.
Every room API request verifies the guest JWT, and each guest can submit only
one opinion per room.

When a room is created, the app stores a device-only owner recovery token in
secure storage. If Supabase issues a new anonymous user ID later, joining the
same room from that device restores the owner role without exposing the token
to other participants.

OpenRouter requests run only inside the Supabase Edge Function. Configure
`OPENROUTER_API_KEY` as a server secret; never pass it to Flutter.

```sh
flutter run
```

The connected project URL and public anon key are included as safe client
configuration. They can be overridden for another Supabase project with
`SUPABASE_URL` and `SUPABASE_ANON_KEY` Dart defines.

Anonymous sign-ins must be enabled in Supabase Authentication settings.

## Apply the database schema

The normalized King schema lives in `supabase/migrations`. It creates rooms,
memberships, one anonymous opinion per member, stored verdicts, capacity-safe
room joining, and row-level security for anonymous authenticated users.

```sh
npx supabase@latest link --project-ref rchsglmfecttutixzxht
npx supabase@latest db push
```

## Deploy the Edge Function

Figma publishes the Next.js/Payload site, but the connected Supabase project
still requires its Edge Function to be deployed with Supabase tooling:

```sh
supabase login
supabase functions deploy server --project-ref rchsglmfecttutixzxht
```

Run the command from the repository root. The Flutter client calls the deployed
`server` function at `/functions/v1/server`.

The Supabase CLI loads `supabase/functions/server/index.ts`, which imports the
Figma Make implementation from `index.tsx`. Keep both files when exporting or
copying the project.

## Test the complete LLM flow

From the repository root in PowerShell, set the public Supabase anon key for the
current terminal session and run the integration test:

```powershell
$env:SUPABASE_ANON_KEY="your-public-anon-key"
.\scripts\test-king-flow.ps1
```

If local script execution is restricted, use:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\test-king-flow.ps1
```

The test creates one anonymous user and one test room, stores an opinion,
requests a real OpenRouter verdict, and finalizes the room. It consumes one LLM
request and leaves the test records in Supabase for inspection.

The verdict pipeline treats topics and opinions as untrusted data, flags common
instruction-like phrases, applies equal-weight fairness rules, requests a strict
JSON schema, retries once after a transient or malformed response, and records
the model plus prompt version with each verdict.

## My rooms and saved records

The Flutter home screen has a **회의 기록** button. It opens a dedicated history
screen listing rooms joined by the current Supabase user, newest first, in pages
of 20. The home screen itself does not query or display the room list. Tap an active room to return without an invite code, or a
finalized room to read its saved decision without requesting another AI verdict.
Pull down or use refresh to reload; the list also refreshes after returning to the history screen from a room.
Opening history again reloads the list, including newly created or joined rooms.

The list uses the authenticated Supabase client with an explicit membership
filter and the existing `rooms_select_for_members` / membership RLS policies.
Apply the existing migrations before use. No new migration, Edge Function
endpoint, server secret, or server deployment is required for this feature.
Existing create/join, opinion submission, and finalization flows remain in place.

This is scoped to the current guest user ID. Losing that session or signing in
as a different guest does not recover the previous guest's history. Continuing
with another agenda in the same room is not part of this change.

Run the regression checks with `flutter test test/my_rooms_test.dart`.
