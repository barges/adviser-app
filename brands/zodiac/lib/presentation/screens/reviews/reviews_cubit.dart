import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/global.dart';
import 'package:zodiac/data/cache/zodiac_caching_manager.dart';
import 'package:zodiac/data/models/user_info/review_item_zodiac.dart';
import 'package:zodiac/data/network/requests/list_request.dart';
import 'package:zodiac/data/network/responses/reviews_response.dart';
import 'package:zodiac/domain/repositories/zodiac_user_repository.dart';
import 'package:zodiac/presentation/screens/reviews/reviews_state.dart';

class ReviewsCubit extends Cubit<ReviewsState> {
  final int _limit = 20;
  int _offset = 0;
  int? _count;
  bool _isLoading = false;
  final List<ZodiacReviewItem> _reviewList = [];
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  final ScrollController reviewScrollController = ScrollController();

  final ZodiacUserRepository _userRepository;
  final ZodiacCachingManager _zodiacCacheManager;

  ReviewsCubit(this._userRepository, this._zodiacCacheManager)
      : super(const ReviewsState()) {
    reviewScrollController.addListener(_scrollControllerListener);
    _loadData();
  }

  Future<void> _loadData() async {
    await _getReviews();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (reviewScrollController.hasClients) {
        _checkIfNeedAndLoadData();
      }
    });
  }

  void _scrollControllerListener() {
    _checkIfNeedAndLoadData();
  }

  void _checkIfNeedAndLoadData() {
    if (!_isLoading && reviewScrollController.position.extentAfter <= 200) {
      _getReviews();
    }
  }

  Future<void> _getReviews({bool refresh = false}) async {
    if (_count != null && _offset >= _count! && !refresh) {
      return;
    }

    try {
      _isLoading = true;
      int? expertId = _zodiacCacheManager.getUid();
      if (expertId != null) {
        if (refresh) {
          _reviewList.clear();
          _count = null;
          _offset = 0;
        }
        final reviewsRequest = ListRequest(count: _limit, offset: _offset);
        ReviewsResponse? response =
            await _userRepository.getReviews(reviewsRequest);
        List<ZodiacReviewItem>? result = response?.result ?? [];

        _count = response?.count ?? 0;
        _offset = _offset + _limit;

        _reviewList.addAll(result);

        emit(state.copyWith(
          reviewList: List.from(_reviewList),
        ));
      }
    } catch (e) {
      logger.d(e);
    } finally {
      _isLoading = false;
    }
  }

  Future<void> refreshReviews() async {
    _getReviews(refresh: true);
  }
}
