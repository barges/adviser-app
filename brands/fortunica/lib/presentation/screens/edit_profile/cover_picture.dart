import 'dart:io';

abstract class CoverPicture{}

class NetworkCoverPicture extends CoverPicture{
  final String imageUrl;

  NetworkCoverPicture(this.imageUrl);
}

class FileCoverPicture extends CoverPicture{
  final File imageFile;

  FileCoverPicture(this.imageFile);
}