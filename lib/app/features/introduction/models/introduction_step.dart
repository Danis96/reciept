import 'package:flutter/material.dart';

enum IntroductionVisualKind {
  scan,
  ai,
  organize,
  budgets,
  export,
  privacy,
}

@immutable
class IntroductionStep {
  const IntroductionStep({
    required this.badge,
    required this.title,
    required this.description,
    required this.accentLabel,
    required this.points,
    required this.icon,
    required this.visualKind,
  });

  final String badge;
  final String title;
  final String description;
  final String accentLabel;
  final List<String> points;
  final IconData icon;
  final IntroductionVisualKind visualKind;
}
