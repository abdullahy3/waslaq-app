import 'package:cached_network_image/cached_network_image.dart';
import '../../core/auth/auth_notifier.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../router/app_router.dart';
import '../../shared/theme/app_colors.dart';
import '../../i18n/strings.g.dart';
import '../../features/messages/providers/stream_chat_provider.dart';
import 'context_aware_scaffold.dart';

@RoutePage(name: 'Shell')
class AppShellPage extends ConsumerWidget {
  const AppShellPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Translations.of(context);
    // Keep Stream Chat connection active as long as the user is authenticated
    ref.watch(streamChatConnectionProvider);
    final client = ref.watch(streamChatClientProvider);

    final authState = ref.watch(authNotifierProvider);
    final avatarUrl = authState.maybeWhen(
      authenticated: (_, __, ___, url, ____) => url,
      orElse: () => null,
    );
    final avatarLetter = authState.maybeWhen(
      authenticated: (_, email, displayName, __, ___) {
        final name = (displayName?.isNotEmpty == true) ? displayName! : email.split('@').first;
        return name[0].toUpperCase();
      },
      orElse: () => null,
    );

    return AutoTabsRouter(
      routes: const [
        HomeRoute(),
        ExploreRoute(),
        MessagesRoute(),
        AccountRoute(),
      ],
      builder: (context, child) {
        final tabsRouter = AutoTabsRouter.of(context);
        return Scaffold(
          body: child,
          floatingActionButton: (tabsRouter.activeIndex == 0 || tabsRouter.activeIndex == 1)
              ? const WaslaqFAB()
              : null,
          floatingActionButtonLocation: Directionality.of(context) == TextDirection.rtl
              ? const _CustomFABLocation(FloatingActionButtonLocation.startFloat, offsetY: 12.0)
              : const _CustomFABLocation(FloatingActionButtonLocation.endFloat, offsetY: 12.0),
          bottomNavigationBar: DecoratedBox(
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: context.colors.border, width: 0.5)),
            ),
            child: BottomNavigationBar(
              backgroundColor: context.colors.background,
              selectedItemColor: context.colors.primary,
              unselectedItemColor: context.colors.textSecondary,
              type: BottomNavigationBarType.fixed,
              elevation: 0,
              selectedFontSize: 12,
              unselectedFontSize: 12,
              currentIndex: tabsRouter.activeIndex,
              onTap: (index) => tabsRouter.setActiveIndex(index),
              items: [
                BottomNavigationBarItem(
                  icon: const Icon(Icons.home_outlined),
                  activeIcon: const Icon(Icons.home),
                  label: t.nav.home,
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.grid_view_outlined),
                  activeIcon: const Icon(Icons.grid_view),
                  label: t.nav.explore,
                ),
                BottomNavigationBarItem(
                  icon: StreamBuilder<int>(
                    stream: client.state.unreadChannelsStream,
                    initialData: client.state.unreadChannels,
                    builder: (context, snapshot) {
                      final unreadCount = snapshot.data ?? 0;
                      return Badge(
                        isLabelVisible: unreadCount > 0,
                        label: Text('$unreadCount'),
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        child: const Icon(Icons.chat_bubble_outline),
                      );
                    },
                  ),
                  activeIcon: StreamBuilder<int>(
                    stream: client.state.unreadChannelsStream,
                    initialData: client.state.unreadChannels,
                    builder: (context, snapshot) {
                      final unreadCount = snapshot.data ?? 0;
                      return Badge(
                        isLabelVisible: unreadCount > 0,
                        label: Text('$unreadCount'),
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        child: const Icon(Icons.chat_bubble),
                      );
                    },
                  ),
                  label: t.nav.messages,
                ),
                BottomNavigationBarItem(
                  icon: _AccountTabIcon(avatarUrl: avatarUrl, letter: avatarLetter, isActive: false),
                  activeIcon: _AccountTabIcon(avatarUrl: avatarUrl, letter: avatarLetter, isActive: true),
                  label: t.nav.account,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _AccountTabIcon extends StatelessWidget {
  final String? avatarUrl;
  final String? letter;
  final bool isActive;

  const _AccountTabIcon({
    this.avatarUrl,
    this.letter,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    if (letter == null) {
      return Icon(isActive ? Icons.person : Icons.person_outline);
    }
    return Container(
      width: 26,
      height: 26,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isActive ? context.colors.primary : context.colors.border,
          width: isActive ? 2.0 : 1.0,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(13),
        child: avatarUrl != null && avatarUrl!.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: avatarUrl!,
                // ponytail: 26dp icon was decoding the full-size avatar; cap the texture
                memCacheWidth: 80,
                fit: BoxFit.cover,
                width: 26,
                height: 26,
                errorWidget: (_, __, ___) => _letterAvatar(context),
              )
            : _letterAvatar(context),
      ),
    );
  }

  Widget _letterAvatar(BuildContext context) => CircleAvatar(
        radius: 13,
        backgroundColor: context.colors.primary,
        child: Text(
          letter!,
          style: const TextStyle(
              color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
        ),
      );
}

class _CustomFABLocation extends FloatingActionButtonLocation {
  final FloatingActionButtonLocation base;
  final double offsetY;

  const _CustomFABLocation(this.base, {this.offsetY = 0});

  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    final Offset offset = base.getOffset(scaffoldGeometry);
    return Offset(offset.dx, offset.dy + offsetY);
  }
}

