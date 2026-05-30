// lib/shared/widgets/app_shell.dart

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../router/app_router.dart';
import '../../shared/theme/app_colors.dart';
import '../../i18n/strings.g.dart';
import '../../features/messages/providers/stream_chat_provider.dart';

@RoutePage(name: 'Shell')
class AppShellPage extends ConsumerWidget {
  const AppShellPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Translations.of(context);
    // Keep Stream Chat connection active as long as the user is authenticated
    ref.watch(streamChatConnectionProvider);
    final client = ref.watch(streamChatClientProvider);

    return AutoTabsRouter(
      routes: const [
        HomeRoute(),
        CategoriesRoute(),
        FeedRoute(),
        MessagesRoute(),
      ],
      builder: (context, child) {
        final tabsRouter = AutoTabsRouter.of(context);
        return Scaffold(
          body: child,
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
                  label: t.nav.category,
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.group_outlined),
                  activeIcon: const Icon(Icons.group),
                  label: t.nav.community,
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
              ],
            ),
          ),
        );
      },
    );
  }
}
