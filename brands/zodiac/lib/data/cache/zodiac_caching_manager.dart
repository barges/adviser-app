import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fortunica/data/models/enums/fortunica_user_status.dart';
import 'package:fortunica/data/models/user_info/user_info.dart';
import 'package:fortunica/data/models/user_info/user_profile.dart';
import 'package:fortunica/data/models/user_info/user_status.dart';

abstract class ZodiacCachingManager {

  Future<void> saveUserToken(String userToken);

  String? getUserToken();

  Future<void> logout();

}
