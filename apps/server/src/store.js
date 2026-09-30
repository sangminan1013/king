import { randomBytes, randomUUID } from 'node:crypto';

export class ApiError extends Error {
  constructor(status, message) { super(message); this.status = status; }
}

export function requiredText(value, label, max = 2000) {
  if (typeof value !== 'string' || !value.trim() || value.trim().length > max) {
    throw new ApiError(400, `${label}: 1~${max}자로 입력해주세요.`);
  }
  return value.trim();
}

// DB 선택 후 같은 인터페이스를 가진 영속 저장소로 교체합니다.
export class MemoryRoomStore {
  #rooms = new Map();
  create(input) {
    const name = requiredText(input.name, '그룹 이름', 80);
    const topic = requiredText(input.topic, '주제', 200);
    if (!Number.isInteger(input.capacity) || input.capacity < 2 || input.capacity > 20) {
      throw new ApiError(400, '인원수는 2~20명으로 설정해주세요.');
    }
    let code;
    do { code = randomBytes(3).toString('hex').toUpperCase(); } while (this.#rooms.has(code));
    const room = { code, name, topic, capacity: input.capacity, closed: false,
      round: 1, opinions: [], result: null, history: [] };
    this.#rooms.set(code, room);
    return room;
  }
  get(code) {
    const room = this.#rooms.get(code.toUpperCase());
    if (!room) throw new ApiError(404, '방을 찾을 수 없습니다. 참여 코드를 확인해주세요.');
    return room;
  }
  update(code, action, input, llm) {
    const room = this.get(code);
    if (room.closed) throw new ApiError(409, '종료된 방입니다.');
    switch (action) {
      case 'opinions': {
        if (room.result) throw new ApiError(409, '다음 안건을 시작해주세요.');
        if (room.opinions.length >= room.capacity) throw new ApiError(409, '설정한 인원수만큼 의견이 모였습니다.');
        const author = requiredText(input.author, '이름', 40);
        const text = requiredText(input.text, '의견');
        const condition = requiredText(input.condition, '조건');
        if (room.opinions.some(o => o.author === author)) throw new ApiError(409, '이 안건에 이미 의견을 제출한 이름입니다.');
        // 전처리 → 저장. 실제 LLM 연결 시 비동기 처리와 실패 복구를 추가합니다.
        room.opinions.push({ id: randomUUID(), author, condition, text: llm.preprocess(text) });
        break;
      }
      case 'result':
        if (!room.opinions.length) throw new ApiError(400, '먼저 의견을 입력해주세요.');
        room.result ??= llm.summarize(room);
        break;
      case 'next':
        if (!room.result) throw new ApiError(409, '현재 안건의 결과를 먼저 확인해주세요.');
        room.history.push({ round: room.round, result: room.result });
        room.round += 1; room.opinions = []; room.result = null;
        break;
      case 'finish':
        if (!room.result) throw new ApiError(409, '현재 안건의 결과를 먼저 확인해주세요.');
        room.history.push({ round: room.round, result: room.result });
        room.closed = true;
        break;
      default: throw new ApiError(404, '지원하지 않는 요청입니다.');
    }
    return room;
  }
}
