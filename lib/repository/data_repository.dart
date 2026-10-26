import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/profile_model.dart';

class DataRepository {
  Future<ProfileModel> getProfile() async {
    final String response = await rootBundle.loadString('assets/data/profile.json');
    final data = await json.decode(response);
    return ProfileModel.fromJson(data);
  }

  // More methods can be added here for portfolio, research, skills etc.
}
