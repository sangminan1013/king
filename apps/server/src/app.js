import { createServer } from 'node:http';
import { ApiError, MemoryRoomStore } from './store.js';
import { DemoLlm } from './llm.js';

async function readJson(req) {
  let data = '';
  let size = 0;
  for await (const chunk of req) {
    size += chunk.length;
    if (size > 16384) throw new ApiError(413, '입력 데이터가 너무 큽니다.');
    data += chunk;
  }
  try {
    const parsed = JSON.parse(data || '{}');
    if (!parsed || typeof parsed !== 'object' || Array.isArray(parsed)) throw new Error();
    return parsed;
  } catch { throw new ApiError(400, '올바른 JSON 객체가 필요합니다.'); }
}

export function createApp({ store = new MemoryRoomStore(), llm = new DemoLlm() } = {}) {
  return createServer(async (req, res) => {
    const send = (status, data) => {
      res.writeHead(status, { 'Content-Type': 'application/json; charset=utf-8', 'Cache-Control': 'no-store' });
      res.end(JSON.stringify(data));
    };
    try {
      const path = new URL(req.url, 'http://localhost').pathname;
      if (req.method === 'GET' && path === '/health') return send(200, { status: 'ok', mode: 'demo' });
      if (req.method === 'POST' && path === '/rooms') return send(201, store.create(await readJson(req)));
      const match = path.match(/^\/rooms\/([A-Za-z0-9]{6})(?:\/(opinions|result|next|finish))?$/);
      if (match && req.method === 'GET' && !match[2]) return send(200, store.get(match[1]));
      if (match?.[2] && req.method === 'POST') {
        const input = await readJson(req);
        return send(200, store.update(match[1], match[2], input, llm));
      }
      throw new ApiError(404, '요청한 경로를 찾을 수 없습니다.');
    } catch (error) {
      send(error instanceof ApiError ? error.status : 500,
        { error: error instanceof ApiError ? error.message : '서버에서 오류가 발생했습니다.' });
    }
  });
}
