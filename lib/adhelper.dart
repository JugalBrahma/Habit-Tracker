import 'dart:io';
import 'package:hive_flutter/hive_flutter.dart';

class Adhelper {
  // Use true for development to confirm implementation works.
  // Use false for production once your AdMob account is ready and app is approved.
  static bool get isTestMode => true;

  static String get bannerAdUnitId {
    if (isTestMode) {
      return 'ca-app-pub-3940256099942544/6300978111'; // Google Test Banner ID
    }

    if (Platform.isAndroid) {
      return 'ca-app-pub-5818311240277823/4478160071';
    } else if (Platform.isIOS) {
      return '';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get rewardedAdUnitId {
    if (isTestMode) {
      return 'ca-app-pub-3940256099942544/5224354917'; // Google Test Rewarded ID
    }

    if (Platform.isAndroid) {
      return 'ca-app-pub-5818311240277823/4879030033';
    } else if (Platform.isIOS) {
      return '';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static const String _adPreferencesBox = 'adPreferences';
  static const String _adsDisabledUntilKey = 'adsDisabledUntil';

  static Future<void> disableAdsFor24Hours() async {
    final box = await Hive.openBox(_adPreferencesBox);
    final disabledUntil = DateTime.now().add(const Duration(hours: 24));
    await box.put(_adsDisabledUntilKey, disabledUntil.millisecondsSinceEpoch);
  }

  static bool areAdsDisabled() {
    return true; // Force disable for now as requested
    /*
    final box = Hive.box(_adPreferencesBox);
    final disabledUntilMs =
        box.get(_adsDisabledUntilKey, defaultValue: 0) as int;
    if (disabledUntilMs == 0) return false;

    final disabledUntil = DateTime.fromMillisecondsSinceEpoch(disabledUntilMs);
    return DateTime.now().isBefore(disabledUntil);
    */
  }

  static Future<void> initPreferences() async {
    await Hive.openBox(_adPreferencesBox);
  }
}
