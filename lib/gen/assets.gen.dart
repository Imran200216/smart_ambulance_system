/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/widgets.dart';

class $AssetsColorGen {
  const $AssetsColorGen();

  /// File path: assets/color/app_colors.xml
  String get appColors => 'assets/color/app_colors.xml';

  /// List of all assets
  List<String> get values => [appColors];
}

class $AssetsIconGen {
  const $AssetsIconGen();

  /// Directory path: assets/icon/svg
  $AssetsIconSvgGen get svg => const $AssetsIconSvgGen();
}

class $AssetsImgGen {
  const $AssetsImgGen();

  /// Directory path: assets/img/jpg
  $AssetsImgJpgGen get jpg => const $AssetsImgJpgGen();

  /// Directory path: assets/img/svg
  $AssetsImgSvgGen get svg => const $AssetsImgSvgGen();
}

class $AssetsIconSvgGen {
  const $AssetsIconSvgGen();

  /// File path: assets/icon/svg/Call.svg
  String get call => 'assets/icon/svg/Call.svg';

  /// File path: assets/icon/svg/Image.svg
  String get image => 'assets/icon/svg/Image.svg';

  /// File path: assets/icon/svg/Logout-Rounded.svg
  String get logoutRounded => 'assets/icon/svg/Logout-Rounded.svg';

  /// File path: assets/icon/svg/Profile.svg
  String get profile => 'assets/icon/svg/Profile.svg';

  /// File path: assets/icon/svg/back.svg
  String get back => 'assets/icon/svg/back.svg';

  /// File path: assets/icon/svg/email.svg
  String get email => 'assets/icon/svg/email.svg';

  /// File path: assets/icon/svg/login.svg
  String get login => 'assets/icon/svg/login.svg';

  /// File path: assets/icon/svg/password.svg
  String get password => 'assets/icon/svg/password.svg';

  /// File path: assets/icon/svg/splash.svg
  String get splash => 'assets/icon/svg/splash.svg';

  /// List of all assets
  List<String> get values => [
    call,
    image,
    logoutRounded,
    profile,
    back,
    email,
    login,
    password,
    splash,
  ];
}

class $AssetsImgJpgGen {
  const $AssetsImgJpgGen();

  /// File path: assets/img/jpg/img-placeholder.jpg
  AssetGenImage get imgPlaceholder =>
      const AssetGenImage('assets/img/jpg/img-placeholder.jpg');

  /// File path: assets/img/jpg/profile-placeholder.jpg
  AssetGenImage get profilePlaceholder =>
      const AssetGenImage('assets/img/jpg/profile-placeholder.jpg');

  /// List of all assets
  List<AssetGenImage> get values => [imgPlaceholder, profilePlaceholder];
}

class $AssetsImgSvgGen {
  const $AssetsImgSvgGen();

  /// File path: assets/img/svg/forget-password.svg
  String get forgetPassword => 'assets/img/svg/forget-password.svg';

  /// File path: assets/img/svg/login.svg
  String get login => 'assets/img/svg/login.svg';

  /// File path: assets/img/svg/on-boarding-first.svg
  String get onBoardingFirst => 'assets/img/svg/on-boarding-first.svg';

  /// File path: assets/img/svg/on-boarding-second.svg
  String get onBoardingSecond => 'assets/img/svg/on-boarding-second.svg';

  /// File path: assets/img/svg/register.svg
  String get register => 'assets/img/svg/register.svg';

  /// List of all assets
  List<String> get values => [
    forgetPassword,
    login,
    onBoardingFirst,
    onBoardingSecond,
    register,
  ];
}

class Assets {
  const Assets._();

  static const $AssetsColorGen color = $AssetsColorGen();
  static const $AssetsIconGen icon = $AssetsIconGen();
  static const $AssetsImgGen img = $AssetsImgGen();
}

class AssetGenImage {
  const AssetGenImage(this._assetName, {this.size, this.flavors = const {}});

  final String _assetName;

  final Size? size;
  final Set<String> flavors;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = true,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.medium,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({AssetBundle? bundle, String? package}) {
    return AssetImage(_assetName, bundle: bundle, package: package);
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
