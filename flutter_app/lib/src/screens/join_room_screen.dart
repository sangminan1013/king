import "package:flutter/material.dart";

import "../../l10n/strings.dart";

import "../controller/king_controller.dart";
import "../theme/king_theme.dart";
import "../widgets/royal_widgets.dart";
import "room_screen.dart";

class JoinRoomScreen extends StatefulWidget {
  const JoinRoomScreen({required this.controller, super.key});

  final KingController controller;

  @override
  State<JoinRoomScreen> createState() => _JoinRoomScreenState();
}

class _JoinRoomScreenState extends State<JoinRoomScreen> {
  String code = "";

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(refresh);
  }

  void refresh() => setState(() {});

  @override
  void dispose() {
    widget.controller.removeListener(refresh);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.strings;
    return RoyalScaffold(
      title: l.enterCourt,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(24, 65, 24, 40),
        children: [
          const RoyalCrest(),
          const SizedBox(height: 10),
          Text(
            l.joinHeading,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 6),
          Text(
            l.joinDescription,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 35),
          Text(l.inviteCode, style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 8),
          TextField(
            autofocus: true,
            maxLength: 12,
            textCapitalization: TextCapitalization.none,
            autocorrect: false,
            enableSuggestions: false,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: KingColors.burgundyDark,
              fontSize: 22,
              letterSpacing: 2,
              fontWeight: FontWeight.w700,
            ),
            decoration: InputDecoration(
              hintText: l.inviteHint,
              helperText: l.inviteCaseNotice,
              helperMaxLines: 3,
              counterText: "",
              hintStyle: const TextStyle(
                color: KingColors.muted,
                fontWeight: FontWeight.w400,
              ),
            ),
            onChanged: (value) => setState(() => code = value),
          ),
          const SizedBox(height: 18),
          RoyalButton(
            label: widget.controller.isRoomBusy ? l.joining : l.enterCourt,
            onPressed: code.trim().length >= 6 && !widget.controller.isRoomBusy
                ? () async {
                    final joined = await widget.controller.joinRoom(code);
                    if (!context.mounted || !joined) return;
                    await Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) =>
                            RoomScreen(controller: widget.controller),
                      ),
                    );
                  }
                : null,
          ),
          if (widget.controller.roomError != null) ...[
            const SizedBox(height: 12),
            Text(
              l.errorMessage(widget.controller.roomError!),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: KingColors.burgundy,
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ],
          const SizedBox(height: 24),
          PrivacyNote(l.joinPrivacy),
        ],
      ),
    );
  }
}
