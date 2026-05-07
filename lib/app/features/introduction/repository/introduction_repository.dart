import 'package:flutter/material.dart';

import '../../../../database/app_database.dart';
import '../models/introduction_step.dart';

class IntroductionRepository {
  const IntroductionRepository({required AppSettingsDao settingsDao})
      : _settingsDao = settingsDao;

  final AppSettingsDao _settingsDao;

  static const String _hasSeenIntroductionKey = 'has_seen_introduction';

  List<IntroductionStep> loadSteps() {
    return const [
      IntroductionStep(
        badge: 'Snap',
        title: 'Point. Snap. Done.',
        description:
            'Capture any receipt in seconds — camera or gallery. Refyn handles the rest.',
        accentLabel: 'Fast capture',
        points: [
          'Camera or gallery',
          'One-handed use',
          'Instant feedback',
        ],
        icon: Icons.document_scanner_rounded,
        visualKind: IntroductionVisualKind.scan,
      ),
      IntroductionStep(
        badge: 'Decode',
        title: 'AI reads what you bought.',
        description:
            'Merchant, items, totals, and categories surface automatically — no typing required.',
        accentLabel: 'Smart extraction',
        points: [
          'Single image scan',
          'Auto-categorization',
          'Less manual work',
        ],
        icon: Icons.auto_awesome_rounded,
        visualKind: IntroductionVisualKind.ai,
      ),
      IntroductionStep(
        badge: 'Track',
        title: 'Every receipt, organized.',
        description:
            'Browse your full history with filters, search, and sorting. No more lost paper.',
        accentLabel: 'Clean history',
        points: [
          'Search & filter',
          'Sort by date or amount',
          'Category breakdown',
        ],
        icon: Icons.layers_rounded,
        visualKind: IntroductionVisualKind.organize,
      ),
      IntroductionStep(
        badge: 'Budget',
        title: 'Set limits, stay on track.',
        description:
            'Create monthly budgets per category and watch your spending in real time.',
        accentLabel: 'Spending control',
        points: [
          'Category budgets',
          'Live progress tracking',
          'Over-budget alerts',
        ],
        icon: Icons.account_balance_wallet_rounded,
        visualKind: IntroductionVisualKind.budgets,
      ),
      IntroductionStep(
        badge: 'Export',
        title: 'Share when you need to.',
        description:
            'Export receipts as CSV, PDF, or email draft. Your data, ready to move.',
        accentLabel: 'Portable data',
        points: [
          'CSV spreadsheets',
          'PDF reports',
          'Email-ready drafts',
        ],
        icon: Icons.ios_share_rounded,
        visualKind: IntroductionVisualKind.export,
      ),
      IntroductionStep(
        badge: 'Private',
        title: 'Your data stays yours.',
        description:
            'Receipt images go to AI for extraction only. Everything is stored locally on your device — never on our servers.',
        accentLabel: 'Your privacy',
        points: [
          'Scan only, never stored remotely',
          'Local-first storage',
          'No accounts needed',
        ],
        icon: Icons.shield_rounded,
        visualKind: IntroductionVisualKind.privacy,
      ),
    ];
  }

  Future<bool> hasSeenIntroduction() async {
    final value = await _settingsDao.getSetting(_hasSeenIntroductionKey);
    return value == 'true';
  }

  Future<void> markIntroductionSeen() {
    return _settingsDao.upsertSetting(
      key: _hasSeenIntroductionKey,
      value: 'true',
    );
  }
}
