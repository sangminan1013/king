// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'king_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class KingLocalizationsEn extends KingLocalizations {
  KingLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get brand => 'KING';

  @override
  String get slogan => 'A Court of Wisdom';

  @override
  String get royalCourt => 'Royal Court';

  @override
  String get courtSettings => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get languageDescription =>
      'Choose the language used throughout the app.';

  @override
  String get english => 'English';

  @override
  String get korean => '한국어 (Korean)';

  @override
  String get languageSaveError =>
      'Your language preference could not be saved. Please try again.';

  @override
  String get home => 'Home';

  @override
  String get back => 'Back';

  @override
  String get signOut => 'Sign Out';

  @override
  String get guestHeading => 'Enter the court anonymously';

  @override
  String get guestDescription =>
      'A secure guest session starts without signing up. Your identity stays private when you submit a petition.';

  @override
  String get guestWarning =>
      'Your guest session stays on this device. Signing out or clearing app data removes access to that identity.';

  @override
  String get guestLoading => 'Opening your guest session…';

  @override
  String get guestEnter => 'Enter as a Guest';

  @override
  String get guestError =>
      'Could not start a guest session. Check your connection and try again.';

  @override
  String get guestDisabled => 'Guest sign-in is currently unavailable.';

  @override
  String get guestRateLimited =>
      'Too many sign-in attempts. Please try again later.';

  @override
  String get convene => 'Convene a Court';

  @override
  String get conveneDescription => 'Set the agenda and invite your group.';

  @override
  String get enterCourt => 'Enter the Royal Court';

  @override
  String get enterDescription =>
      'Join by invitation and share your opinion anonymously.';

  @override
  String get history => 'Court Records';

  @override
  String get historyDescription =>
      'Reopen your courts and revisit past decisions.';

  @override
  String get createHeading => 'Set the agenda';

  @override
  String get groupName => 'Court name';

  @override
  String get topic => 'Decision topic';

  @override
  String get demoGroup => 'Friday Expedition';

  @override
  String get demoTopic => 'Where should we hold this quarter’s team workshop?';

  @override
  String get members => 'Court Members';

  @override
  String get membersDescription =>
      'Deliberation begins once every member has submitted a petition.';

  @override
  String memberCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count members',
      one: '1 member',
    );
    return '$_temp0';
  }

  @override
  String get fewerMembers => 'Remove one member';

  @override
  String get moreMembers => 'Add one member';

  @override
  String get chooseKing => 'Choose Your King';

  @override
  String get chooseKingDescription =>
      'Each king weighs different priorities and speaks in a distinct voice.';

  @override
  String kingSituation(String situations) {
    return 'Best for: $situations';
  }

  @override
  String kingExample(String example) {
    return '“$example”';
  }

  @override
  String get petitionPrivacy =>
      'Individual petitions stay private. Deliberation begins once everyone has submitted.';

  @override
  String get yourPetition => 'Your petition';

  @override
  String get creating => 'Convening the court…';

  @override
  String get joinHeading => 'Enter your invitation code';

  @override
  String get joinDescription =>
      'Use the eight-character code shared by the host.';

  @override
  String get inviteCode => 'Invitation code';

  @override
  String get inviteHint => 'e.g. KING-ABC';

  @override
  String get joining => 'Checking your invitation code…';

  @override
  String get joinPrivacy => 'Your name and account details are private.';

  @override
  String get copy => 'Copy';

  @override
  String get copied => 'Copied';

  @override
  String get receiving => 'Accepting petitions';

  @override
  String get todayTopic => 'Today’s agenda';

  @override
  String submittedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count members have submitted petitions',
      one: '1 member has submitted a petition',
    );
    return '$_temp0';
  }

  @override
  String get submitPetition => 'Submit a Petition';

  @override
  String get petitionHeading => 'Tell the court what matters to you';

  @override
  String get petitionHint =>
      'Share what matters, what to avoid, and what outcome you would like.';

  @override
  String get petitionLocked =>
      'Once submitted, your petition is anonymous and cannot be edited.';

  @override
  String get sealing => 'Sealing your petition…';

  @override
  String get movingToWaiting => 'Opening the deliberation screen…';

  @override
  String get deliberation => 'Royal Deliberation';

  @override
  String get deliberating => 'The King Is Deliberating';

  @override
  String get sealed => 'Your petition is sealed';

  @override
  String submissionStatus(int submitted, int total) {
    return 'Petitions submitted: $submitted of $total';
  }

  @override
  String get allSubmitted =>
      'Everyone has submitted. The verdict will appear here when it is ready.';

  @override
  String waitingMembers(int count) {
    return 'Waiting for all $count members to submit their petitions.';
  }

  @override
  String get checking => 'Checking…';

  @override
  String get checkStatus => 'Check Submission Status';

  @override
  String get checkHelp =>
      'Check the latest submission count. Once everyone has submitted, the king can deliver a verdict.';

  @override
  String get verdict => 'Royal Verdict';

  @override
  String get verdictUnavailable =>
      'The verdict is pending. Go back to check the submission status.';

  @override
  String get verdictReasons => 'Reasons for the verdict';

  @override
  String fitScore(int score) {
    return 'Fit score $score%';
  }

  @override
  String get newDecision => 'Start Another Decision';

  @override
  String get viewRecord => 'View Final Record';

  @override
  String get finalizing => 'Confirming…';

  @override
  String get finalize => 'Confirm Decision';

  @override
  String get waitingHost => 'Waiting for the host to confirm the decision.';

  @override
  String get checkFinalization => 'Check Confirmation';

  @override
  String get reviewVerdict =>
      'The verdict is an AI recommendation based on the group’s petitions. Review important decisions together.';

  @override
  String get decree => 'Royal Decree';

  @override
  String get recorded => 'Decision recorded';

  @override
  String get confirmedDecision => 'This decision is final.';

  @override
  String finalizedAt(String date) {
    return 'Confirmed: $date';
  }

  @override
  String createdAt(String date) {
    return 'Created: $date';
  }

  @override
  String get myCourts => 'My Courts';

  @override
  String get refreshCourts => 'Refresh court records';

  @override
  String get reopenCourts =>
      'Reopen courts you have joined without an invitation code.';

  @override
  String get noCourts =>
      'You have not joined a court yet. Convene one or join by invitation.';

  @override
  String get reloadCourts => 'Reload Records';

  @override
  String get loading => 'Loading…';

  @override
  String get moreCourts => 'Show Older Courts';

  @override
  String get historyPrivacy =>
      'These records belong to your current guest session.';

  @override
  String get archivedStatus => 'Closed · View record';

  @override
  String get activeStatus => 'In progress · Reenter';

  @override
  String get host => 'Host';

  @override
  String get sessionExpired =>
      'Your guest session has expired. Enter the court again.';

  @override
  String get historyError => 'Could not load court records. Please try again.';

  @override
  String get historyNetwork =>
      'Could not connect to court records. Check your connection.';

  @override
  String get serverError => 'The request failed. Please try again.';

  @override
  String get invalidResponse => 'Could not read the server response.';

  @override
  String get verdictMissing => 'Could not find the saved verdict.';

  @override
  String get verdictWait =>
      'Wait until every court member has submitted a petition.';

  @override
  String get verdictPending =>
      'The verdict is still pending. Please check again.';

  @override
  String get verdictError =>
      'Could not obtain a verdict. Please try again shortly.';

  @override
  String get finalizeUnconfirmed =>
      'Could not verify the decision was confirmed. Please try again.';

  @override
  String get finalizeError =>
      'Could not confirm the decision. Check your connection and try again.';

  @override
  String get networkError =>
      'Could not reach the server. Check your connection.';

  @override
  String get openRoomError => 'Could not open the court.';

  @override
  String get notMember => 'Only members of this court can enter.';

  @override
  String get invalidKing => 'Choose a king again.';

  @override
  String get invalidRoom =>
      'Check the court name, agenda, and number of members.';

  @override
  String get invalidCode => 'Enter an invitation code.';

  @override
  String get roomNotFound => 'The court could not be found.';

  @override
  String get roomClosed => 'This court is already closed.';

  @override
  String get roomFull => 'This court has reached its member limit.';

  @override
  String get verdictExists =>
      'The king has already delivered a verdict for this court.';

  @override
  String get invalidOpinion => 'Enter at least 10 characters in your petition.';

  @override
  String get alreadySubmitted =>
      'You already submitted a petition to this court.';

  @override
  String get ownerRequired => 'Only the host can confirm the final record.';

  @override
  String get noVerdict => 'Wait for the verdict before confirming the record.';

  @override
  String get wiseName => 'The Wise King';

  @override
  String get wiseCharacter => 'Calm and impartial';

  @override
  String get wisePriorities =>
      'Balances feelings, practical needs, and efficiency while considering minority concerns.';

  @override
  String get wiseExample =>
      'Having heard the court, I find this the soundest course.';

  @override
  String get wiseSituations => 'Any agenda';

  @override
  String get ironName => 'The Iron King';

  @override
  String get ironCharacter => 'Decisive and efficient';

  @override
  String get ironPriorities =>
      'Prioritizes what is feasible, saves time and money, and gets the work done.';

  @override
  String get ironExample => 'The way forward is clear. Let us proceed.';

  @override
  String get ironSituations => 'Dividing tasks or scheduling';

  @override
  String get festiveName => 'The Festive King';

  @override
  String get festiveCharacter => 'Playful and lively';

  @override
  String get festivePriorities =>
      'Makes room for novelty and shared fun while respecting essential constraints.';

  @override
  String get festiveExample => 'This is the choice for today!';

  @override
  String get festiveSituations => 'Retreats, menus, or games';

  @override
  String get sentimentalName => 'The Sentimental King';

  @override
  String get sentimentalCharacter => 'Warm and reflective';

  @override
  String get sentimentalPriorities =>
      'Values comfort, atmosphere, and shared memories ahead of efficiency.';

  @override
  String get sentimentalExample =>
      'Let us take the path that puts our hearts at ease.';

  @override
  String get sentimentalSituations => 'Atmosphere, romance, or experiences';

  @override
  String get tyrantName => 'The Tyrant King';

  @override
  String get tyrantCharacter => 'Grumbles, then decides quickly';

  @override
  String get tyrantPriorities =>
      'Looks for the simplest option the court can act on quickly.';

  @override
  String get tyrantExample => 'Enough fretting. This is what we shall do.';

  @override
  String get tyrantSituations => 'Low-stakes or playful decisions';
}
