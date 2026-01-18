import 'package:flutter/material.dart';
import 'package:fitness_flutter/features/workouts/models/exercise.dart';
import 'package:fitness_flutter/services/workout_tracking_service.dart';

class WorkoutDetailPage extends StatefulWidget {
  final Exercise exercise;
  final String tag;

  const WorkoutDetailPage({
    super.key,
    required this.exercise,
    required this.tag,
  });

  @override
  State<WorkoutDetailPage> createState() => _WorkoutDetailPageState();
}

class _WorkoutDetailPageState extends State<WorkoutDetailPage> {
  int _currentStep = 0;
  final _trackingService = WorkoutTrackingService();

  List<Map<String, dynamic>> get _workoutSteps {
    final workoutPlans = {
      'Morning Stretch': [
        {'title': 'Neck Rolls', 'duration': '1 min', 'reps': '10 rolls', 'description': 'Slowly roll your head in circular motions. 5 times clockwise, 5 times counter-clockwise.', 'image': 'assets/images/image001.jpg', 'calories': 5},
        {'title': 'Shoulder Shrugs', 'duration': '1 min', 'reps': '15 reps', 'description': 'Lift shoulders up to ears, hold for 2 seconds, then release. Repeat 15 times.', 'image': 'assets/images/image002.jpg', 'calories': 8},
        {'title': 'Arm Circles', 'duration': '2 min', 'reps': '20 each direction', 'description': 'Extend arms to sides. Make small circles, gradually increasing size. 20 forward, 20 backward.', 'image': 'assets/images/image003.jpg', 'calories': 12},
        {'title': 'Side Bends', 'duration': '2 min', 'reps': '10 each side', 'description': 'Stand with feet hip-width apart. Reach one arm overhead and bend to the opposite side. Hold 3 seconds.', 'image': 'assets/images/image004.jpg', 'calories': 10},
        {'title': 'Forward Fold', 'duration': '2 min', 'reps': 'Hold 30 sec', 'description': 'Stand tall, then slowly fold forward from hips. Let arms hang or hold opposite elbows.', 'image': 'assets/images/image005.jpg', 'calories': 5},
        {'title': 'Quad Stretch', 'duration': '2 min', 'reps': '30 sec each leg', 'description': 'Standing on one leg, pull opposite foot toward glutes. Hold for balance and feel the stretch.', 'image': 'assets/images/image001.jpg', 'calories': 5},
      ],
      'Light Cardio': [
        {'title': 'Warm-up Walk', 'duration': '2 min', 'reps': 'Easy pace', 'description': 'Start with a gentle walk to warm up your muscles and get your heart rate up gradually.', 'image': 'assets/images/image002.jpg', 'calories': 12},
        {'title': 'Marching in Place', 'duration': '3 min', 'reps': 'Steady rhythm', 'description': 'Lift knees high while marching in place. Swing arms naturally. Keep core engaged.', 'image': 'assets/images/image003.jpg', 'calories': 18},
        {'title': 'Side Steps', 'duration': '3 min', 'reps': '20 each side', 'description': 'Step side to side, touching opposite hand to knee. Maintain steady rhythm.', 'image': 'assets/images/image004.jpg', 'calories': 20},
        {'title': 'Heel Taps', 'duration': '3 min', 'reps': '30 total', 'description': 'Alternate tapping heels forward while keeping knees slightly bent. Engage your core.', 'image': 'assets/images/image005.jpg', 'calories': 22},
        {'title': 'Cool Down Walk', 'duration': '4 min', 'reps': 'Slow pace', 'description': 'Gradually slow your pace to bring heart rate down. Focus on deep breathing.', 'image': 'assets/images/image001.jpg', 'calories': 23},
      ],
      'Basic Yoga Flow': [
        {'title': 'Mountain Pose', 'duration': '2 min', 'reps': 'Hold', 'description': 'Stand tall with feet together. Ground through all four corners of feet. Arms at sides, palms forward.', 'image': 'assets/images/image003.jpg', 'calories': 8},
        {'title': 'Cat-Cow Stretch', 'duration': '3 min', 'reps': '10 cycles', 'description': 'On hands and knees, alternate arching back (cow) and rounding spine (cat). Move with breath.', 'image': 'assets/images/image004.jpg', 'calories': 12},
        {'title': 'Downward Dog', 'duration': '3 min', 'reps': 'Hold 30 sec', 'description': 'From hands and knees, lift hips up and back. Form inverted V shape. Press heels toward floor.', 'image': 'assets/images/image005.jpg', 'calories': 15},
        {'title': 'Warrior I', 'duration': '4 min', 'reps': '2 min each side', 'description': 'Step one foot back, bend front knee. Raise arms overhead. Keep hips square forward.', 'image': 'assets/images/image001.jpg', 'calories': 20},
        {'title': 'Child Pose', 'duration': '3 min', 'reps': 'Hold', 'description': 'Sit back on heels, extend arms forward. Rest forehead on mat. Breathe deeply.', 'image': 'assets/images/image002.jpg', 'calories': 10},
        {'title': 'Savasana', 'duration': '5 min', 'reps': 'Relax', 'description': 'Lie on back, arms at sides, palms up. Close eyes. Focus on breath and relaxation.', 'image': 'assets/images/image003.jpg', 'calories': 15},
      ],
      'Walking Routine': [
        {'title': 'Slow Warm-up', 'duration': '5 min', 'reps': '3.0 mph', 'description': 'Start with a comfortable walking pace. Focus on good posture and natural arm swing.', 'image': 'assets/images/image004.jpg', 'calories': 20},
        {'title': 'Moderate Pace', 'duration': '8 min', 'reps': '3.5 mph', 'description': 'Increase pace slightly. Maintain steady breathing. Keep shoulders relaxed.', 'image': 'assets/images/image005.jpg', 'calories': 35},
        {'title': 'Brisk Walk', 'duration': '7 min', 'reps': '4.0 mph', 'description': 'Pick up the pace. Pump arms for momentum. Feel your heart rate increase.', 'image': 'assets/images/image001.jpg', 'calories': 40},
        {'title': 'Cool Down', 'duration': '5 min', 'reps': '3.0 mph', 'description': 'Gradually slow down. Deep breaths. Let heart rate return to normal.', 'image': 'assets/images/image002.jpg', 'calories': 25},
      ],
      'HIIT Cardio': [
        {'title': 'Warm-up Jog', 'duration': '3 min', 'reps': 'Easy pace', 'description': 'Light jogging to prepare muscles and elevate heart rate gradually.', 'image': 'assets/images/image005.jpg', 'calories': 25},
        {'title': 'High Knees', 'duration': '5 min', 'reps': '30 sec on/30 sec off', 'description': 'Run in place bringing knees to waist height. Maximum intensity during work intervals.', 'image': 'assets/images/image001.jpg', 'calories': 55},
        {'title': 'Burpees', 'duration': '5 min', 'reps': '40 sec on/20 sec off', 'description': 'Drop to plank, push-up, jump feet forward, explosive jump up. Full body engagement.', 'image': 'assets/images/image002.jpg', 'calories': 65},
        {'title': 'Mountain Climbers', 'duration': '5 min', 'reps': '30 sec on/30 sec off', 'description': 'Plank position, alternate driving knees to chest rapidly. Keep core tight.', 'image': 'assets/images/image003.jpg', 'calories': 60},
        {'title': 'Jump Squats', 'duration': '5 min', 'reps': '40 sec on/20 sec off', 'description': 'Squat down, explode up jumping high. Land softly, immediately into next rep.', 'image': 'assets/images/image004.jpg', 'calories': 58},
        {'title': 'Active Recovery', 'duration': '4 min', 'reps': 'Light movement', 'description': 'Walk and stretch. Bring heart rate down gradually while staying mobile.', 'image': 'assets/images/image005.jpg', 'calories': 17},
        {'title': 'Cool Down', 'duration': '3 min', 'reps': 'Stretch', 'description': 'Full body stretching. Focus on breathing and muscle recovery.', 'image': 'assets/images/image001.jpg', 'calories': 20},
      ],
      'Full Body Strength': [
        {'title': 'Dynamic Warm-up', 'duration': '5 min', 'reps': 'Movement prep', 'description': 'Arm circles, leg swings, torso twists. Prepare all muscle groups.', 'image': 'assets/images/image001.jpg', 'calories': 25},
        {'title': 'Push-ups', 'duration': '5 min', 'reps': '3 sets x 12', 'description': 'Chest, shoulders, triceps. Maintain straight body line. Modify on knees if needed.', 'image': 'assets/images/image002.jpg', 'calories': 45},
        {'title': 'Bodyweight Squats', 'duration': '5 min', 'reps': '3 sets x 15', 'description': 'Feet shoulder-width. Lower until thighs parallel. Drive through heels to stand.', 'image': 'assets/images/image003.jpg', 'calories': 50},
        {'title': 'Plank Hold', 'duration': '5 min', 'reps': '3 sets x 45 sec', 'description': 'Forearms on ground, body straight. Engage core, glutes. Don\'t let hips sag.', 'image': 'assets/images/image004.jpg', 'calories': 35},
        {'title': 'Lunges', 'duration': '5 min', 'reps': '3 sets x 10 each', 'description': 'Step forward, lower back knee. Front knee over ankle. Alternate legs.', 'image': 'assets/images/image005.jpg', 'calories': 55},
        {'title': 'Dumbbell Rows', 'duration': '5 min', 'reps': '3 sets x 12', 'description': 'Hinge at hips, pull weight to chest. Squeeze shoulder blades. Control descent.', 'image': 'assets/images/image001.jpg', 'calories': 50},
        {'title': 'Cool Down Stretch', 'duration': '5 min', 'reps': 'Full body', 'description': 'Stretch all major muscle groups worked. Hold each 30 seconds.', 'image': 'assets/images/image002.jpg', 'calories': 20},
      ],
      'Bicep & Tricep': [
        {'title': 'Arm Warm-up', 'duration': '3 min', 'reps': 'Light movement', 'description': 'Arm circles, shoulder rolls. Get blood flowing to upper body.', 'image': 'assets/images/image002.jpg', 'calories': 15},
        {'title': 'Bicep Curls', 'duration': '5 min', 'reps': '4 sets x 12', 'description': 'Dumbbells at sides, curl up rotating palms forward. Control down. Keep elbows still.', 'image': 'assets/images/image003.jpg', 'calories': 45},
        {'title': 'Hammer Curls', 'duration': '4 min', 'reps': '3 sets x 12', 'description': 'Neutral grip (palms facing). Curl up. Targets brachialis and forearms.', 'image': 'assets/images/image004.jpg', 'calories': 40},
        {'title': 'Tricep Dips', 'duration': '5 min', 'reps': '3 sets x 15', 'description': 'Hands on bench, lower body by bending elbows. Push back up. Keep close to bench.', 'image': 'assets/images/image005.jpg', 'calories': 50},
        {'title': 'Overhead Extension', 'duration': '4 min', 'reps': '3 sets x 12', 'description': 'Dumbbell overhead, lower behind head. Extend back up. Elbows stay close to head.', 'image': 'assets/images/image001.jpg', 'calories': 38},
        {'title': 'Concentration Curl', 'duration': '4 min', 'reps': '3 sets x 10 each', 'description': 'Seated, elbow on inner thigh. Curl up with focus. Maximum bicep contraction.', 'image': 'assets/images/image002.jpg', 'calories': 22},
      ],
      'Core Blast': [
        {'title': 'Core Activation', 'duration': '2 min', 'reps': 'Breathing', 'description': 'Lie on back, engage core. Practice breathing while maintaining tension.', 'image': 'assets/images/image003.jpg', 'calories': 10},
        {'title': 'Crunches', 'duration': '3 min', 'reps': '3 sets x 20', 'description': 'Hands behind head, lift shoulders off ground. Exhale up. Lower with control.', 'image': 'assets/images/image004.jpg', 'calories': 30},
        {'title': 'Bicycle Crunches', 'duration': '3 min', 'reps': '3 sets x 30', 'description': 'Alternate elbow to opposite knee. Full extension on non-working leg.', 'image': 'assets/images/image005.jpg', 'calories': 35},
        {'title': 'Plank', 'duration': '3 min', 'reps': '3 x 60 sec', 'description': 'Hold strong plank position. Body straight, core tight, breathe steadily.', 'image': 'assets/images/image001.jpg', 'calories': 25},
        {'title': 'Russian Twists', 'duration': '3 min', 'reps': '3 sets x 40', 'description': 'Seated, lean back, twist side to side. Touch ground each side. Keep chest up.', 'image': 'assets/images/image002.jpg', 'calories': 32},
        {'title': 'Leg Raises', 'duration': '3 min', 'reps': '3 sets x 15', 'description': 'Lie flat, raise legs to 90 degrees. Lower slowly without touching ground.', 'image': 'assets/images/image003.jpg', 'calories': 28},
        {'title': 'Mountain Climbers', 'duration': '3 min', 'reps': '3 sets x 30 sec', 'description': 'Fast pace, drive knees to chest. Keep hips level, core engaged.', 'image': 'assets/images/image004.jpg', 'calories': 20},
      ],
      'Power Yoga': [
        {'title': 'Sun Salutation A', 'duration': '8 min', 'reps': '5 rounds', 'description': 'Flow through: Mountain-Forward Fold-Plank-Chaturanga-Upward Dog-Downward Dog.', 'image': 'assets/images/image004.jpg', 'calories': 50},
        {'title': 'Warrior Flow', 'duration': '10 min', 'reps': '3 rounds', 'description': 'Warrior I-II-III sequence both sides. Build strength and balance.', 'image': 'assets/images/image005.jpg', 'calories': 70},
        {'title': 'Power Holds', 'duration': '8 min', 'reps': '60 sec each', 'description': 'Chair pose, Warrior III, Boat pose. Hold for strength building.', 'image': 'assets/images/image001.jpg', 'calories': 55},
        {'title': 'Balance Series', 'duration': '7 min', 'reps': '45 sec each', 'description': 'Tree, Eagle, Half Moon. Build stability and focus.', 'image': 'assets/images/image002.jpg', 'calories': 40},
        {'title': 'Core Flow', 'duration': '5 min', 'reps': '3 rounds', 'description': 'Boat-Plank-Side Plank transitions. Continuous movement.', 'image': 'assets/images/image003.jpg', 'calories': 30},
        {'title': 'Cool Down', 'duration': '2 min', 'reps': 'Restorative', 'description': 'Pigeon, Seated Forward Fold, final Savasana.', 'image': 'assets/images/image004.jpg', 'calories': 5},
      ],
      'Boxing Fundamentals': [
        {'title': 'Shadowboxing Warm-up', 'duration': '5 min', 'reps': 'Light movement', 'description': 'Loose punches, footwork practice. Get muscles warm and ready.', 'image': 'assets/images/image005.jpg', 'calories': 30},
        {'title': 'Jab Practice', 'duration': '5 min', 'reps': '3 min rounds', 'description': 'Focus on form: snap, retraction, footwork. Lead hand extends straight.', 'image': 'assets/images/image001.jpg', 'calories': 45},
        {'title': 'Cross Technique', 'duration': '5 min', 'reps': '3 min rounds', 'description': 'Rear hand power punch. Rotate hips, pivot back foot. Generate power from ground.', 'image': 'assets/images/image002.jpg', 'calories': 50},
        {'title': 'Hook Combinations', 'duration': '5 min', 'reps': '3 min rounds', 'description': 'Lead and rear hooks. Turn at waist, keep elbow up. Compact motion.', 'image': 'assets/images/image003.jpg', 'calories': 55},
        {'title': 'Combo Drills', 'duration': '7 min', 'reps': '2 min rounds', 'description': 'Jab-Cross-Hook combinations. Flow between punches. Stay light on feet.', 'image': 'assets/images/image004.jpg', 'calories': 75},
        {'title': 'Cool Down', 'duration': '3 min', 'reps': 'Stretch', 'description': 'Shoulder, chest, arm stretches. Deep breathing to lower heart rate.', 'image': 'assets/images/image005.jpg', 'calories': 15},
      ],
      'Advanced HIIT': [
        {'title': 'Warm-up Circuit', 'duration': '5 min', 'reps': 'Dynamic', 'description': 'Jump rope, high knees, butt kicks. Elevate heart rate progressively.', 'image': 'assets/images/image001.jpg', 'calories': 40},
        {'title': 'Burpee Box Jumps', 'duration': '8 min', 'reps': '45 sec on/15 off', 'description': 'Burpee into box jump. Maximum power. Full body explosive movement.', 'image': 'assets/images/image002.jpg', 'calories': 110},
        {'title': 'Kettlebell Swings', 'duration': '7 min', 'reps': '40 sec on/20 off', 'description': 'Hip hinge, explosive swing to shoulder height. Power from hips, not arms.', 'image': 'assets/images/image003.jpg', 'calories': 95},
        {'title': 'Battle Ropes', 'duration': '6 min', 'reps': '30 sec on/30 off', 'description': 'Alternating waves, maximum intensity. Engage core, maintain rhythm.', 'image': 'assets/images/image004.jpg', 'calories': 85},
        {'title': 'Sprint Intervals', 'duration': '10 min', 'reps': '30 sec sprint/30 walk', 'description': 'Maximum effort sprints. Full recovery between. 10 total intervals.', 'image': 'assets/images/image005.jpg', 'calories': 130},
        {'title': 'Plyo Push-ups', 'duration': '5 min', 'reps': '40 sec on/20 off', 'description': 'Explosive push-ups with hand clap. Land softly, control descent.', 'image': 'assets/images/image001.jpg', 'calories': 65},
        {'title': 'Cool Down', 'duration': '4 min', 'reps': 'Recovery', 'description': 'Light walk, dynamic stretching. Bring heart rate down safely.', 'image': 'assets/images/image002.jpg', 'calories': 15},
      ],
      'Heavy Lifting': [
        {'title': 'Warm-up Sets', 'duration': '8 min', 'reps': 'Progressive load', 'description': 'Empty bar, then 50%, 75% working weight. Prime nervous system.', 'image': 'assets/images/image002.jpg', 'calories': 40},
        {'title': 'Barbell Squats', 'duration': '12 min', 'reps': '5 sets x 5', 'description': 'Heavy compound movement. Full depth. Rest 3 min between sets.', 'image': 'assets/images/image003.jpg', 'calories': 100},
        {'title': 'Bench Press', 'duration': '10 min', 'reps': '5 sets x 5', 'description': 'Chest, shoulders, triceps. Controlled descent. Explosive press. Long rest.', 'image': 'assets/images/image004.jpg', 'calories': 85},
        {'title': 'Deadlifts', 'duration': '12 min', 'reps': '5 sets x 3', 'description': 'King of lifts. Perfect form. Full body tension. Heavy weight.', 'image': 'assets/images/image005.jpg', 'calories': 110},
        {'title': 'Overhead Press', 'duration': '10 min', 'reps': '4 sets x 6', 'description': 'Shoulder development. Core tight. Press straight up. Control descent.', 'image': 'assets/images/image001.jpg', 'calories': 75},
        {'title': 'Cool Down', 'duration': '8 min', 'reps': 'Deload & stretch', 'description': 'Light movement, full body stretching. Recovery begins now.', 'image': 'assets/images/image002.jpg', 'calories': 40},
      ],
      'CrossFit WOD': [
        {'title': 'General Warm-up', 'duration': '8 min', 'reps': 'Movement prep', 'description': 'Row 500m, mobility drills, activation exercises. Prepare for intensity.', 'image': 'assets/images/image003.jpg', 'calories': 50},
        {'title': 'Skill Work: Snatch', 'duration': '10 min', 'reps': 'Technique', 'description': 'Practice snatch form. Build to working weight. Focus on speed under bar.', 'image': 'assets/images/image004.jpg', 'calories': 65},
        {'title': 'WOD: Fran', 'duration': '15 min', 'reps': '21-15-9', 'description': 'Thrusters (95lbs) and Pull-ups. 21 each, 15 each, 9 each for time. Go hard.', 'image': 'assets/images/image005.jpg', 'calories': 220},
        {'title': 'Accessory Work', 'duration': '12 min', 'reps': '4 rounds', 'description': 'Weighted planks, hollow holds, arch holds. Core and midline stability.', 'image': 'assets/images/image001.jpg', 'calories': 80},
        {'title': 'Cool Down', 'duration': '10 min', 'reps': 'Recovery', 'description': 'Easy bike or row, stretching, foam rolling. Full body recovery.', 'image': 'assets/images/image002.jpg', 'calories': 35},
      ],
      'Marathon Training': [
        {'title': 'Dynamic Warm-up', 'duration': '10 min', 'reps': 'Activation', 'description': 'Leg swings, walking lunges, high knees. Prepare for long run.', 'image': 'assets/images/image004.jpg', 'calories': 50},
        {'title': 'Easy Pace Run', 'duration': '15 min', 'reps': 'Zone 2', 'description': 'Comfortable conversational pace. Find your rhythm. Settle in.', 'image': 'assets/images/image005.jpg', 'calories': 150},
        {'title': 'Tempo Segment', 'duration': '20 min', 'reps': 'Steady effort', 'description': 'Comfortably hard pace. Hold consistent speed. Mental toughness.', 'image': 'assets/images/image001.jpg', 'calories': 220},
        {'title': 'Recovery Jog', 'duration': '10 min', 'reps': 'Easy', 'description': 'Bring pace down. Active recovery. Maintain form.', 'image': 'assets/images/image002.jpg', 'calories': 95},
        {'title': 'Cool Down', 'duration': '5 min', 'reps': 'Walk & stretch', 'description': 'Walk it out. Full leg stretching routine. Hydrate well.', 'image': 'assets/images/image003.jpg', 'calories': 35},
      ],
      'Elite Athlete Circuit': [
        {'title': 'Athletic Warm-up', 'duration': '8 min', 'reps': 'Sport specific', 'description': 'Plyometric drills, agility ladder, dynamic stretching. Peak performance prep.', 'image': 'assets/images/image005.jpg', 'calories': 60},
        {'title': 'Power Cleans', 'duration': '10 min', 'reps': '5 sets x 3', 'description': 'Olympic lift. Explosive power. Full body coordination. Technical excellence.', 'image': 'assets/images/image001.jpg', 'calories': 95},
        {'title': 'Depth Jumps', 'duration': '8 min', 'reps': '5 sets x 5', 'description': 'Drop from box, absorb, explode up. Reactive strength. Maximum power output.', 'image': 'assets/images/image002.jpg', 'calories': 70},
        {'title': 'Medicine Ball Slams', 'duration': '7 min', 'reps': '4 sets x 12', 'description': 'Overhead to ground with force. Core power. Explosive triple extension.', 'image': 'assets/images/image003.jpg', 'calories': 85},
        {'title': 'Agility Drills', 'duration': '10 min', 'reps': '6 sets', 'description': 'Cone drills, shuttle runs, lateral movement. Speed and change of direction.', 'image': 'assets/images/image004.jpg', 'calories': 120},
        {'title': 'Sprint Work', 'duration': '7 min', 'reps': '6 x 40m', 'description': 'Acceleration work. Maximum velocity. Full recovery between sprints.', 'image': 'assets/images/image005.jpg', 'calories': 90},
        {'title': 'Cool Down', 'duration': '10 min', 'reps': 'Complete recovery', 'description': 'Light jog, comprehensive stretching, breathwork. Optimize recovery.', 'image': 'assets/images/image001.jpg', 'calories': 40},
      ],
      'Powerlifting Session': [
        {'title': 'Mobility & Activation', 'duration': '10 min', 'reps': 'Joint prep', 'description': 'Hip circles, shoulder dislocations, band work. Prime for heavy lifts.', 'image': 'assets/images/image002.jpg', 'calories': 45},
        {'title': 'Squat Warm-up', 'duration': '10 min', 'reps': 'Progressive', 'description': 'Bar x 10, 135x8, 225x5, 275x3, 315x2. Work up to training weight.', 'image': 'assets/images/image003.jpg', 'calories': 70},
        {'title': 'Heavy Squats', 'duration': '18 min', 'reps': '6 sets x 3', 'description': '85-90% 1RM. Competition depth. Long rest. Maximum strength work.', 'image': 'assets/images/image004.jpg', 'calories': 140},
        {'title': 'Bench Warm-up', 'duration': '8 min', 'reps': 'Work up', 'description': 'Progressive loading. Dial in form. Touch and press groove.', 'image': 'assets/images/image005.jpg', 'calories': 50},
        {'title': 'Heavy Bench', 'duration': '15 min', 'reps': '5 sets x 3', 'description': 'Heavy triples. Paused reps. Competition commands. Build pressing power.', 'image': 'assets/images/image001.jpg', 'calories': 110},
        {'title': 'Accessory Work', 'duration': '12 min', 'reps': 'Volume', 'description': 'Front squats, close grip bench, rows. Support main lifts. Hypertrophy.', 'image': 'assets/images/image002.jpg', 'calories': 90},
        {'title': 'Cool Down', 'duration': '12 min', 'reps': 'Recovery protocol', 'description': 'Extensive stretching, foam rolling, mobility work. Recovery is training.', 'image': 'assets/images/image003.jpg', 'calories': 45},
      ],
    };

    return workoutPlans[widget.exercise.title] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final workoutSteps = _workoutSteps;
    final totalSteps = workoutSteps.length;
    
    if (totalSteps == 0) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.exercise.title)),
        body: Center(child: Text('No workout plan available')),
      );
    }
    
    final progress = (_currentStep + 1) / totalSteps;
    final currentExercise = workoutSteps[_currentStep];
    final totalCalories = workoutSteps.fold<int>(0, (sum, step) => sum + (step['calories'] as int));

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          // App Bar with Hero Image
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: theme.colorScheme.primary,
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back, color: Colors.white),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Hero(
                    tag: widget.tag,
                    child: Image.asset(
                      widget.exercise.image,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    left: 20,
                    right: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFF10B981),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            widget.exercise.difficult,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.exercise.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Column(
              children: [
                const SizedBox(height: 20),

                // Stats Cards
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      _statCard(
                        theme,
                        icon: Icons.access_time,
                        label: 'Duration',
                        value: widget.exercise.time,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 12),
                      _statCard(
                        theme,
                        icon: Icons.local_fire_department,
                        label: 'Calories',
                        value: '$totalCalories kCal',
                        color: const Color(0xFFEF4444),
                      ),
                      const SizedBox(width: 12),
                      _statCard(
                        theme,
                        icon: Icons.fitness_center,
                        label: 'Exercises',
                        value: '$totalSteps',
                        color: theme.colorScheme.secondary,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                // Progress Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Workout Progress',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            '${_currentStep + 1}/$totalSteps',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: progress,
                          backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                          valueColor: AlwaysStoppedAnimation(theme.colorScheme.primary),
                          minHeight: 8,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                // Current Exercise Card
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          theme.colorScheme.primary,
                          theme.colorScheme.primary.withOpacity(0.8),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: theme.colorScheme.primary.withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text(
                                'CURRENT',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          currentExercise['title'],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            _currentExerciseStat(
                              Icons.access_time,
                              currentExercise['duration'],
                            ),
                            const SizedBox(width: 20),
                            _currentExerciseStat(
                              Icons.repeat,
                              currentExercise['reps'],
                            ),
                            const SizedBox(width: 20),
                            _currentExerciseStat(
                              Icons.local_fire_department,
                              '${currentExercise['calories']} cal',
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          currentExercise['description'],
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.95),
                            fontSize: 14,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 28),

                // All Steps List
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Exercise Sequence',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ...List.generate(workoutSteps.length, (index) {
                        return _exerciseStepCard(
                          theme,
                          index,
                          workoutSteps[index],
                          index == _currentStep,
                          index < _currentStep,
                        );
                      }),
                    ],
                  ),
                ),

                const SizedBox(height: 100),
              ],
            ),
          ),
        ],
      ),

      // Bottom Action Button
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: Row(
            children: [
              if (_currentStep > 0)
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        _currentStep = (_currentStep - 1).clamp(0, totalSteps - 1);
                      });
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: BorderSide(color: theme.colorScheme.primary, width: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      'Previous',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                ),
              if (_currentStep > 0) const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: () {
                    if (_currentStep < totalSteps - 1) {
                      setState(() {
                        _currentStep++;
                      });
                    } else {
                      // Workout completed
                      _showCompletionDialog();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _currentStep < totalSteps - 1 ? 'Next Exercise' : 'Complete Workout',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_forward, color: Colors.white, size: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statCard(
    ThemeData theme, {
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              value,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.textTheme.bodySmall?.color?.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _currentExerciseStat(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.white.withOpacity(0.9), size: 16),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _exerciseStepCard(
    ThemeData theme,
    int index,
    Map<String, dynamic> step,
    bool isCurrent,
    bool isCompleted,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isCurrent
            ? theme.colorScheme.primary.withOpacity(0.1)
            : theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: isCurrent
            ? Border.all(color: theme.colorScheme.primary, width: 2)
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Step Number/Status
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isCompleted
                  ? const Color(0xFF10B981)
                  : isCurrent
                      ? theme.colorScheme.primary
                      : theme.colorScheme.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: isCompleted
                  ? const Icon(Icons.check, color: Colors.white, size: 20)
                  : Text(
                      '${index + 1}',
                      style: TextStyle(
                        color: isCurrent ? Colors.white : theme.colorScheme.primary,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
            ),
          ),
          const SizedBox(width: 16),

          // Exercise Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  step['title'],
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: isCurrent
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 14,
                      color: theme.textTheme.bodySmall?.color,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      step['duration'],
                      style: theme.textTheme.bodySmall,
                    ),
                    const SizedBox(width: 16),
                    Icon(
                      Icons.repeat,
                      size: 14,
                      color: theme.textTheme.bodySmall?.color,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      step['reps'],
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Status Icon
          if (isCurrent)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Active',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _showCompletionDialog() {
    final theme = Theme.of(context);
    final totalCalories = _workoutSteps.fold<int>(0, (sum, step) => sum + (step['calories'] as int));
    final totalMinutes = int.tryParse(widget.exercise.time.replaceAll(RegExp(r'[^0-9]'), '')) ?? 10;
    
    // Save workout completion
    _trackingService.saveWorkoutCompletion(
      WorkoutCompletion(
        workoutTitle: widget.exercise.title,
        completedAt: DateTime.now(),
        caloriesBurned: totalCalories,
        durationMinutes: totalMinutes,
      ),
    );
    
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.celebration,
                  size: 60,
                  color: Color(0xFF10B981),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Workout Complete!',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Great job completing ${widget.exercise.title}! You burned approximately $totalCalories calories.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.textTheme.bodySmall?.color,
                ),
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Close dialog
                    Navigator.pop(context); // Go back to workouts
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Done',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
