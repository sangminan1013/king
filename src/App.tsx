import { useMemo, useState, type ReactNode } from "react";

type Screen = "home" | "create" | "join" | "room" | "result" | "summary" | "settings";

const demoOpinions = [
  "예산을 아끼되 모두가 함께 즐길 수 있는 곳이면 좋겠습니다.",
  "이동 시간이 짧고 실내 활동이 포함된 선택지를 선호합니다.",
  "새로운 경험도 좋지만 식사 선택권이 넓었으면 합니다.",
];

function Icon({ name, size = 22 }: { name: "plus" | "door" | "gear" | "back" | "users" | "copy" | "lock" | "quill" | "crown" | "check" | "spark" | "logout"; size?: number }) {
  const paths: Record<string, ReactNode> = {
    plus: <><path d="M12 5v14M5 12h14" /></>,
    door: <><path d="M5 21h14M7 21V4a1 1 0 0 1 1-1h9v18M14 12h.01" /></>,
    gear: <><circle cx="12" cy="12" r="3" /><path d="M19.4 15a1.7 1.7 0 0 0 .34 1.88l.06.06-2.83 2.83-.06-.06A1.7 1.7 0 0 0 15 19.4a1.7 1.7 0 0 0-1 .6 1.7 1.7 0 0 0-.4 1.1V21h-4v-.1A1.7 1.7 0 0 0 8.6 19.4a1.7 1.7 0 0 0-1.88.34l-.06.06-2.83-2.83.06-.06A1.7 1.7 0 0 0 4.6 15a1.7 1.7 0 0 0-.6-1 1.7 1.7 0 0 0-1.1-.4H3v-4h.1A1.7 1.7 0 0 0 4.6 8.6a1.7 1.7 0 0 0-.34-1.88l-.06-.06 2.83-2.83.06.06A1.7 1.7 0 0 0 9 4.6a1.7 1.7 0 0 0 1-.6 1.7 1.7 0 0 0 .4-1.1V3h4v.1A1.7 1.7 0 0 0 15.4 4a1.7 1.7 0 0 0 1.88-.34l.06-.06 2.83 2.83-.06.06A1.7 1.7 0 0 0 19.4 9c.16.37.37.72.6 1 .3.35.7.54 1.1.6h.1v4h-.1c-.4.06-.8.25-1.1.6-.23.28-.44.63-.6 1Z" /></>,
    back: <><path d="m15 18-6-6 6-6" /></>,
    users: <><path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2M9 11a4 4 0 1 0 0-8 4 4 0 0 0 0 8ZM22 21v-2a4 4 0 0 0-3-3.87M16 3.13a4 4 0 0 1 0 7.75" /></>,
    copy: <><rect x="9" y="9" width="12" height="12" rx="2" /><path d="M5 15H4a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h9a2 2 0 0 1 2 2v1" /></>,
    lock: <><rect x="4" y="10" width="16" height="11" rx="2" /><path d="M8 10V7a4 4 0 0 1 8 0v3" /></>,
    quill: <><path d="M20.5 3.5c-5-2-10.5 1-13 6-1.2 2.4-1.7 5-1.5 7.5M3 21c2.5-4 6.5-7 12-9M12 13l-3-3M16 9l-3-3" /></>,
    crown: <><path d="m3 7 4 4 5-7 5 7 4-4-2 11H5L3 7ZM5 21h14" /></>,
    check: <><path d="m5 12 4 4L19 6" /></>,
    spark: <><path d="m12 3 1.4 4.1L17.5 8.5l-4.1 1.4L12 14l-1.4-4.1-4.1-1.4 4.1-1.4L12 3ZM19 15l.7 2.3L22 18l-2.3.7L19 21l-.7-2.3L16 18l2.3-.7L19 15Z" /></>,
    logout: <><path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4M16 17l5-5-5-5M21 12H9" /></>,
  };
  return <svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.7" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true">{paths[name]}</svg>;
}

function Crest({ small = false }: { small?: boolean }) {
  return (
    <div className={small ? "crest crest-small" : "crest"} aria-hidden="true">
      <svg viewBox="0 0 100 112">
        <path className="crest-wreath" d="M25 84C7 68 9 37 25 22M75 84c18-16 16-47 0-62M22 72l-10 2M20 61 9 58M20 49l-9-5M25 35l-8-8M78 72l10 2M80 61l11-3M80 49l9-5M75 35l8-8" />
        <path className="crest-fill" d="m31 28 9 10 10-20 10 20 9-10-4 27H35l-4-27Z" />
        <path className="crest-fill" d="M30 63c10-7 30-7 40 0v12c-10 12-30 12-40 0V63Z" />
        <path className="crest-line" d="M36 65v10M50 61v20M64 65v10M27 88h46" />
      </svg>
    </div>
  );
}

function Shell({ children, compact = false }: { children: ReactNode; compact?: boolean }) {
  return (
    <main className="app-shell">
      <div className="noise" />
      <div className={`page ${compact ? "page-compact" : ""}`}>{children}</div>
    </main>
  );
}

function Header({ title, onBack, meta }: { title: string; onBack: () => void; meta?: string }) {
  return (
    <header className="topbar">
      <button className="icon-button" onClick={onBack} aria-label="뒤로 가기"><Icon name="back" /></button>
      <div><p className="eyebrow">{meta ?? "THE COUNCIL"}</p><h1>{title}</h1></div>
      <Crest small />
    </header>
  );
}

function Button({ children, onClick, variant = "primary", disabled = false }: { children: ReactNode; onClick?: () => void; variant?: "primary" | "secondary" | "ghost" | "danger"; disabled?: boolean }) {
  return <button className={`button button-${variant}`} onClick={onClick} disabled={disabled}>{children}</button>;
}

export default function App() {
  const [screen, setScreen] = useState<Screen>("home");
  const [groupName, setGroupName] = useState("금요일 원정대");
  const [topic, setTopic] = useState("이번 분기 팀 워크숍 장소는 어디가 좋을까요?");
  const [members, setMembers] = useState(5);
  const [joinCode, setJoinCode] = useState("");
  const [opinion, setOpinion] = useState("");
  const [submitted, setSubmitted] = useState(false);
  const [copied, setCopied] = useState(false);

  const backToHome = () => setScreen("home");
  const roomCode = "CROWN-27";
  const participantCount = submitted ? 4 : 3;
  const canCreate = groupName.trim() && topic.trim() && members >= 2;
  const progress = useMemo(() => Math.round((participantCount / members) * 100), [participantCount, members]);

  if (screen === "home") {
    return (
      <Shell>
        <section className="home">
          <div className="brand-block">
            <Crest />
            <p className="eyebrow">A FAIR DECISION, TOGETHER</p>
            <h1 className="display">King</h1>
            <p className="brand-subtitle">모두의 목소리를 모아<br />공정한 하나의 답으로</p>
          </div>
          <div className="action-stack">
            <Button onClick={() => setScreen("create")}><Icon name="plus" /><span><b>새로운 회의 열기</b><small>안건을 세우고 사람들을 초대하세요</small></span></Button>
            <Button variant="secondary" onClick={() => setScreen("join")}><Icon name="door" /><span><b>초대 코드로 입장</b><small>익명으로 의견을 보태세요</small></span></Button>
            <button className="text-link" onClick={() => setScreen("settings")}><Icon name="gear" size={18} /> 환경 설정</button>
          </div>
          <p className="privacy-note"><Icon name="lock" size={14} /> 이름 없이, 편견 없이. 의견은 결정이 끝나면 봉인됩니다.</p>
        </section>
      </Shell>
    );
  }

  if (screen === "create") {
    return (
      <Shell>
        <Header title="새 회의 열기" onBack={backToHome} meta="CONVENE A COUNCIL" />
        <section className="content">
          <div className="chapter"><span>I</span><div><p>첫 번째 장</p><h2>회의의 이름을 정하세요</h2></div></div>
          <label className="field"><span>그룹명</span><input value={groupName} onChange={(e) => setGroupName(e.target.value)} maxLength={24} /><small>{groupName.length} / 24</small></label>
          <label className="field"><span>결정할 안건</span><textarea value={topic} onChange={(e) => setTopic(e.target.value)} rows={4} maxLength={120} /><small>{topic.length} / 120</small></label>
          <div className="member-select">
            <div><span className="field-title">참여 인원</span><p>의견을 제출할 최대 인원</p></div>
            <div className="stepper">
              <button onClick={() => setMembers(Math.max(2, members - 1))} aria-label="인원 줄이기">−</button>
              <strong>{members}<small>명</small></strong>
              <button onClick={() => setMembers(Math.min(12, members + 1))} aria-label="인원 늘리기">＋</button>
            </div>
          </div>
          <aside className="ink-note"><Icon name="quill" /><p>각 참여자의 의견은 서로에게 공개되지 않습니다. 모두 제출하면 AI 평결이 시작됩니다.</p></aside>
          <Button onClick={() => setScreen("room")} disabled={!canCreate}><Icon name="crown" />회의 개설하기</Button>
        </section>
      </Shell>
    );
  }

  if (screen === "join") {
    return (
      <Shell compact>
        <Header title="회의 입장" onBack={backToHome} meta="ENTER THE CHAMBER" />
        <section className="content join-content">
          <div className="seal"><Icon name="door" size={34} /></div>
          <h2>초대장을 확인합니다</h2>
          <p className="muted">방장이 공유한 8자리 코드를 입력하세요.</p>
          <label className="field code-field"><span>초대 코드</span><input value={joinCode} onChange={(e) => setJoinCode(e.target.value.toUpperCase())} placeholder="CROWN-27" maxLength={8} autoFocus /></label>
          <Button onClick={() => setScreen("room")} disabled={joinCode.length < 6}>회의실 문 열기</Button>
          <p className="privacy-note"><Icon name="lock" size={14} /> 별도의 이름이나 계정 정보는 표시되지 않습니다.</p>
        </section>
      </Shell>
    );
  }

  if (screen === "room") {
    return (
      <Shell>
        <Header title={groupName} onBack={backToHome} meta={`ROOM · ${roomCode}`} />
        <section className="content room-content">
          <div className="room-status">
            <div><span className="live-dot" />의견 수집 중</div>
            <div><Icon name="users" size={18} /> {participantCount} / {members}</div>
          </div>
          <div className="topic-card">
            <p className="eyebrow">TODAY'S DECISION</p>
            <h2>{topic}</h2>
            <div className="progress-track"><span style={{ width: `${progress}%` }} /></div>
            <small>{participantCount}명이 의견을 제출했습니다</small>
          </div>
          <div className="invite-row">
            <div><small>초대 코드</small><strong>{roomCode}</strong></div>
            <button onClick={() => { navigator.clipboard?.writeText(roomCode); setCopied(true); }}><Icon name={copied ? "check" : "copy"} size={18} />{copied ? "복사됨" : "복사"}</button>
          </div>
          <div className="opinion-panel">
            <div className="chapter small-chapter"><span>II</span><div><p>두 번째 장</p><h2>당신의 조건을 들려주세요</h2></div></div>
            {submitted ? (
              <div className="submitted-state">
                <div className="seal seal-check"><Icon name="check" size={30} /></div>
                <h3>의견이 봉인되었습니다</h3>
                <p>다른 참여자의 제출을 기다리고 있습니다.<br />내용은 누구에게도 표시되지 않습니다.</p>
                <Button variant="secondary" onClick={() => setScreen("result")}><Icon name="spark" />AI 평결 미리보기</Button>
              </div>
            ) : (
              <>
                <label className="field parchment-field"><textarea value={opinion} onChange={(e) => setOpinion(e.target.value)} rows={6} maxLength={300} placeholder={"중요하게 생각하는 조건, 피하고 싶은 선택,\n원하는 결과를 자유롭게 적어주세요."} /><small>{opinion.length} / 300</small></label>
                <p className="helper"><Icon name="lock" size={14} /> 제출 후에는 수정할 수 없으며 익명으로 처리됩니다.</p>
                <Button onClick={() => setSubmitted(true)} disabled={opinion.trim().length < 10}><Icon name="quill" />의견 봉인하기</Button>
              </>
            )}
          </div>
        </section>
      </Shell>
    );
  }

  if (screen === "result") {
    return (
      <Shell>
        <Header title="AI의 평결" onBack={() => setScreen("room")} meta="THE VERDICT" />
        <section className="content result-content">
          <div className="verdict-hero">
            <Crest />
            <p className="eyebrow">THE COUNCIL HAS DECIDED</p>
            <h2>도심 근교의<br /><em>복합 문화 공간</em></h2>
            <p>모두의 조건을 가장 균형 있게 충족하는 선택입니다.</p>
          </div>
          <div className="reason-card">
            <div className="reason-heading"><span>평결의 근거</span><b>적합도 92%</b></div>
            <ul>
              <li><Icon name="check" size={17} /><span><b>접근성</b>대중교통으로 40분 이내 이동 가능</span></li>
              <li><Icon name="check" size={17} /><span><b>선택의 폭</b>실내 활동과 다양한 식사 옵션을 함께 제공</span></li>
              <li><Icon name="check" size={17} /><span><b>예산 균형</b>설정된 1인 예산 범위 안에서 운영 가능</span></li>
            </ul>
          </div>
          <details className="details">
            <summary>AI가 고려한 의견 보기 <span>＋</span></summary>
            <div>{demoOpinions.map((item, i) => <p key={item}><b>익명 {i + 1}</b>{item}</p>)}</div>
          </details>
          <div className="split-actions">
            <Button variant="secondary" onClick={() => { setOpinion(""); setSubmitted(false); setTopic(""); setScreen("create"); }}>다른 안건 시작</Button>
            <Button onClick={() => setScreen("summary")}>결정 확정하기</Button>
          </div>
          <p className="ai-disclaimer">AI의 평결은 참여자 의견을 바탕으로 한 제안이며, 중요한 결정은 함께 다시 검토해 주세요.</p>
        </section>
      </Shell>
    );
  }

  if (screen === "summary") {
    return (
      <Shell compact>
        <Header title="최종 기록" onBack={() => setScreen("result")} meta="COUNCIL ARCHIVE" />
        <section className="content summary-content">
          <div className="archive-mark"><Icon name="crown" size={32} /></div>
          <p className="eyebrow">DECISION RECORDED</p>
          <h2>{groupName}</h2>
          <p className="date">2025년 6월 18일 · 참여자 {members}명</p>
          <div className="archive-card">
            <span>결정 안건</span><p>{topic}</p>
            <hr />
            <span>최종 평결</span><h3>도심 근교의 복합 문화 공간</h3>
            <blockquote>“접근성, 활동 선택권, 예산의 균형을 가장 잘 충족합니다.”</blockquote>
          </div>
          <Button variant="secondary" onClick={() => window.print()}>기록 인쇄하기</Button>
          <Button variant="ghost" onClick={backToHome}><Icon name="logout" />처음으로 돌아가기</Button>
        </section>
      </Shell>
    );
  }

  return (
    <Shell compact>
      <Header title="환경 설정" onBack={backToHome} meta="PREFERENCES" />
      <section className="content settings">
        <div className="seal"><Icon name="gear" size={30} /></div>
        <h2>곧 준비될 예정입니다</h2>
        <p>알림, 언어, AI 평결 방식과<br />개인정보 설정이 이곳에 추가됩니다.</p>
        <Button variant="secondary" onClick={backToHome}>첫 화면으로</Button>
      </section>
    </Shell>
  );
}
