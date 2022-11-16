import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'reviews_state.dart';
part 'reviews_cubit.freezed.dart';

class ReviewsCubit extends Cubit<ReviewsState> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  ReviewsCubit() : super(ReviewsState());
}
