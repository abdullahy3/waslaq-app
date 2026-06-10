// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stream_chat_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$streamChatClientHash() => r'185bae940575c17aedd51be37f3e0b846d5eb837';

/// Singleton StreamChatClient. Lives as long as the app.
/// keepAlive: true — never auto-disposed between screen navigations.
///
/// Copied from [streamChatClient].
@ProviderFor(streamChatClient)
final streamChatClientProvider = Provider<StreamChatClient>.internal(
  streamChatClient,
  name: r'streamChatClientProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$streamChatClientHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef StreamChatClientRef = ProviderRef<StreamChatClient>;
String _$streamChatConnectionHash() =>
    r'775027a1eee02a28f1be670b29c4c43e172c78ca';

/// Manages the connection state.
/// Re-runs whenever auth state changes — connects or disconnects accordingly.
///
/// Copied from [StreamChatConnection].
@ProviderFor(StreamChatConnection)
final streamChatConnectionProvider =
    AutoDisposeAsyncNotifierProvider<StreamChatConnection, bool>.internal(
  StreamChatConnection.new,
  name: r'streamChatConnectionProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$streamChatConnectionHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$StreamChatConnection = AutoDisposeAsyncNotifier<bool>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
