import { createApp } from './app.js';

const port = Number(process.env.PORT || 3000);
const host = process.env.HOST || '127.0.0.1';
createApp().listen(port, host, () => {
  console.log(`KING demo server: http://${host}:${port}`);
  console.log('메모리 저장 · 인증 없음 · 실제 LLM 미연결. 로컬 개발용입니다.');
});
