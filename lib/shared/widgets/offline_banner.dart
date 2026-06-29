// lib/shared/widgets/offline_banner.dart
// Global connectivity banner: red bar while offline, brief green bar on
// reconnect. Wraps the whole app tree (see main.dart MaterialApp.builder).

import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

import '../../i18n/strings.g.dart';
import '../theme/app_colors.dart';

class OfflineBanner extends StatefulWidget {
  final Widget child;
  const OfflineBanner({super.key, required this.child});

  @override
  State<OfflineBanner> createState() => _OfflineBannerState();
}

class _OfflineBannerState extends State<OfflineBanner> {
  StreamSubscription<List<ConnectivityResult>>? _sub;
  Timer? _backOnlineTimer;
  bool _offline = false;
  bool _showBackOnline = false;
  bool _everOffline = false;

  @override
  void initState() {
    super.initState();
    Connectivity().checkConnectivity().then(_update);
    _sub = Connectivity().onConnectivityChanged.listen(_update);
  }

  @override
  void dispose() {
    _sub?.cancel();
    _backOnlineTimer?.cancel();
    super.dispose();
  }

  void _update(List<ConnectivityResult> results) {
    // A VPN interface (e.g. Tailscale) stays "connected" even when wifi and
    // mobile data are both off — require a real transport to count as online.
    final offline = !results.any((r) =>
        r == ConnectivityResult.wifi ||
        r == ConnectivityResult.mobile ||
        r == ConnectivityResult.ethernet ||
        r == ConnectivityResult.bluetooth);
    if (offline == _offline || !mounted) return;
    setState(() {
      _offline = offline;
      if (offline) {
        _everOffline = true;
        _showBackOnline = false;
      } else if (_everOffline) {
        _showBackOnline = true;
      }
    });
    _backOnlineTimer?.cancel();
    if (!offline && _showBackOnline) {
      _backOnlineTimer = Timer(const Duration(seconds: 2), () {
        if (mounted) setState(() => _showBackOnline = false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final visible = _offline || _showBackOnline;
    return Stack(
      textDirection: TextDirection.ltr,
      children: [
        widget.child,
        if (visible)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Material(
              color: _offline ? context.colors.error : context.colors.success,
              child: SafeArea(
                bottom: false,
                child: Container(
                  height: 26,
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _offline ? Icons.wifi_off_rounded : Icons.wifi_rounded,
                        color: Colors.white,
                        size: 14,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        _offline ? t.errors.offline_banner : t.errors.back_online,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
