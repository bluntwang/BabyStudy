import 'package:flutter/material.dart';

class GameItem {
  final String id;
  final String name;
  final String description;
  final String gameType;
  final String ageGroup;
  final int requiredStars;
  final IconData icon;
  final bool isUnlocked;

  GameItem({
    required this.id,
    required this.name,
    required this.description,
    required this.gameType,
    required this.ageGroup,
    required this.requiredStars,
    required this.icon,
    this.isUnlocked = false,
  });
}
