part of 'add_gallery_pictures_cubit.dart';

@freezed
class AddGalleryPicturesState with _$AddGalleryPicturesState {
  factory AddGalleryPicturesState({
    @Default([]) List<String> coverPictures,
  }) = _AddGalleryPicturesState;
}
