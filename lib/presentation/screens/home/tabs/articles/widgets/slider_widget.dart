import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/extensions.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';
import 'package:shared_advisor_interface/presentation/screens/home/tabs/articles/articles_cubit.dart';

class SliderWidget extends StatelessWidget {
  const SliderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final int sliderIndex =
        context.select((ArticlesCubit cubit) => cubit.state.sliderIndex);
    final ArticlesCubit articlesCubit = context.read<ArticlesCubit>();

    //TODO -- remove it later..
    final List<_VirtualCourseModel> courses = [
      const _VirtualCourseModel(
          title: 'Online courses 1',
          description: 'This is the description of what is this about.',
          headlineTitle: 'Special events'),
      const _VirtualCourseModel(
          title: 'Online courses 2',
          description: 'This is the description of what is this about.',
          headlineTitle: 'Special events'),
      const _VirtualCourseModel(
          title: 'Online courses 3',
          description: 'This is the description of what is this about.',
          headlineTitle: 'Special events'),
      const _VirtualCourseModel(
          title: 'Online courses 4',
          description: 'This is the description of what is this about.',
          headlineTitle: 'Special events')
    ];
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 12.0),
      color: Theme.of(context).canvasColor,
      child: Column(
        children: [
          CarouselSlider.builder(
              itemCount: 4,
              itemBuilder: (_, index, __) => _CardWidget(
                    course: courses[index],
                  ),
              options: CarouselOptions(
                  height: 151,
                  disableCenter: true,
                  enableInfiniteScroll: false,
                  viewportFraction: 0.96,
                  initialPage: sliderIndex,
                  autoPlayInterval: const Duration(seconds: 3),
                  autoPlayAnimationDuration: const Duration(milliseconds: 800),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  scrollDirection: Axis.horizontal,
                  onPageChanged: (newIndex, _) =>
                      articlesCubit.updateSliderIndex(newIndex))),
          const SizedBox(height: 12.0),
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: courses
                  .mapIndexed((_, index) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: Builder(
                            builder: (_) => CircleAvatar(
                                radius: sliderIndex == index ? 6.0 : 4.0,
                                backgroundColor: sliderIndex == index
                                    ? Theme.of(context).primaryColor
                                    : Theme.of(context).hintColor)),
                      ))
                  .toList())
        ],
      ),
    );
  }
}

class _CardWidget extends StatelessWidget {
  final _VirtualCourseModel course;

  const _CardWidget({Key? key, required this.course}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 10.0),
      child: Stack(
        fit: StackFit.passthrough,
        children: [
          Assets.vectors.sliderBackground.svg(height: 151.0, fit: BoxFit.fill),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  course.title,
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium
                      ?.copyWith(color: Theme.of(context).backgroundColor),
                ),
                Text(course.description,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                    style: Theme.of(context)
                        .textTheme
                        .labelMedium
                        ?.copyWith(color: Theme.of(context).backgroundColor)),
              ],
            ),
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 12.0,
                    horizontal: AppConstants.horizontalScreenPadding),
                child: Text(
                  '#${course.headlineTitle}',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).backgroundColor),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

//TODO -- remove it later
class _VirtualCourseModel {
  final String title;
  final String description;
  final String headlineTitle;

  const _VirtualCourseModel(
      {required this.title,
      required this.description,
      required this.headlineTitle});
}
