import "package:flutter/widgets.dart";

import "../src/models/king_personality.dart";
import "generated/king_localizations.dart";

extension LocalizedContext on BuildContext {
  KingLocalizations get strings => KingLocalizations.of(this);
}

typedef KingProfile = ({
  String name,
  String character,
  String priorities,
  String example,
  String situations,
});

extension CourtStrings on KingLocalizations {
  KingProfile profile(KingPersonality king) => switch (king) {
        KingPersonality.wise => (
            name: wiseName,
            character: wiseCharacter,
            priorities: wisePriorities,
            example: wiseExample,
            situations: wiseSituations,
          ),
        KingPersonality.iron => (
            name: ironName,
            character: ironCharacter,
            priorities: ironPriorities,
            example: ironExample,
            situations: ironSituations,
          ),
        KingPersonality.festive => (
            name: festiveName,
            character: festiveCharacter,
            priorities: festivePriorities,
            example: festiveExample,
            situations: festiveSituations,
          ),
        KingPersonality.sentimental => (
            name: sentimentalName,
            character: sentimentalCharacter,
            priorities: sentimentalPriorities,
            example: sentimentalExample,
            situations: sentimentalSituations,
          ),
        KingPersonality.tyrant => (
            name: tyrantName,
            character: tyrantCharacter,
            priorities: tyrantPriorities,
            example: tyrantExample,
            situations: tyrantSituations,
          ),
      };

  String errorMessage(String value) => switch (value) {
        "ui:sessionExpired" => sessionExpired,
        "ui:historyError" => historyError,
        "ui:historyNetwork" => historyNetwork,
        "ui:serverError" => serverError,
        "ui:invalidResponse" => invalidResponse,
        "ui:verdictMissing" => verdictMissing,
        "ui:verdictWait" => verdictWait,
        "ui:verdictPending" => verdictPending,
        "ui:verdictError" => verdictError,
        "ui:finalizeUnconfirmed" => finalizeUnconfirmed,
        "ui:finalizeError" => finalizeError,
        "ui:networkError" => networkError,
        "ui:guestDisabled" => guestDisabled,
        "ui:guestRateLimited" => guestRateLimited,
        "ui:guestError" => guestError,
        "server:UNAUTHENTICATED" => sessionExpired,
        "server:NOT_A_MEMBER" => notMember,
        "server:INVALID_KING" => invalidKing,
        "server:INVALID_ROOM" => invalidRoom,
        "server:INVALID_CODE" => invalidCode,
        "server:ROOM_NOT_FOUND" => roomNotFound,
        "server:ROOM_CLOSED" => roomClosed,
        "server:ROOM_FULL" => roomFull,
        "server:VERDICT_EXISTS" => verdictExists,
        "server:INVALID_OPINION" => invalidOpinion,
        "server:ALREADY_SUBMITTED" => alreadySubmitted,
        "server:WAITING_FOR_OPINIONS" => verdictWait,
        "server:OWNER_REQUIRED" => ownerRequired,
        "server:NO_VERDICT" => noVerdict,
        "server:VERDICT_FAILED" => verdictError,
        "server:SERVER_ERROR" => serverError,
        String code when code.startsWith("server:") => serverError,
        _ => value,
      };
}
