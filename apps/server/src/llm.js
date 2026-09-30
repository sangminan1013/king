// API 키는 향후 이 서버의 환경변수로만 받습니다. 앱에 포함하지 않습니다.
export class DemoLlm {
  preprocess(text) { return text.trim(); }
  summarize(room) {
    return `임시 결과 · 실제 AI 분석이 아닙니다.\n\n주제: ${room.topic}\n수집된 의견: ${room.opinions.length}개\n\n` +
      room.opinions.map(o => `${o.author}\n조건: ${o.condition}\n의견: ${o.text}`).join('\n\n');
  }
}
