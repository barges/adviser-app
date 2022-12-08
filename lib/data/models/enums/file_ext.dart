enum FileExtantion {
  m4a,
  mp3,
}

extension CurrentFileExt on FileExtantion {
  static FileExtantion get current {
    return FileExtantion.m4a; //Platform.isIOS ? FileExt.m4a : FileExt.mp3;
  }
}
