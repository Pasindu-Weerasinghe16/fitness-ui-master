import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  const UserProfile({
    required this.uid,
    this.email,
    this.heightCm,
    this.weightKg,
    this.createdAt,
    this.updatedAt,
  });

  final String uid;
  final String? email;
  final num? heightCm;
  final num? weightKg;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  static UserProfile? fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snap) {
    final data = snap.data();
    if (data == null) return null;

    DateTime? toDateTime(dynamic value) {
      if (value is Timestamp) return value.toDate();
      return null;
    }

    return UserProfile(
      uid: snap.id,
      email: (data['email'] as String?)?.trim(),
      heightCm: data['heightCm'] as num?,
      weightKg: data['weightKg'] as num?,
      createdAt: toDateTime(data['createdAt']),
      updatedAt: toDateTime(data['updatedAt']),
    );
  }
}

class UserProfileService {
  UserProfileService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  DocumentReference<Map<String, dynamic>> _doc(String uid) {
    return _firestore.collection('users').doc(uid);
  }

  Stream<UserProfile?> watch(String uid) {
    return _doc(uid).snapshots().map(UserProfile.fromSnapshot);
  }

  Future<void> save({
    required String uid,
    String? email,
    num? heightCm,
    num? weightKg,
  }) async {
    final data = <String, Object?>{
      if (email != null) 'email': email.trim(),
      if (heightCm != null) 'heightCm': heightCm,
      if (weightKg != null) 'weightKg': weightKg,
      'updatedAt': FieldValue.serverTimestamp(),
    };

    try {
      await _doc(uid).update(data);
    } on FirebaseException catch (e) {
      if (e.code != 'not-found') rethrow;
      await _doc(uid).set(
        {
          ...data,
          'createdAt': FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true),
      );
    }
  }
}
