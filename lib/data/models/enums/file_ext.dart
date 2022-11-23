import 'dart:io';

enum FileExt {
  m4a,
  mp3,
}

extension CurrentFileExt on FileExt {
  static FileExt get current {
    return Platform.isIOS ? FileExt.m4a : FileExt.mp3;
  }
}
