import 'dart:io';

class ProfileAvatarModel {
  final File? image;
  final int? brandId;

  const ProfileAvatarModel({
    this.brandId,
    this.image,
  });
}
