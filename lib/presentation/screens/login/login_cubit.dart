import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/configuration.dart';
import 'package:shared_advisor_interface/data/cache/cache_manager.dart';
import 'package:shared_advisor_interface/data/network/responses/login_response.dart';
import 'package:shared_advisor_interface/domain/repositories/auth_repository.dart';
import 'package:shared_advisor_interface/extensions.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/presentation/resources/app_routes.dart';
import 'package:shared_advisor_interface/presentation/screens/login/login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepository _repository;
  final CacheManager _cacheManager;

  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  final FocusNode passwordNode = FocusNode();

  LoginCubit(this._repository, this._cacheManager) : super(const LoginState()) {
    final List<Brand> unauthorizedBrands =
        _cacheManager.getUnauthorizedBrands();
    final Brand? newSelectedBrand = Get.arguments;

    emit(state.copyWith(
      unauthorizedBrands: unauthorizedBrands,
      selectedBrand: newSelectedBrand ?? unauthorizedBrands.first,
    ));


    emailController.addListener(() {
      emit(state.copyWith(
        email: emailController.text,
        errorMessage: '',
        successMessage: '',
        showOpenEmailButton: false,
      ));
    });
    passwordController.addListener(() {
      emit(state.copyWith(
        password: passwordController.text,
        errorMessage: '',
        successMessage: '',
        showOpenEmailButton: false,
      ));
    });
  }

  void setSelectedBrand(Brand brand) {
    emit(state.copyWith(selectedBrand: brand));
  }

  void showHidePassword() {
    emit(state.copyWith(hiddenPassword: !state.hiddenPassword));
  }

  void clearErrorMessage() {
    if (state.errorMessage.isNotEmpty) {
      emit(state.copyWith(errorMessage: ''));
    }
  }

  void clearSuccessMessage() {
    if (state.successMessage.isNotEmpty) {
      emit(state.copyWith(
        successMessage: '',
        showOpenEmailButton: false,
      ));
    }
  }

  Future<void> login(BuildContext context) async {
    if (emailIsValid() && passwordIsValid()) {
      Get.find<Dio>().options.headers['Authorization'] =
          'Basic ${base64.encode(utf8.encode('${state.email}:${state.password.to256}'))}';
      try {
        LoginResponse? response = await _repository.login();
        String? token = response?.accessToken;
        if (token != null && token.isNotEmpty) {
          String jvtToken = 'JWT $token';
          await _cacheManager.saveTokenForBrand(state.selectedBrand, jvtToken);
          Get.find<Dio>().options.headers['Authorization'] = jvtToken;
          _cacheManager.saveCurrentBrand(state.selectedBrand);
          goToHome();
        }
      } on DioError catch (e) {
        if (e.response?.statusCode != 401) {
          emit(
            state.copyWith(
              errorMessage: e.response?.data['status'] ?? '',
            ),
          );
        } else {
          state.copyWith(
            errorMessage: S.of(context).wrongUsernameOrPassword,
          );
        }
      }
    }
  }

  void setSuccessMessage(BuildContext context, {bool showEmailButton = false}) {
    if (state.successMessage.isEmpty) {
      emit(state.copyWith(
        successMessage: S
            .of(context)
            .youHaveSuccessfullyChangedYourPasswordCheckYourEmailTo,
        showOpenEmailButton: showEmailButton,
      ));
    }
  }

  void goToHome() {
    Get.offNamedUntil(AppRoutes.home, (_) => false);
  }

  void goToForgotPassword() {
    Get.toNamed(AppRoutes.forgotPassword, arguments: state.selectedBrand);
  }

  bool emailIsValid() => GetUtils.isEmail(state.email);

  bool passwordIsValid() => state.password.length >= 8;
}

// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:shared_advisor_interface/domain/repositories/auth_repository.dart';
//
// @injectable
// class LoginCubit extends Cubit<LoginStateState> {
//   final AuthRepository _authRepository;
//
//   late final StreamSubscription _checksAmountSubscription;
//   late final StreamSubscription _connectivitySubscription;
//   ConnectivityResult _connectivityStatus = ConnectivityResult.none;
//
//   CheckAddressCubit(this._checkAddressRepository, this._walletNetworkValidator, this._authRepository)
//       : super(const CheckAddressState()) {
//     _checksAmountSubscription = _checkAddressRepository.checksAmount.listen((event) {
//       emit(state.copyWith(remainingChecks: event));
//     });
//     _connectivitySubscription = Connectivity().onConnectivityChanged.listen((result) {
//       _connectivityStatus = result;
//     });
//   }
//
//   void pasteAddress() {
//     FlutterClipboard.paste().then(_pasteAddress);
//   }
//
//   void clearInputAddress() => emit(state.copyWith(hash: null, error: null));
//
//   void checkAddress() async {
//     if (_connectivityStatus == ConnectivityResult.none) {
//       return emit(state.copyWith(error: const NetworkConnectionError()));
//     }
//     if (state.remainingChecks == 0) {
//       return emit(state.copyWith(error: const EmptyBalanceError()));
//     }
//     if (state.loading) {
//       return;
//     }
//     if (state.hash != null && state.network != null) {
//       emit(state.copyWith(loading: true, error: null));
//       final result = await Future.wait([
//         _checkAddressRepository.verifyAddress(state.hash!, state.network!.toAsset()),
//         Future.delayed(AppConstants.totalProgressAnimationDuration)
//       ]);
//       var data = (result.first as NetworkBoundary<WalletDetails>).data;
//       var error = (result.first as NetworkBoundary<WalletDetails>).error;
//       if (data != null) {
//         emit(state.copyWith(data: data));
//       } else {
//         emit(state.copyWith(loading: false, error: error));
//       }
//     } else {
//       emit(state.copyWith(error: const AddressOrNetworkError()));
//     }
//   }
//
//   void onNetworkChanged(Network network) {
//     emit(state.copyWith(network: network));
//   }
//
//   void resetData() {
//     emit(state.copyWith(data: null, loading: false));
//   }
//
//   void onCodeScanned(String address) {
//     _pasteAddress(address);
//   }
//
//   void _pasteAddress(String value) {
//     var trimmedValue = value.trim();
//     if (trimmedValue.isNotEmpty) {
//       Network? network = _walletNetworkValidator.getNetwork(trimmedValue);
//       if (network != null) {
//         emit(state.copyWith(hash: trimmedValue, error: null, network: network));
//       } else {
//         emit(state.copyWith(hash: trimmedValue, error: NotWalletAddressError(), network: null));
//       }
//     }
//   }
//
//   @override
//   Future<void> close() {
//     _checksAmountSubscription.cancel();
//     _connectivitySubscription.cancel();
//     return super.close();
//   }
//
//   Future<void> refreshChecks() async {
//     final completer = Completer();
//     try {
//       await _authRepository.authorize();
//     } finally {
//       completer.complete();
//     }
//     return completer.future;
//   }
//
//   void errorHandled() {
//     emit(state.copyWith(error: null));
//   }
//
//   Future<void> loadPlans(List<Plan>? plans) async {
//     if (plans?.isNotEmpty == true) {
//       return emit(state.copyWith(plans: plans));
//     }
//     if (state.plans != null) {
//       return;
//     }
//     try {
//       final result = await _checkAddressRepository.getPlans();
//       emit(state.copyWith(plans: result));
//     } on AppError catch (e) {
//       emit(state.copyWith(error: e));
//     }
//   }
// }
