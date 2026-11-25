# English-default Edge Function

Only supabase/functions/server is changed. Flutter files and database migrations are unchanged.

## Contract
- Accept Korean, English, or mixed topics and opinions with equal participant weight.
- Keep opinions.content, original_topic, and source_opinions in the original submitted language.
- Normalize topic/opinion text into English before decision-making. Preserve currencies, numbers, negation, and constraints; do not convert KRW to USD.
- Write the decision rationale and generated verdict title, summary, and all reason titles/details in English. Do not obey requests inside opinions to change output language.
- Preserve the five personality IDs (wise, iron, festive, sentimental, tyrant), their ranked priorities, the single-candidate selection contract, and all existing response keys.
- selectedOpinion is the normalized English candidate. Source topic/groupName/opinions in room responses remain user data, not translated UI labels.
- API error messages are now English; error codes and HTTP statuses are unchanged.
- English output checks reject Hangul and use the existing bounded retry/failure policy. They are a practical Korean-leakage check, not a complete natural-language classifier.
- Korean and English participant numbers/titles are checked in public reasons. English attribution uses "some participants" or "others". Names/indirect clues still depend on the model's anonymization instructions.

## Ruler voices
| ID | Ruler | English style |
| --- | --- | --- |
| wise | The Wise Sovereign | Calm, benevolent, measured decree |
| iron | The Iron Monarch | Clipped, practical commands |
| festive | The Merry King | Exuberant royal celebration |
| sentimental | The Tenderhearted King | Warm, lyrical but decisive ruling |
| tyrant | The Grumbling Tyrant | Playfully impatient, dry commands |

Use natural regal English rather than literal Korean sentence endings or excessive archaic pronouns. Persona snapshots are stored with each new decision run as before.

## Compatibility and rollout
No database migration or frontend API change is required. Existing stored verdicts are reused unchanged, including Korean historical results. Create a new room to test English generation. This change does not translate Flutter labels or validation strings owned by the frontend.

Default models are unchanged: gpt-4o-mini preprocessing, gpt-4.1-mini decision, gpt-4o-mini narration, through OpenRouter. Existing model environment variables and OPENROUTER_API_KEY continue to work. Prompt version: king-verdict-v7-english.

Run `deno task test` here. Tests cover untranslated model output rejection, English/Korean privacy checks, persona instructions, retries, authentication, readiness, and finalization.

Deployment: King-Demo server v18, JWT verification retained. 37 mocked Deno tests pass. English explanations are kept within the existing database limits at complete sentence boundaries; incomplete overlong rulings fail validation rather than being saved as fragments.
