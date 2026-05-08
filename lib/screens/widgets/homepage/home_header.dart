import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'package:habit_tracker/adhelper.dart';

class HomeHeader extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const HomeHeader({super.key, required this.scaffoldKey});

  @override
  State<HomeHeader> createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader> {
  BannerAd? _bannerAd;
  void _loadBannerAd() {
    if (Adhelper.areAdsDisabled()) return;

    _bannerAd = BannerAd(
      adUnitId: Adhelper.bannerAdUnitId,
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          if (mounted) {
            setState(() {
              _bannerAd = ad as BannerAd;
            });
          }
        },
        onAdFailedToLoad: (ad, error) {
          debugPrint(
              "Failed to load banner ad: ${error.message} (Code: ${error.code})");
          ad.dispose();
          if (mounted) {
            setState(() {
              _bannerAd = null;
            });
          }
        },
      ),
      request: const AdRequest(),
    )..load();
  }

  @override
  void initState() {
    super.initState();
    _loadBannerAd();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'HabitFlow.',
            style: TextStyle(
              fontSize: 24, // Updated to match Swift spec
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: -0.5,
            ),
          ),
          Row(
            children: [
              Container(
                width: 40, // Updated to match Swift spec
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.11), // 0.11 from Swift spec
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withOpacity(0.1),
                    width: 1,
                  ),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(
                      Icons.notifications_none_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                    Positioned(
                      top: 10,
                      right: 10,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Color(0xFFFFD700), // Gold/Yellow from screenshot
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Container(
                width: 40, // Updated to match Swift spec
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.11),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withOpacity(0.1),
                    width: 1,
                  ),
                ),
                child: const Center(
                  child: Text(
                    'JB',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
