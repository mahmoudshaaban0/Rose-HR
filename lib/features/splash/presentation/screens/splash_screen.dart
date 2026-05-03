import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rose_hr/common/constants/app_strings.dart';
import 'package:rose_hr/common/helpers/app_manager.dart';
import 'package:rose_hr/common/notifications/notification_service.dart';
import 'package:rose_hr/common/routing/app_routes.dart';
import 'package:rose_hr/theme/theme_ext.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _bubbleAnimation;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoOpacityAnimation;

  @override
  void initState() {
    super.initState();
    _setup();
    // Initialize animation controller with slower duration
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    );

    // Bubble expansion animation - grows from 0 to fill the screen
    _bubbleAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    // Logo scale animation - starts small and grows
    _logoScaleAnimation =
        Tween<double>(
          begin: 0,
          end: 1,
        ).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: const Interval(0.2, 0.8, curve: Curves.elasticOut),
          ),
        );

    // Logo opacity animation - fades in
    _logoOpacityAnimation =
        Tween<double>(
          begin: 0,
          end: 1,
        ).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: const Interval(0.3, 0.7, curve: Curves.easeIn),
          ),
        );

    // Start animation
    _animationController.forward();

    // Navigate after animation completes
    Future.delayed(const Duration(milliseconds: 3200), () {
      if (mounted) {
        if (AppManager.instance.getString(AppStrings.apiKey) != null) {
          context.goNamed(AppRoutes.home.name);
        } else {
          context.goNamed(AppRoutes.login.name);
        }
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bubbleColor = context.colors.black;
    final backgroundColor = context.colors.surface;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Stack(
            children: [
              // Animated bubble that fills the screen
              ClipPath(
                clipper: _BubbleClipper(_bubbleAnimation.value),
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        bubbleColor,
                        bubbleColor.withValues(alpha: 0.8),
                      ],
                    ),
                  ),
                ),
              ),
              // Logo and app name centered
              Center(
                child: Opacity(
                  opacity: _logoOpacityAnimation.value,
                  child: Transform.scale(
                    scale: _logoScaleAnimation.value,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Image.asset(Assets.iconsRoseHrLogoAndText),
                        const SizedBox(height: 16),
                        Text(
                          AppStrings.appName,
                          style: context.typography.bold22.copyWith(
                            color: context.colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Custom clipper that creates a cloud-like shape with smooth random edges
class _BubbleClipper extends CustomClipper<Path> {
  _BubbleClipper(this.animationValue);

  final double animationValue;

  @override
  Path getClip(Size size) {
    if (animationValue == 0) {
      return Path();
    }

    final path = Path();
    final center = Offset(size.width / 2, size.height / 2);

    // Calculate the base radius needed to cover the entire screen from center
    final maxRadius = size.longestSide * 1.3;
    final currentRadius = maxRadius * animationValue;

    // Create cloud shape with smooth curved bumps (like the image)
    // We'll create a path with multiple curves around a center point

    // Define cloud bumps with varying sizes for organic look
    const bumps = [
      _CloudBump(angle: 0, size: 1, curvature: 0.8), // Right
      _CloudBump(angle: 45, size: 0.7, curvature: 0.6), // Top-right
      _CloudBump(angle: 90, size: 1.1, curvature: 0.9), // Top (larger bump)
      _CloudBump(angle: 135, size: 0.75, curvature: 0.65), // Top-left
      _CloudBump(angle: 180, size: 0.9, curvature: 0.7), // Left
      _CloudBump(angle: 225, size: 0.85, curvature: 0.7), // Bottom-left
      _CloudBump(angle: 270, size: 0.95, curvature: 0.75), // Bottom
      _CloudBump(angle: 315, size: 0.8, curvature: 0.65), // Bottom-right
    ];

    // Start the path
    final firstBump = bumps[0];
    final startRadius = currentRadius * firstBump.size;
    final startAngle = firstBump.angle * math.pi / 180;
    final startPoint = Offset(
      center.dx + startRadius * math.cos(startAngle),
      center.dy + startRadius * math.sin(startAngle),
    );

    path.moveTo(startPoint.dx, startPoint.dy);

    // Create smooth curves between bumps
    for (var i = 0; i < bumps.length; i++) {
      final currentBump = bumps[i];
      final nextBump = bumps[(i + 1) % bumps.length];

      final currentAngle = currentBump.angle * math.pi / 180;
      final nextAngle = nextBump.angle * math.pi / 180;

      final currentR = currentRadius * currentBump.size;
      final nextR = currentRadius * nextBump.size;

      // Next point
      final next = Offset(
        center.dx + nextR * math.cos(nextAngle),
        center.dy + nextR * math.sin(nextAngle),
      );

      // Calculate control points for smooth Bezier curve
      final controlPoint1 = Offset(
        center.dx + currentR * math.cos(currentAngle + 0.3),
        center.dy + currentR * math.sin(currentAngle + 0.3),
      );

      final controlPoint2 = Offset(
        center.dx + nextR * math.cos(nextAngle - 0.3),
        center.dy + nextR * math.sin(nextAngle - 0.3),
      );

      // Draw cubic Bezier curve
      path.cubicTo(
        controlPoint1.dx,
        controlPoint1.dy,
        controlPoint2.dx,
        controlPoint2.dy,
        next.dx,
        next.dy,
      );
    }

    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant _BubbleClipper oldClipper) {
    return oldClipper.animationValue != animationValue;
  }
}

/// Helper class to define cloud bump properties
class _CloudBump {
  const _CloudBump({
    required this.angle,
    required this.size,
    required this.curvature,
  });

  final double angle; // Angle in degrees
  final double size; // Size multiplier for this bump
  final double curvature; // How curved the transition is
}

Future<void> _setup() async {
  await NotificationService().requestPermission();
  NotificationService().onTap.listen((data) {
    debugPrint('Notification tapped: $data');
  });
}
