import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../data/models/user_model.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../../../core/constants/app_constants.dart';
import 'dart:convert';

final profileProvider = FutureProvider<UserModel?>((ref) async {
  final storage = SecureStorage();
  final userJson = await storage.read(key: AppConstants.userProfileKey);
  if (userJson == null) return null;
  try {
    return UserModel.fromJson(jsonDecode(userJson) as Map<String, dynamic>);
  } catch (_) {
    return null;
  }
});
