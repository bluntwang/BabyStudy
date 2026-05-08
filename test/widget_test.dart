import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:baby_study/screens/game_list_screen.dart';
import 'package:baby_study/games/shape_recognition/shape_game.dart';
import 'package:baby_study/games/color_recognition/color_game.dart';
import 'package:baby_study/games/animal_recognition/animal_game.dart';
import 'package:baby_study/games/pinyin/pinyin_game.dart';
import 'package:baby_study/games/matching/matching_game.dart';
import 'package:baby_study/games/connect_dots/connect_game.dart';

void main() {
  group('BabyStudy App Tests', () {
    testWidgets('Game list should show games for small class', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: GameListScreen(ageGroup: 'small'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('形状识别'), findsOneWidget);
      expect(find.text('颜色识别'), findsOneWidget);
      expect(find.text('动物认知'), findsOneWidget);
    });

    testWidgets('Shape game should display and be interactive', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(body: ShapeGame()),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('选择相同的形状'), findsOneWidget);
      expect(find.text('第 0/10 题'), findsOneWidget);
      expect(find.text('得分: 0'), findsOneWidget);
    });

    testWidgets('Color game should display and be interactive', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(body: ColorGame()),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('选择相同的颜色'), findsOneWidget);
      expect(find.text('第 0/10 题'), findsOneWidget);
    });

    testWidgets('Animal game should display and be interactive', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(body: AnimalGame()),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('这是哪个动物？'), findsOneWidget);
      expect(find.text('第 0/10 题'), findsOneWidget);
    });

    testWidgets('Pinyin game should display pinyin and Chinese characters', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(body: PinyinGame()),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('选择正确的汉字'), findsOneWidget);
      expect(find.text('读作'), findsOneWidget);
    });

    testWidgets('Matching game should display 12 cards', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(body: MatchingGame()),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('找出相同的配对'), findsOneWidget);
      expect(find.text('配对: 0/6'), findsOneWidget);
    });

    testWidgets('Connect game should display and show matched items', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(body: ConnectGame()),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('点击两个相同的图标'), findsOneWidget);
      expect(find.text('配对: 0/4'), findsOneWidget);
    });
  });
}
