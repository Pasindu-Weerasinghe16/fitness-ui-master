import 'package:flutter/material.dart';
import 'dart:math' as math;

class CircularProgressCard extends StatelessWidget {
  final String title;
  final int current;
  final int goal;
  final Color color;
  final String? subtitle;
  final VoidCallback? onSeeAll;
  final IconData centerIcon;

  const CircularProgressCard({
    super.key,
    required this.title,
    required this.current,
    required this.goal,
    this.color = const Color(0xFFFF8C42),
    this.subtitle,
    this.onSeeAll,
    this.centerIcon = Icons.directions_run,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final safeGoal = goal <= 0 ? 1 : goal;
    final progress = (current / safeGoal).clamp(0.0, 1.0);
    final borderColor = isDark ? Colors.white.withOpacity(0.10) : const Color(0xFFE9ECF3);
    final cardBg = theme.colorScheme.surface;

    return Container(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withOpacity(0.24) : Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              _SeeAllPill(
                label: 'See all',
                onTap: onSeeAll,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: isDark ? Colors.white.withOpacity(0.08) : const Color(0xFFF1F2F7),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: borderColor),
                ),
                child: Text(
                  (subtitle ?? 'Goal: $safeGoal').trim(),
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: theme.textTheme.bodySmall?.color?.withOpacity(0.85),
                  ),
                ),
              ),
              const Spacer(),
              _ActionCircle(
                icon: Icons.map_outlined,
                onTap: () {},
              ),
              const SizedBox(width: 10),
              _ActionCircle(
                icon: Icons.volume_off_outlined,
                onTap: () {},
                iconColor: const Color(0xFFF97316),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Center(
            child: SizedBox(
              width: 240,
              height: 240,
              child: CustomPaint(
                painter: _ActivitiesRingPainter(
                  progress: progress,
                  trackColor: isDark ? Colors.white.withOpacity(0.12) : const Color(0xFFE6EAF3),
                  dotColor: isDark ? Colors.white.withOpacity(0.16) : const Color(0xFFD7DCE9),
                  progressGradient: LinearGradient(
                    colors: [
                      color.withOpacity(0.95),
                      color.withOpacity(0.65),
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 54,
                        height: 54,
                        decoration: BoxDecoration(
                          color: cardBg,
                          shape: BoxShape.circle,
                          border: Border.all(color: borderColor),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(isDark ? 0.18 : 0.06),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Icon(centerIcon, color: theme.colorScheme.onSurface, size: 26),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'STREAK',
                        style: theme.textTheme.labelLarge?.copyWith(
                          letterSpacing: 1.0,
                          fontWeight: FontWeight.w800,
                          color: theme.textTheme.bodySmall?.color?.withOpacity(0.75),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '$current days',
                        style: theme.textTheme.displaySmall?.copyWith(
                          fontWeight: FontWeight.w900,
                          height: 1.0,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.flag_outlined, size: 16, color: theme.colorScheme.primary),
                          const SizedBox(width: 6),
                          Text(
                            'Goal $safeGoal days',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _BottomStat(
                dotColor: theme.colorScheme.onSurface.withOpacity(0.70),
                label: 'Current',
                value: '$current',
                unit: 'days',
              ),
              _BottomStat(
                dotColor: color,
                label: 'Goal',
                value: '$safeGoal',
                unit: 'days',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActivitiesRingPainter extends CustomPainter {
  final double progress;
  final Color trackColor;
  final Color dotColor;
  final Gradient progressGradient;

  _ActivitiesRingPainter({
    required this.progress,
    required this.trackColor,
    required this.dotColor,
    required this.progressGradient,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - 10;
    final rect = Rect.fromCircle(center: center, radius: radius);
    const stroke = 16.0;

    // Outer dotted ring
    final dotCount = 64;
    final dotRadius = radius + 10;
    final dotPaint = Paint()..color = dotColor;
    for (var i = 0; i < dotCount; i++) {
      final t = (2 * math.pi * i) / dotCount;
      final p = Offset(
        center.dx + dotRadius * math.cos(t),
        center.dy + dotRadius * math.sin(t),
      );
      canvas.drawCircle(p, 1.7, dotPaint);
    }

    // Gauge track (leave a small top gap like the screenshot)
    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;

    final startAngle = math.pi * 0.85; // ~153°
    final totalSweep = math.pi * 1.30; // ~234°
    canvas.drawArc(rect, startAngle, totalSweep, false, trackPaint);

    // Progress arc
    final progressPaint = Paint()
      ..shader = progressGradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(rect, startAngle, totalSweep * progress, false, progressPaint);
  }

  @override
  bool shouldRepaint(_ActivitiesRingPainter oldDelegate) =>
      oldDelegate.progress != progress ||
      oldDelegate.trackColor != trackColor ||
      oldDelegate.dotColor != dotColor;
}

class _SeeAllPill extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;

  const _SeeAllPill({
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final borderColor = isDark ? Colors.white.withOpacity(0.10) : const Color(0xFFE9ECF3);
    final bg = isDark ? Colors.white.withOpacity(0.06) : const Color(0xFFF1F2F7);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(width: 6),
            Icon(
              Icons.chevron_right,
              size: 18,
              color: theme.textTheme.bodySmall?.color?.withOpacity(0.75),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionCircle extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color? iconColor;

  const _ActionCircle({
    required this.icon,
    required this.onTap,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final borderColor = isDark ? Colors.white.withOpacity(0.10) : const Color(0xFFE9ECF3);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          shape: BoxShape.circle,
          border: Border.all(color: borderColor),
        ),
        child: Icon(
          icon,
          size: 20,
          color: iconColor ?? theme.textTheme.bodySmall?.color?.withOpacity(0.85),
        ),
      ),
    );
  }
}

class _BottomStat extends StatelessWidget {
  final Color dotColor;
  final String label;
  final String value;
  final String unit;

  const _BottomStat({
    required this.dotColor,
    required this.label,
    required this.value,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: dotColor,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              value,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(width: 4),
            Padding(
              padding: const EdgeInsets.only(bottom: 3),
              child: Text(
                unit,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.textTheme.bodySmall?.color?.withOpacity(0.7),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
