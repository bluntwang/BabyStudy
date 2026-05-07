import 'package:flutter/material.dart';
import '../core/router/app_router.dart';
import '../core/constants/app_constants.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 40),
            // 吉祥物
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                image: const DecorationImage(
                  image: AssetImage('assets/logo/baby.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'BabyStudy',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            Text(
              '选择你的年龄段开始学习',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 40),
            // 年龄段选择
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _AgeGroupCard(
                      ageGroup: AgeGroup.small,
                      color: const Color(0xFF5B9BD5),
                      onTap: () => Navigator.pushNamed(
                        context,
                        AppRouter.gameList,
                        arguments: AgeGroup.small.key,
                      ),
                    ),
                    _AgeGroupCard(
                      ageGroup: AgeGroup.medium,
                      color: const Color(0xFFFF9F43),
                      onTap: () => Navigator.pushNamed(
                        context,
                        AppRouter.gameList,
                        arguments: AgeGroup.medium.key,
                      ),
                    ),
                    _AgeGroupCard(
                      ageGroup: AgeGroup.large,
                      color: const Color(0xFF2ECC71),
                      onTap: () => Navigator.pushNamed(
                        context,
                        AppRouter.gameList,
                        arguments: AgeGroup.large.key,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AgeGroupCard extends StatefulWidget {
  final AgeGroup ageGroup;
  final Color color;
  final VoidCallback onTap;

  const _AgeGroupCard({
    required this.ageGroup,
    required this.color,
    required this.onTap,
  });

  @override
  State<_AgeGroupCard> createState() => _AgeGroupCardState();
}

class _AgeGroupCardState extends State<_AgeGroupCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _isPressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          height: 100,
          decoration: BoxDecoration(
            color: widget.color,
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: widget.color.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            children: [
              const SizedBox(width: 20),
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Icon(
                  Icons.school,
                  color: Colors.white,
                  size: 35,
                ),
              ),
              const SizedBox(width: 20),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.ageGroup.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    '${widget.ageGroup.minAge}-${widget.ageGroup.maxAge}岁',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
