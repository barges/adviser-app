import 'package:flutter/widgets.dart';
import 'package:zodiac/presentation/screens/edit_profile/widgets/brands_part/brands_part_widget.dart';

class EditProfileBodyWidget extends StatelessWidget {
  const EditProfileBodyWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 16.0,
        ),
        BrandsPartWidget(),
      ],
    );
  }
}
