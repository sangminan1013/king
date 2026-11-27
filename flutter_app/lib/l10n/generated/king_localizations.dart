import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'king_localizations_en.dart';
import 'king_localizations_ko.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of KingLocalizations
/// returned by `KingLocalizations.of(context)`.
///
/// Applications need to include `KingLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/king_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: KingLocalizations.localizationsDelegates,
///   supportedLocales: KingLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the KingLocalizations.supportedLocales
/// property.
abstract class KingLocalizations {
  KingLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static KingLocalizations of(BuildContext context) {
    return Localizations.of<KingLocalizations>(context, KingLocalizations)!;
  }

  static const LocalizationsDelegate<KingLocalizations> delegate =
      _KingLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ko')
  ];

  /// No description provided for @brand.
  ///
  /// In en, this message translates to:
  /// **'KING'**
  String get brand;

  /// No description provided for @slogan.
  ///
  /// In en, this message translates to:
  /// **'A Court of Wisdom'**
  String get slogan;

  /// No description provided for @royalCourt.
  ///
  /// In en, this message translates to:
  /// **'Royal Court'**
  String get royalCourt;

  /// No description provided for @courtSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get courtSettings;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @languageDescription.
  ///
  /// In en, this message translates to:
  /// **'Choose the language used throughout the app.'**
  String get languageDescription;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @korean.
  ///
  /// In en, this message translates to:
  /// **'한국어 (Korean)'**
  String get korean;

  /// No description provided for @languageSaveError.
  ///
  /// In en, this message translates to:
  /// **'Your language preference could not be saved. Please try again.'**
  String get languageSaveError;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signOut;

  /// No description provided for @guestHeading.
  ///
  /// In en, this message translates to:
  /// **'Enter the court anonymously'**
  String get guestHeading;

  /// No description provided for @guestDescription.
  ///
  /// In en, this message translates to:
  /// **'A secure guest session starts without signing up. Your identity stays private when you submit a petition.'**
  String get guestDescription;

  /// No description provided for @guestWarning.
  ///
  /// In en, this message translates to:
  /// **'Your guest session stays on this device. Signing out or clearing app data removes access to that identity.'**
  String get guestWarning;

  /// No description provided for @guestLoading.
  ///
  /// In en, this message translates to:
  /// **'Opening your guest session…'**
  String get guestLoading;

  /// No description provided for @guestEnter.
  ///
  /// In en, this message translates to:
  /// **'Enter as a Guest'**
  String get guestEnter;

  /// No description provided for @guestError.
  ///
  /// In en, this message translates to:
  /// **'Could not start a guest session. Check your connection and try again.'**
  String get guestError;

  /// No description provided for @guestDisabled.
  ///
  /// In en, this message translates to:
  /// **'Guest sign-in is currently unavailable.'**
  String get guestDisabled;

  /// No description provided for @guestRateLimited.
  ///
  /// In en, this message translates to:
  /// **'Too many sign-in attempts. Please try again later.'**
  String get guestRateLimited;

  /// No description provided for @convene.
  ///
  /// In en, this message translates to:
  /// **'Convene a Court'**
  String get convene;

  /// No description provided for @conveneDescription.
  ///
  /// In en, this message translates to:
  /// **'Set the agenda and invite your group.'**
  String get conveneDescription;

  /// No description provided for @enterCourt.
  ///
  /// In en, this message translates to:
  /// **'Enter the Royal Court'**
  String get enterCourt;

  /// No description provided for @enterDescription.
  ///
  /// In en, this message translates to:
  /// **'Join by invitation and share your opinion anonymously.'**
  String get enterDescription;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'Court Records'**
  String get history;

  /// No description provided for @historyDescription.
  ///
  /// In en, this message translates to:
  /// **'Reopen your courts and revisit past decisions.'**
  String get historyDescription;

  /// No description provided for @createHeading.
  ///
  /// In en, this message translates to:
  /// **'Set the agenda'**
  String get createHeading;

  /// No description provided for @groupName.
  ///
  /// In en, this message translates to:
  /// **'Court name'**
  String get groupName;

  /// No description provided for @topic.
  ///
  /// In en, this message translates to:
  /// **'Decision topic'**
  String get topic;

  /// No description provided for @demoGroup.
  ///
  /// In en, this message translates to:
  /// **'Friday Expedition'**
  String get demoGroup;

  /// No description provided for @demoTopic.
  ///
  /// In en, this message translates to:
  /// **'Where should we hold this quarter’s team workshop?'**
  String get demoTopic;

  /// No description provided for @members.
  ///
  /// In en, this message translates to:
  /// **'Court Members'**
  String get members;

  /// No description provided for @membersDescription.
  ///
  /// In en, this message translates to:
  /// **'Deliberation begins once every member has submitted a petition.'**
  String get membersDescription;

  /// No description provided for @memberCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{1 member} other{{count} members}}'**
  String memberCount(int count);

  /// No description provided for @fewerMembers.
  ///
  /// In en, this message translates to:
  /// **'Remove one member'**
  String get fewerMembers;

  /// No description provided for @moreMembers.
  ///
  /// In en, this message translates to:
  /// **'Add one member'**
  String get moreMembers;

  /// No description provided for @chooseKing.
  ///
  /// In en, this message translates to:
  /// **'Choose Your King'**
  String get chooseKing;

  /// No description provided for @chooseKingDescription.
  ///
  /// In en, this message translates to:
  /// **'Each king weighs different priorities and speaks in a distinct voice.'**
  String get chooseKingDescription;

  /// No description provided for @kingSituation.
  ///
  /// In en, this message translates to:
  /// **'Best for: {situations}'**
  String kingSituation(String situations);

  /// No description provided for @kingExample.
  ///
  /// In en, this message translates to:
  /// **'“{example}”'**
  String kingExample(String example);

  /// No description provided for @petitionPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Individual petitions stay private. Deliberation begins once everyone has submitted.'**
  String get petitionPrivacy;

  /// No description provided for @yourPetition.
  ///
  /// In en, this message translates to:
  /// **'Your petition'**
  String get yourPetition;

  /// No description provided for @creating.
  ///
  /// In en, this message translates to:
  /// **'Convening the court…'**
  String get creating;

  /// No description provided for @joinHeading.
  ///
  /// In en, this message translates to:
  /// **'Enter your invitation code'**
  String get joinHeading;

  /// No description provided for @joinDescription.
  ///
  /// In en, this message translates to:
  /// **'Use the eight-character code shared by the host.'**
  String get joinDescription;

  /// No description provided for @inviteCode.
  ///
  /// In en, this message translates to:
  /// **'Invitation code'**
  String get inviteCode;

  /// No description provided for @inviteHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. KING-ABC'**
  String get inviteHint;

  /// No description provided for @joining.
  ///
  /// In en, this message translates to:
  /// **'Checking your invitation code…'**
  String get joining;

  /// No description provided for @joinPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Your name and account details are private.'**
  String get joinPrivacy;

  /// No description provided for @copy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copy;

  /// No description provided for @copied.
  ///
  /// In en, this message translates to:
  /// **'Copied'**
  String get copied;

  /// No description provided for @receiving.
  ///
  /// In en, this message translates to:
  /// **'Accepting petitions'**
  String get receiving;

  /// No description provided for @todayTopic.
  ///
  /// In en, this message translates to:
  /// **'Today’s agenda'**
  String get todayTopic;

  /// No description provided for @submittedCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{1 member has submitted a petition} other{{count} members have submitted petitions}}'**
  String submittedCount(int count);

  /// No description provided for @submitPetition.
  ///
  /// In en, this message translates to:
  /// **'Submit a Petition'**
  String get submitPetition;

  /// No description provided for @petitionHeading.
  ///
  /// In en, this message translates to:
  /// **'Tell the court what matters to you'**
  String get petitionHeading;

  /// No description provided for @petitionHint.
  ///
  /// In en, this message translates to:
  /// **'Share what matters, what to avoid, and what outcome you would like.'**
  String get petitionHint;

  /// No description provided for @petitionLocked.
  ///
  /// In en, this message translates to:
  /// **'Once submitted, your petition is anonymous and cannot be edited.'**
  String get petitionLocked;

  /// No description provided for @sealing.
  ///
  /// In en, this message translates to:
  /// **'Sealing your petition…'**
  String get sealing;

  /// No description provided for @movingToWaiting.
  ///
  /// In en, this message translates to:
  /// **'Opening the deliberation screen…'**
  String get movingToWaiting;

  /// No description provided for @deliberation.
  ///
  /// In en, this message translates to:
  /// **'Royal Deliberation'**
  String get deliberation;

  /// No description provided for @deliberating.
  ///
  /// In en, this message translates to:
  /// **'The King Is Deliberating'**
  String get deliberating;

  /// No description provided for @sealed.
  ///
  /// In en, this message translates to:
  /// **'Your petition is sealed'**
  String get sealed;

  /// No description provided for @submissionStatus.
  ///
  /// In en, this message translates to:
  /// **'Petitions submitted: {submitted} of {total}'**
  String submissionStatus(int submitted, int total);

  /// No description provided for @allSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Everyone has submitted. The verdict will appear here when it is ready.'**
  String get allSubmitted;

  /// No description provided for @waitingMembers.
  ///
  /// In en, this message translates to:
  /// **'Waiting for all {count} members to submit their petitions.'**
  String waitingMembers(int count);

  /// No description provided for @checking.
  ///
  /// In en, this message translates to:
  /// **'Checking…'**
  String get checking;

  /// No description provided for @checkStatus.
  ///
  /// In en, this message translates to:
  /// **'Check Submission Status'**
  String get checkStatus;

  /// No description provided for @checkHelp.
  ///
  /// In en, this message translates to:
  /// **'Check the latest submission count. Once everyone has submitted, the king can deliver a verdict.'**
  String get checkHelp;

  /// No description provided for @verdict.
  ///
  /// In en, this message translates to:
  /// **'Royal Verdict'**
  String get verdict;

  /// No description provided for @verdictUnavailable.
  ///
  /// In en, this message translates to:
  /// **'The verdict is pending. Go back to check the submission status.'**
  String get verdictUnavailable;

  /// No description provided for @verdictReasons.
  ///
  /// In en, this message translates to:
  /// **'Reasons for the verdict'**
  String get verdictReasons;

  /// No description provided for @fitScore.
  ///
  /// In en, this message translates to:
  /// **'Fit score {score}%'**
  String fitScore(int score);

  /// No description provided for @newDecision.
  ///
  /// In en, this message translates to:
  /// **'Start Another Decision'**
  String get newDecision;

  /// No description provided for @viewRecord.
  ///
  /// In en, this message translates to:
  /// **'View Final Record'**
  String get viewRecord;

  /// No description provided for @finalizing.
  ///
  /// In en, this message translates to:
  /// **'Confirming…'**
  String get finalizing;

  /// No description provided for @finalize.
  ///
  /// In en, this message translates to:
  /// **'Confirm Decision'**
  String get finalize;

  /// No description provided for @waitingHost.
  ///
  /// In en, this message translates to:
  /// **'Waiting for the host to confirm the decision.'**
  String get waitingHost;

  /// No description provided for @checkFinalization.
  ///
  /// In en, this message translates to:
  /// **'Check Confirmation'**
  String get checkFinalization;

  /// No description provided for @reviewVerdict.
  ///
  /// In en, this message translates to:
  /// **'The verdict is an AI recommendation based on the group’s petitions. Review important decisions together.'**
  String get reviewVerdict;

  /// No description provided for @decree.
  ///
  /// In en, this message translates to:
  /// **'Royal Decree'**
  String get decree;

  /// No description provided for @recorded.
  ///
  /// In en, this message translates to:
  /// **'Decision recorded'**
  String get recorded;

  /// No description provided for @confirmedDecision.
  ///
  /// In en, this message translates to:
  /// **'This decision is final.'**
  String get confirmedDecision;

  /// No description provided for @finalizedAt.
  ///
  /// In en, this message translates to:
  /// **'Confirmed: {date}'**
  String finalizedAt(String date);

  /// No description provided for @createdAt.
  ///
  /// In en, this message translates to:
  /// **'Created: {date}'**
  String createdAt(String date);

  /// No description provided for @myCourts.
  ///
  /// In en, this message translates to:
  /// **'My Courts'**
  String get myCourts;

  /// No description provided for @refreshCourts.
  ///
  /// In en, this message translates to:
  /// **'Refresh court records'**
  String get refreshCourts;

  /// No description provided for @reopenCourts.
  ///
  /// In en, this message translates to:
  /// **'Reopen courts you have joined without an invitation code.'**
  String get reopenCourts;

  /// No description provided for @noCourts.
  ///
  /// In en, this message translates to:
  /// **'You have not joined a court yet. Convene one or join by invitation.'**
  String get noCourts;

  /// No description provided for @reloadCourts.
  ///
  /// In en, this message translates to:
  /// **'Reload Records'**
  String get reloadCourts;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading…'**
  String get loading;

  /// No description provided for @moreCourts.
  ///
  /// In en, this message translates to:
  /// **'Show Older Courts'**
  String get moreCourts;

  /// No description provided for @historyPrivacy.
  ///
  /// In en, this message translates to:
  /// **'These records belong to your current guest session.'**
  String get historyPrivacy;

  /// No description provided for @archivedStatus.
  ///
  /// In en, this message translates to:
  /// **'Closed · View record'**
  String get archivedStatus;

  /// No description provided for @activeStatus.
  ///
  /// In en, this message translates to:
  /// **'In progress · Reenter'**
  String get activeStatus;

  /// No description provided for @host.
  ///
  /// In en, this message translates to:
  /// **'Host'**
  String get host;

  /// No description provided for @sessionExpired.
  ///
  /// In en, this message translates to:
  /// **'Your guest session has expired. Enter the court again.'**
  String get sessionExpired;

  /// No description provided for @historyError.
  ///
  /// In en, this message translates to:
  /// **'Could not load court records. Please try again.'**
  String get historyError;

  /// No description provided for @historyNetwork.
  ///
  /// In en, this message translates to:
  /// **'Could not connect to court records. Check your connection.'**
  String get historyNetwork;

  /// No description provided for @serverError.
  ///
  /// In en, this message translates to:
  /// **'The request failed. Please try again.'**
  String get serverError;

  /// No description provided for @invalidResponse.
  ///
  /// In en, this message translates to:
  /// **'Could not read the server response.'**
  String get invalidResponse;

  /// No description provided for @verdictMissing.
  ///
  /// In en, this message translates to:
  /// **'Could not find the saved verdict.'**
  String get verdictMissing;

  /// No description provided for @verdictWait.
  ///
  /// In en, this message translates to:
  /// **'Wait until every court member has submitted a petition.'**
  String get verdictWait;

  /// No description provided for @verdictPending.
  ///
  /// In en, this message translates to:
  /// **'The verdict is still pending. Please check again.'**
  String get verdictPending;

  /// No description provided for @verdictError.
  ///
  /// In en, this message translates to:
  /// **'Could not obtain a verdict. Please try again shortly.'**
  String get verdictError;

  /// No description provided for @finalizeUnconfirmed.
  ///
  /// In en, this message translates to:
  /// **'Could not verify the decision was confirmed. Please try again.'**
  String get finalizeUnconfirmed;

  /// No description provided for @finalizeError.
  ///
  /// In en, this message translates to:
  /// **'Could not confirm the decision. Check your connection and try again.'**
  String get finalizeError;

  /// No description provided for @networkError.
  ///
  /// In en, this message translates to:
  /// **'Could not reach the server. Check your connection.'**
  String get networkError;

  /// No description provided for @openRoomError.
  ///
  /// In en, this message translates to:
  /// **'Could not open the court.'**
  String get openRoomError;

  /// No description provided for @notMember.
  ///
  /// In en, this message translates to:
  /// **'Only members of this court can enter.'**
  String get notMember;

  /// No description provided for @invalidKing.
  ///
  /// In en, this message translates to:
  /// **'Choose a king again.'**
  String get invalidKing;

  /// No description provided for @invalidRoom.
  ///
  /// In en, this message translates to:
  /// **'Check the court name, agenda, and number of members.'**
  String get invalidRoom;

  /// No description provided for @invalidCode.
  ///
  /// In en, this message translates to:
  /// **'Enter an invitation code.'**
  String get invalidCode;

  /// No description provided for @roomNotFound.
  ///
  /// In en, this message translates to:
  /// **'The court could not be found.'**
  String get roomNotFound;

  /// No description provided for @roomClosed.
  ///
  /// In en, this message translates to:
  /// **'This court is already closed.'**
  String get roomClosed;

  /// No description provided for @roomFull.
  ///
  /// In en, this message translates to:
  /// **'This court has reached its member limit.'**
  String get roomFull;

  /// No description provided for @verdictExists.
  ///
  /// In en, this message translates to:
  /// **'The king has already delivered a verdict for this court.'**
  String get verdictExists;

  /// No description provided for @invalidOpinion.
  ///
  /// In en, this message translates to:
  /// **'Enter at least 10 characters in your petition.'**
  String get invalidOpinion;

  /// No description provided for @alreadySubmitted.
  ///
  /// In en, this message translates to:
  /// **'You already submitted a petition to this court.'**
  String get alreadySubmitted;

  /// No description provided for @ownerRequired.
  ///
  /// In en, this message translates to:
  /// **'Only the host can confirm the final record.'**
  String get ownerRequired;

  /// No description provided for @noVerdict.
  ///
  /// In en, this message translates to:
  /// **'Wait for the verdict before confirming the record.'**
  String get noVerdict;

  /// No description provided for @wiseName.
  ///
  /// In en, this message translates to:
  /// **'The Wise King'**
  String get wiseName;

  /// No description provided for @wiseCharacter.
  ///
  /// In en, this message translates to:
  /// **'Calm and impartial'**
  String get wiseCharacter;

  /// No description provided for @wisePriorities.
  ///
  /// In en, this message translates to:
  /// **'Balances feelings, practical needs, and efficiency while considering minority concerns.'**
  String get wisePriorities;

  /// No description provided for @wiseExample.
  ///
  /// In en, this message translates to:
  /// **'Having heard the court, I find this the soundest course.'**
  String get wiseExample;

  /// No description provided for @wiseSituations.
  ///
  /// In en, this message translates to:
  /// **'Any agenda'**
  String get wiseSituations;

  /// No description provided for @ironName.
  ///
  /// In en, this message translates to:
  /// **'The Iron King'**
  String get ironName;

  /// No description provided for @ironCharacter.
  ///
  /// In en, this message translates to:
  /// **'Decisive and efficient'**
  String get ironCharacter;

  /// No description provided for @ironPriorities.
  ///
  /// In en, this message translates to:
  /// **'Prioritizes what is feasible, saves time and money, and gets the work done.'**
  String get ironPriorities;

  /// No description provided for @ironExample.
  ///
  /// In en, this message translates to:
  /// **'The way forward is clear. Let us proceed.'**
  String get ironExample;

  /// No description provided for @ironSituations.
  ///
  /// In en, this message translates to:
  /// **'Dividing tasks or scheduling'**
  String get ironSituations;

  /// No description provided for @festiveName.
  ///
  /// In en, this message translates to:
  /// **'The Festive King'**
  String get festiveName;

  /// No description provided for @festiveCharacter.
  ///
  /// In en, this message translates to:
  /// **'Playful and lively'**
  String get festiveCharacter;

  /// No description provided for @festivePriorities.
  ///
  /// In en, this message translates to:
  /// **'Makes room for novelty and shared fun while respecting essential constraints.'**
  String get festivePriorities;

  /// No description provided for @festiveExample.
  ///
  /// In en, this message translates to:
  /// **'This is the choice for today!'**
  String get festiveExample;

  /// No description provided for @festiveSituations.
  ///
  /// In en, this message translates to:
  /// **'Retreats, menus, or games'**
  String get festiveSituations;

  /// No description provided for @sentimentalName.
  ///
  /// In en, this message translates to:
  /// **'The Sentimental King'**
  String get sentimentalName;

  /// No description provided for @sentimentalCharacter.
  ///
  /// In en, this message translates to:
  /// **'Warm and reflective'**
  String get sentimentalCharacter;

  /// No description provided for @sentimentalPriorities.
  ///
  /// In en, this message translates to:
  /// **'Values comfort, atmosphere, and shared memories ahead of efficiency.'**
  String get sentimentalPriorities;

  /// No description provided for @sentimentalExample.
  ///
  /// In en, this message translates to:
  /// **'Let us take the path that puts our hearts at ease.'**
  String get sentimentalExample;

  /// No description provided for @sentimentalSituations.
  ///
  /// In en, this message translates to:
  /// **'Atmosphere, romance, or experiences'**
  String get sentimentalSituations;

  /// No description provided for @tyrantName.
  ///
  /// In en, this message translates to:
  /// **'The Tyrant King'**
  String get tyrantName;

  /// No description provided for @tyrantCharacter.
  ///
  /// In en, this message translates to:
  /// **'Grumbles, then decides quickly'**
  String get tyrantCharacter;

  /// No description provided for @tyrantPriorities.
  ///
  /// In en, this message translates to:
  /// **'Looks for the simplest option the court can act on quickly.'**
  String get tyrantPriorities;

  /// No description provided for @tyrantExample.
  ///
  /// In en, this message translates to:
  /// **'Enough fretting. This is what we shall do.'**
  String get tyrantExample;

  /// No description provided for @tyrantSituations.
  ///
  /// In en, this message translates to:
  /// **'Low-stakes or playful decisions'**
  String get tyrantSituations;
}

class _KingLocalizationsDelegate
    extends LocalizationsDelegate<KingLocalizations> {
  const _KingLocalizationsDelegate();

  @override
  Future<KingLocalizations> load(Locale locale) {
    return SynchronousFuture<KingLocalizations>(
        lookupKingLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ko'].contains(locale.languageCode);

  @override
  bool shouldReload(_KingLocalizationsDelegate old) => false;
}

KingLocalizations lookupKingLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return KingLocalizationsEn();
    case 'ko':
      return KingLocalizationsKo();
  }

  throw FlutterError(
      'KingLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
