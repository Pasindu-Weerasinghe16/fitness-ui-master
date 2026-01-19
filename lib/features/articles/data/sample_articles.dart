import 'package:fitness_flutter/features/articles/models/article.dart';

/// In-app sample content for the "Fitness Tips & Articles" section.
///
/// If you later move to Firestore/API-driven content, you can replace this
/// list with a repository/service.
const kSampleArticles = <Article>[
  Article(
    category: 'Nutrition',
    title: 'Pre‑Workout Nutrition Guide',
    subtitle: 'What to eat and when for better energy.',
    image: 'assets/images/image001.jpg',
    content:
        'A good pre‑workout meal improves performance and helps you train harder.\n\n'
        'Timing (simple rule):\n'
        '- 2–3 hours before: a full meal\n'
        '- 30–90 minutes before: a light snack\n\n'
        'What to include:\n'
        '- Carbs for quick energy (fruit, oats, rice)\n'
        '- Protein for muscle support (yogurt, eggs, chicken)\n'
        '- Low fat/fiber right before training to reduce stomach discomfort\n\n'
        'Quick snack ideas (30–60 minutes before):\n'
        '- Banana + Greek yogurt\n'
        '- Toast + honey\n'
        '- Small smoothie (banana + milk + whey)\n\n'
        'Hydration: start your session already hydrated. If your urine is dark, drink water and consider electrolytes.',
  ),
  Article(
    category: 'Training',
    title: 'How to Build Muscle Effectively',
    subtitle: 'The 4 fundamentals: progressive overload, volume, sleep, food.',
    image: 'assets/images/image002.jpg',
    content:
        'Muscle growth is simple but not easy. Focus on the fundamentals.\n\n'
        '1) Progressive overload\n'
        '- Add reps, sets, weight, or improve form week to week.\n\n'
        '2) Enough weekly volume\n'
        '- Most beginners do well with 8–12 hard sets per muscle per week.\n\n'
        '3) Train close to failure\n'
        '- Stop with ~1–3 reps in reserve on most sets.\n\n'
        '4) Recover\n'
        '- Sleep 7–9 hours.\n'
        '- Eat enough protein (roughly 1.6–2.2 g/kg/day).\n\n'
        'If you can only do one thing today: pick 4–6 key lifts and track them for a month.',
  ),
  Article(
    category: 'Recovery',
    title: 'The Importance of Rest Days',
    subtitle: 'Recovery is where your body adapts and improves.',
    image: 'assets/images/image003.jpg',
    content:
        'Rest days are not “lazy days” — they are part of training.\n\n'
        'Why rest matters:\n'
        '- Muscles repair and grow\n'
        '- Joints and tendons recover\n'
        '- Motivation stays high\n\n'
        'Good rest day options:\n'
        '- 20–40 min walk\n'
        '- Mobility work\n'
        '- Light stretching\n\n'
        'Warning signs you need more recovery:\n'
        '- Poor sleep\n'
        '- Performance dropping\n'
        '- Constant soreness\n\n'
        'Plan at least 1–2 rest days per week, especially if you lift heavy.',
  ),
  Article(
    category: 'Motivation',
    title: 'Stay Consistent: 7 Tips',
    subtitle: 'Small habits that keep you going all year.',
    image: 'assets/images/image004.jpg',
    content:
        'Consistency beats intensity. Try these 7 tips:\n\n'
        '- Set a minimum (e.g., 2 workouts/week).\n'
        '- Track your workouts (notes app is enough).\n'
        '- Prepare the night before (clothes, bottle).\n'
        '- Start sessions with an easy warm‑up.\n'
        '- Don’t miss twice (one miss is normal).\n'
        '- Pick workouts you enjoy.\n'
        '- Celebrate small wins.\n\n'
        'When motivation is low, just show up for 10 minutes. Often that’s enough to finish the full session.',
  ),
  Article(
    category: 'Wellness',
    title: 'Sleep & Fitness Performance',
    subtitle: 'Better sleep = better recovery, strength, and mood.',
    image: 'assets/images/image005.jpg',
    content:
        'Sleep is the highest‑ROI recovery tool.\n\n'
        'Improve sleep with this checklist:\n'
        '- Keep a consistent bedtime/wake time.\n'
        '- Limit caffeine after midday.\n'
        '- Keep the room cool and dark.\n'
        '- Avoid heavy meals right before bed.\n'
        '- Get daylight in the morning.\n\n'
        'If you want better performance: aim for 7–9 hours, and take naps (10–20 min) when needed.',
  ),
];
