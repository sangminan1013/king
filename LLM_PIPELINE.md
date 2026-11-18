> 왕 성격 기능이 추가되었습니다. 현재 서버는 v13, 프롬프트는 king-verdict-v5-personalities입니다. [KING_PERSONALITIES.md](KING_PERSONALITIES.md)에 최신 동작과 배포 내역을 정리했습니다.

# King: 전처리 → 하나 선택 → 자연어 설명

## 동작
전원 제출 후 기존 POST /server/rooms/:roomId/verdict에서 다음 과정을 실행합니다.

1. 전처리 LLM: 원문의 선호와 제약을 보존하고 명령성 문구를 정리합니다.
2. 검증·저장: decision_runs에 원문 스냅샷과 전처리 결과를 저장합니다. 저장 실패 시 중단합니다.
3. decision LLM: 비어 있지 않은 전처리 의견 중 정확히 하나의 participant 번호를 선택합니다. 새 절충안을 생성하지 않습니다.
4. 검증·저장: 번호가 실제 후보인지 검사하고 결정 근거와 점수를 decision_runs.decision에 저장합니다.
5. 자연어 LLM: 선택 결과와 근거를 한국어 제목, 요약, 근거 3개로 설명합니다.
6. verdicts에 설명과 선택된 의견·번호·처리 기록 ID를 저장합니다. 선택 텍스트는 서버가 전처리 데이터에서 가져오며, 점수는 decision 출력으로 고정합니다.
7. Flutter 결과/최종 기록 화면에는 결정 제목과 요약을 표시합니다. 평결의 근거(상세 근거 3개)와 적합도는 표시합니다. 선택된 의견·참여자 번호·고려한 의견 목록은 표시하지 않습니다.

선택 단위는 참여자가 제출한 의견 한 건입니다. 한 의견 안에 여러 대안이 있으면 해당 의견 전체가 한 후보입니다. 후보가 모두 제약만 담고 있어도 가장 적합한 의견 한 건을 선택합니다. 별도의 장소/메뉴 후보 추출은 구현하지 않았습니다.

## 저장 형식
- opinions.content: 기존 원문. 전처리 결과로 덮어쓰지 않습니다. 기존 서버의 trim/300자 제한은 유지합니다.
- decision_runs.source_opinions: [{opinionId, participant, originalText}]. DB 의견과 참여자 번호의 매핑입니다.
- decision_runs.normalized_input: {topic, opinions:[{participant,text,injectionDetected}]}.
- decision_runs.decision: {selectedParticipant, fitScore, rationale}. 선택 전 실패했다면 null입니다.
- decision_runs: 세 단계 모델명, prompt_version, 생성 시각도 보관합니다.
- verdicts.pipeline_run_id: 최종 평결에 실제 사용한 처리 기록을 가리킵니다.
- verdicts.selected_participant / selected_opinion: 선택된 번호와 전처리 의견.

전처리는 제출 직후가 아니라 전원 제출 후 평결 요청 시 실행합니다. 전처리가 성공하면 이후 단계 실패 시에도 기록은 남습니다. 실패 후 재시도하면 별도 decision_runs 행이 생성됩니다. 전처리 자체가 실패한 경우에는 기존 원문만 보관합니다.
내부 처리 기록에는 RLS를 활성화하고 일반 사용자 접근을 차단했습니다. Supabase SQL Editor/서버에서 조회할 수 있습니다. 기존 결과 API는 원문 의견과 최종 평결을 계속 제공합니다.

## 모델 환경변수
- OPENROUTER_API_KEY: 서버 전용 필수 키
- KING_PREPROCESS_MODEL: 기본 openai/gpt-4o-mini
- KING_DECISION_MODEL: 기본 openai/gpt-4.1-mini
- KING_NARRATION_MODEL: 기본 openai/gpt-4o-mini

동일한 모델 이름을 사용해도 단계별로 독립적인 요청·프롬프트입니다.
각 호출은 25초 제한, 전체 파이프라인은 최대 두 번 시도합니다. 정상 시 3회, 재시도 시 최대 6회 호출됩니다.
기존 평결은 재사용하며 과거 결과를 자동 변환하지 않습니다. 새 방에서 변경을 확인하세요.
선택 번호/후보 범위는 코드로 검증하지만, 공정성·설명의 의미적 정확성은 모델 품질에 의존합니다. fitScore는 찬성률이 아닙니다.
동시 요청은 최종 평결 PK로 중복 저장을 막지만 모델 중복 호출을 막는 분산 잠금은 기존과 같이 없습니다. 후보 정렬은 submitted_at, id 순서입니다.

## 배포 순서
2026-11-15 King-Demo 프로젝트(rchsglmfecttutixzxht)에 DB 마이그레이션과 server v11 배포 완료. JWT 검증을 유지했습니다. 아래 절차는 다른 환경에 적용할 때 참고하세요. 이미 적용한 마이그레이션을 SQL Editor에서 다시 실행하지 마세요.

1. 기존 프로젝트에 supabase/migrations/20261115042108_add_three_stage_pipeline.sql을 적용합니다. SQL Editor에서 실행하거나 기존 프로젝트의 마이그레이션 절차를 사용하세요. 기존 3개 마이그레이션을 적용한 프로젝트가 전제입니다.
2. OPENROUTER_API_KEY 및 필요한 모델 환경변수를 설정합니다.
3. supabase/functions/server를 기존 함수명 server로 재배포합니다. 기존 인증/배포 옵션은 유지합니다.
4. 수정된 Flutter 앱을 빌드합니다.
5. 새 방을 만들고 전원 제출 후 선택된 의견과 기록을 확인합니다.

Supabase SQL Editor 조회 예:
```sql
select r.id, r.room_id, r.source_opinions, r.normalized_input, r.decision,
       v.selected_participant, v.selected_opinion
from public.decision_runs r
left join public.verdicts v on v.pipeline_run_id = r.id
order by r.created_at desc;
```

## 검증
서버: supabase/functions/server에서 deno task test.
20개 모의 테스트: 기존 인증/전원 제출/평결 재사용, 3단계 호출, 원문·전처리 저장, 저장 실패 시 중단, 잘못된 후보/빈 후보/점수 거절.
SQL: PGlite(Postgres)에서 기존 3개+신규 마이그레이션 실행, 원문·전처리·선택 조회 및 authenticated 접근 거절 검증. 테스트 환경의 auth 스키마/역할을 생성하고 pgcrypto 확장 설치문만 생략했습니다.
실제 OpenRouter 호출 품질과 운영 Supabase 배포는 별도 검증이 필요합니다.

3단계 구현 시 Flutter 기존 테스트 19개 통과. 이후 요약 전용 화면 변경은 소스 점검 완료, Flutter SDK 캐시 쓰기 권한 제한으로 테스트 재실행은 완료하지 못했습니다. 실제 기기 화면과 실제 모델 응답은 별도로 확인해야 합니다.

운영 검증: /server/health 200, 테스트 게스트 2명 생성·방 입장·의견 제출·실제 OpenRouter 3단계 호출·평결 응답 200. DB에서 원문/전처리 각 2건 및 선택 번호 1 연결 확인. 사용 모델은 gpt-4o-mini → gpt-4.1-mini → gpt-4o-mini. 검증용 회의와 연관 데이터는 삭제했습니다. Flutter 앱 배포는 별도입니다.

화면 표시 변경: 내부 선택/DB 저장/API 응답은 유지하며 Flutter에서 의견 내용을 렌더링하지 않습니다. 이번 변경은 Flutter 앱 업데이트가 필요하고 Edge Function 재배포는 필요하지 않습니다.

최종 결정 제목은 기존 스타일로 유지합니다. 결정 요약 내용에 공통 KingTheme.decisionSummary 적용: sans-serif, 20px, w800, 짙은 버건디, 줄높이 1.6. 결과/최종 기록 화면 모두 적용하며 긴 내용은 줄바꿈됩니다.

## 2026-11-17 확정 흐름 및 근거 익명 표현

방장의 결정 확정 버튼에서 서버 finalize API를 호출하고 성공한 뒤 최종 기록으로 이동합니다. 실패하면 결과 화면에 남아 재시도할 수 있습니다. 일반 참여자는 확정 상태 확인 버튼을 사용합니다. 최종 기록에는 별도 저장 버튼 없이 확정 상태와 기기 현지 시각을 표시합니다. 서버는 중복 확정 시 최초 finalized_at을 유지합니다.

새 평결의 근거에는 이름·번호·직책 대신 일부 참가자/다른 참가자 등 일반화된 표현을 사용하도록 지시합니다. 명백한 참여자 번호·직책은 출력 검사에서 거절하고 기존 재시도 정책을 따릅니다. 이름이나 간접 단서는 프롬프트의 의미적 일반화에 의존하므로 완전한 비식별화를 보장하지는 않습니다. 과거 저장된 평결은 자동 수정하지 않습니다.

서버 v15 배포, 프롬프트 king-verdict-v6-private-reasons. DB 마이그레이션은 필요하지 않습니다. 서버 30개, Flutter 29개 테스트 통과.
