import 'package:flutter/material.dart';

class GameLayout extends StatelessWidget {
  final Widget child;
  final String title;
  final String subtitle;
  final String description;
  final double headerHeight;

  const GameLayout({
    super.key,
    required this.child,
    this.title = 'Undercover',
    this.subtitle = '',
    this.description = '',
    this.headerHeight = 286,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFC6B7DF), Color(0xFF261A39)],
          ),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              // header part
              SizedBox(
                height: headerHeight,
                width: double.infinity,
                child: Stack(
                  children: [
                    Positioned(
                      top: -80,
                      left: -50,
                      right: -50,
                      child: Transform.rotate(
                        angle: 4.28 * 3.14159 / 180,
                        child: Container(
                          height: headerHeight,
                          color: const Color(0xFF433758),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 80,
                      left: 0,
                      right: 0,
                      child: Column(
                        children: [
                          Text(
                            title,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (subtitle.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Text(
                              subtitle,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // content part
              Expanded(child: child),
            ],
          ),
        ),
      ),
    );
  }
}
