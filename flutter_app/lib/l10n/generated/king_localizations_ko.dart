// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'king_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class KingLocalizationsKo extends KingLocalizations {
  KingLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get brand => 'KING';

  @override
  String get slogan => '지혜가 모이는 어전';

  @override
  String get royalCourt => '어전';

  @override
  String get courtSettings => '환경설정';

  @override
  String get language => '언어';

  @override
  String get languageDescription => '앱에서 사용할 언어를 선택하세요.';

  @override
  String get english => 'English';

  @override
  String get korean => '한국어 (Korean)';

  @override
  String get languageSaveError => '언어 설정을 저장하지 못했습니다. 다시 시도해 주세요.';

  @override
  String get home => '홈으로';

  @override
  String get back => '뒤로 가기';

  @override
  String get signOut => '로그아웃';

  @override
  String get guestHeading => '이름 없이 어전에 입장하세요';

  @override
  String get guestDescription => '회원가입 없이 게스트 세션이 만들어집니다. 상소문에 신원은 표시되지 않습니다.';

  @override
  String get guestWarning =>
      '게스트 세션은 이 기기에 보관됩니다. 로그아웃하거나 앱 데이터를 지우면 기존 신원을 복구할 수 없습니다.';

  @override
  String get guestLoading => '게스트 세션을 만드는 중…';

  @override
  String get guestEnter => '게스트로 입장하기';

  @override
  String get guestError => '게스트 세션을 만들지 못했습니다. 네트워크 연결을 확인해 주세요.';

  @override
  String get guestDisabled => '현재 게스트로 입장할 수 없습니다.';

  @override
  String get guestRateLimited => '입장 시도가 너무 많습니다. 잠시 후 다시 시도해 주세요.';

  @override
  String get convene => '어전 개설';

  @override
  String get conveneDescription => '안건을 세우고 사람들을 초대하세요.';

  @override
  String get enterCourt => '어전 입장';

  @override
  String get enterDescription => '초대 코드로 입장하고 익명으로 의견을 보태세요.';

  @override
  String get history => '어전 기록';

  @override
  String get historyDescription => '참여한 어전과 이전 결정을 다시 확인하세요.';

  @override
  String get createHeading => '어전의 안건을 정하세요';

  @override
  String get groupName => '어전 이름';

  @override
  String get topic => '결정할 안건';

  @override
  String get demoGroup => '금요일 원정대';

  @override
  String get demoTopic => '이번 분기 팀 워크숍 장소는 어디가 좋을까요?';

  @override
  String get members => '어전 참여자';

  @override
  String get membersDescription => '모든 참여자가 상소문을 올리면 평결이 시작됩니다.';

  @override
  String memberCount(int count) {
    return '$count명';
  }

  @override
  String get fewerMembers => '참여 인원 줄이기';

  @override
  String get moreMembers => '참여 인원 늘리기';

  @override
  String get chooseKing => '왕 선택';

  @override
  String get chooseKingDescription => '왕마다 중요하게 여기는 기준과 말투가 다릅니다.';

  @override
  String kingSituation(String situations) {
    return '어울리는 상황: $situations';
  }

  @override
  String kingExample(String example) {
    return '“$example”';
  }

  @override
  String get petitionPrivacy =>
      '각 참여자의 상소문은 서로에게 공개되지 않습니다. 모두 제출하면 평결이 시작됩니다.';

  @override
  String get yourPetition => '내 상소문';

  @override
  String get creating => '어전을 여는 중…';

  @override
  String get joinHeading => '초대 코드를 입력하세요';

  @override
  String get joinDescription => '방장이 공유한 영문·숫자 6자리 코드를 입력하세요.';

  @override
  String get inviteCode => '초대 코드';

  @override
  String get inviteHint => '예: aB7xQ2';

  @override
  String get joining => '초대 코드를 확인하는 중…';

  @override
  String get joinPrivacy => '별도의 이름이나 계정 정보는 표시되지 않습니다.';

  @override
  String get copy => '복사';

  @override
  String get copied => '복사됨';

  @override
  String get receiving => '상소문 접수 중';

  @override
  String get todayTopic => '오늘의 안건';

  @override
  String submittedCount(int count) {
    return '$count명이 상소문을 올렸습니다';
  }

  @override
  String get submitPetition => '상소문 올리기';

  @override
  String get petitionHeading => '어전에 당신의 의견을 올리세요';

  @override
  String get petitionHint => '중요한 조건, 피하고 싶은 선택, 원하는 결과를 자유롭게 적어주세요.';

  @override
  String get petitionLocked => '제출 후에는 수정할 수 없으며 익명으로 처리됩니다.';

  @override
  String get sealing => '상소문을 봉인하는 중…';

  @override
  String get movingToWaiting => '대기 화면으로 이동합니다…';

  @override
  String get deliberation => '어전 논의';

  @override
  String get deliberating => '왕이 의견을 살피고 있습니다';

  @override
  String get sealed => '상소문이 봉인되었습니다';

  @override
  String submissionStatus(int submitted, int total) {
    return '상소문 접수 $submitted / $total명';
  }

  @override
  String get allSubmitted => '전원이 제출했습니다. 평결이 준비되면 결과로 이동합니다.';

  @override
  String waitingMembers(int count) {
    return '설정한 $count명 모두의 상소문을 기다리고 있습니다.';
  }

  @override
  String get checking => '확인하는 중…';

  @override
  String get checkStatus => '제출 현황 확인';

  @override
  String get checkHelp => '현황 확인을 누르면 최신 제출 상태를 확인합니다. 전원이 제출하면 평결을 생성합니다.';

  @override
  String get verdict => '왕의 결론';

  @override
  String get verdictUnavailable => '평결이 아직 준비되지 않았습니다. 대기 화면에서 제출 현황을 확인해 주세요.';

  @override
  String get verdictReasons => '평결의 근거';

  @override
  String fitScore(int score) {
    return '적합도 $score%';
  }

  @override
  String get newDecision => '다른 안건 시작';

  @override
  String get viewRecord => '최종 기록 보기';

  @override
  String get finalizing => '확정하는 중…';

  @override
  String get finalize => '결정 확정하기';

  @override
  String get waitingHost => '방장의 결정 확정을 기다리고 있습니다.';

  @override
  String get checkFinalization => '확정 상태 확인';

  @override
  String get reviewVerdict =>
      'AI의 평결은 참여자 의견을 바탕으로 한 제안이며, 중요한 결정은 함께 다시 검토해 주세요.';

  @override
  String get decree => '왕명';

  @override
  String get recorded => '결정 기록';

  @override
  String get confirmedDecision => '확정된 결정입니다.';

  @override
  String finalizedAt(String date) {
    return '확정 시각: $date';
  }

  @override
  String createdAt(String date) {
    return '생성 시각: $date';
  }

  @override
  String get myCourts => '내 어전';

  @override
  String get refreshCourts => '어전 기록 새로고침';

  @override
  String get reopenCourts => '참여한 어전과 이전 기록을 코드 없이 다시 열 수 있어요.';

  @override
  String get noCourts => '아직 참여한 어전이 없어요. 어전을 열거나 초대 코드로 입장해 보세요.';

  @override
  String get reloadCourts => '목록 다시 불러오기';

  @override
  String get loading => '불러오는 중…';

  @override
  String get moreCourts => '이전 어전 더 보기';

  @override
  String get historyPrivacy => '현재 게스트 세션의 기록입니다. 세션을 잃으면 목록을 복구할 수 없어요.';

  @override
  String get archivedStatus => '종료 · 기록 보기';

  @override
  String get activeStatus => '진행 중 · 다시 입장';

  @override
  String get host => '방장';

  @override
  String get sessionExpired => '게스트 세션이 만료되었습니다. 다시 입장해 주세요.';

  @override
  String get historyError => '어전 기록을 불러오지 못했습니다. 다시 시도해 주세요.';

  @override
  String get historyNetwork => '어전 기록에 연결하지 못했습니다. 네트워크 상태를 확인해 주세요.';

  @override
  String get serverError => '서버 요청에 실패했습니다. 다시 시도해 주세요.';

  @override
  String get invalidResponse => '서버 응답을 읽지 못했습니다.';

  @override
  String get verdictMissing => '저장된 평결을 찾지 못했습니다.';

  @override
  String get verdictWait => '설정한 참여 인원 모두가 제출할 때까지 기다려 주세요.';

  @override
  String get verdictPending => '평결이 아직 준비되지 않았습니다. 다시 확인해 주세요.';

  @override
  String get verdictError => 'AI 평결을 불러오지 못했습니다. 잠시 후 다시 시도해 주세요.';

  @override
  String get finalizeUnconfirmed => '결정 확정 상태를 확인하지 못했습니다. 다시 시도해 주세요.';

  @override
  String get finalizeError => '결정을 확정하지 못했습니다. 연결을 확인하고 다시 시도해 주세요.';

  @override
  String get networkError => '서버에 연결하지 못했습니다. 네트워크 상태를 확인해 주세요.';

  @override
  String get openRoomError => '어전을 열지 못했습니다.';

  @override
  String get notMember => '이 어전에 참여한 게스트만 접근할 수 있습니다.';

  @override
  String get invalidKing => '왕의 성격을 다시 선택해 주세요.';

  @override
  String get invalidRoom => '어전 이름과 안건, 참여 인원을 확인해 주세요.';

  @override
  String get invalidCode => '초대 코드를 입력해 주세요.';

  @override
  String get roomNotFound => '어전을 찾지 못했습니다.';

  @override
  String get roomClosed => '이미 종료된 어전입니다.';

  @override
  String get roomFull => '참여 가능한 인원이 모두 찼습니다.';

  @override
  String get verdictExists => '이미 평결이 내려진 어전에는 상소문을 추가할 수 없습니다.';

  @override
  String get invalidOpinion => '상소문을 10자 이상 입력해 주세요.';

  @override
  String get alreadySubmitted => '이 어전에는 이미 상소문을 올렸습니다.';

  @override
  String get ownerRequired => '방장만 최종 기록을 확정할 수 있습니다.';

  @override
  String get noVerdict => '평결이 내려진 뒤 기록을 확정해 주세요.';

  @override
  String get wiseName => '현명한 왕';

  @override
  String get wiseCharacter => '차분하고 공정한 왕';

  @override
  String get wisePriorities => '소수의 제약까지 살피며 감정·현실·효율을 균형 있게 판단합니다.';

  @override
  String get wiseExample => '짐이 살펴보니 이 길이 가장 합당하니라.';

  @override
  String get wiseSituations => '모든 안건';

  @override
  String get ironName => '철혈 군주';

  @override
  String get ironCharacter => '빠르고 단호한 효율의 왕';

  @override
  String get ironPriorities => '실현 가능성, 시간과 비용 절감, 실행 효율을 우선합니다.';

  @override
  String get ironExample => '군더더기 없이 이쪽으로 가라.';

  @override
  String get ironSituations => '역할 분담 · 일정';

  @override
  String get festiveName => '흥 많은 왕';

  @override
  String get festiveCharacter => '유쾌하고 활기찬 왕';

  @override
  String get festivePriorities => '필수 조건 안에서 재미와 새로움, 함께 즐길 경험을 우선합니다.';

  @override
  String get festiveExample => '오늘은 이쪽이 제격이니라!';

  @override
  String get festiveSituations => 'MT · 메뉴 · 밸런스 게임';

  @override
  String get sentimentalName => '감성 많은 왕';

  @override
  String get sentimentalCharacter => '따뜻하고 서정적인 왕';

  @override
  String get sentimentalPriorities => '효율보다 마음의 편안함, 분위기와 경험의 가치를 우선합니다.';

  @override
  String get sentimentalExample => '마음이 편히 흐르는 이 길을 택하거라.';

  @override
  String get sentimentalSituations => '분위기 · 낭만 · 경험';

  @override
  String get tyrantName => '폭군';

  @override
  String get tyrantCharacter => '투덜대지만 결단은 빠른 왕';

  @override
  String get tyrantPriorities => '번거로운 일을 줄이고 빠르게 실행할 수 있는 선택을 택합니다.';

  @override
  String get tyrantExample => '허, 고민은 여기까지다. 이쪽으로 가거라.';

  @override
  String get tyrantSituations => '가벼운 고민 · 장난스러운 결정';

  @override
  String get inviteCaseNotice => '대소문자를 구분합니다. 표시된 코드를 그대로 입력하세요.';
}
