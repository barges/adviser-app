import 'dart:io';

enum FileExt {
  m4a,
  mp3,
}

extension CurrentFileExt on FileExt {
  static FileExt get current {
    return FileExt.m4a; //Platform.isIOS ? FileExt.m4a : FileExt.mp3;
  }
}
