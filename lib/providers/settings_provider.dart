import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/settings_hive.dart';
import '../services/database_service.dart';
import 'pos_riverpod_provider.dart';
import 'api_pos_provider.dart';

// Settings Provider
final settingsProvider = StateNotifierProvider<SettingsNotifier, SettingsHive>((ref) {
  return SettingsNotifier();
});

class SettingsNotifier extends StateNotifier<SettingsHive> {
  SettingsNotifier() : super(SettingsHive(
    vatPercentage: 15.0,
    discountPercentage: 0.0,
    discountAmount: 0.0,
    isDiscountPercentage: true,
    enableRoundOff: false,
    lastUpdated: DateTime.now(),
    isApiMode: true, // Always use API mode
  )) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final settings = DatabaseService.getSettings();
    // Always ensure API mode is true
    state = SettingsHive(
      vatPercentage: settings.vatPercentage,
      discountPercentage: settings.discountPercentage,
      discountAmount: settings.discountAmount,
      isDiscountPercentage: settings.isDiscountPercentage,
      enableRoundOff: settings.enableRoundOff,
      lastUpdated: settings.lastUpdated,
      isApiMode: true, // Always use API mode
    );
  }

  Future<void> updateVat(double percentage) async {
    state = SettingsHive(
      vatPercentage: percentage,
      discountPercentage: state.discountPercentage,
      discountAmount: state.discountAmount,
      isDiscountPercentage: state.isDiscountPercentage,
      enableRoundOff: state.enableRoundOff,
      lastUpdated: DateTime.now(),
      isApiMode: true, // Always use API mode
    );
    await DatabaseService.saveSettings(state);
  }

  Future<void> updateDiscount({
    double? percentage,
    double? amount,
    bool? isPercentage,
  }) async {
    state = SettingsHive(
      vatPercentage: state.vatPercentage,
      discountPercentage: percentage ?? state.discountPercentage,
      discountAmount: amount ?? state.discountAmount,
      isDiscountPercentage: isPercentage ?? state.isDiscountPercentage,
      enableRoundOff: state.enableRoundOff,
      lastUpdated: DateTime.now(),
      isApiMode: true, // Always use API mode
    );
    await DatabaseService.saveSettings(state);
  }

  Future<void> toggleRoundOff() async {
    state = SettingsHive(
      vatPercentage: state.vatPercentage,
      discountPercentage: state.discountPercentage,
      discountAmount: state.discountAmount,
      isDiscountPercentage: state.isDiscountPercentage,
      enableRoundOff: !state.enableRoundOff,
      lastUpdated: DateTime.now(),
      isApiMode: true, // Always use API mode
    );
    await DatabaseService.saveSettings(state);
  }

  Future<void> setRoundOff(bool enabled) async {
    state = SettingsHive(
      vatPercentage: state.vatPercentage,
      discountPercentage: state.discountPercentage,
      discountAmount: state.discountAmount,
      isDiscountPercentage: state.isDiscountPercentage,
      enableRoundOff: enabled,
      lastUpdated: DateTime.now(),
      isApiMode: true, // Always use API mode
    );
    await DatabaseService.saveSettings(state);
  }
}

// Computed providers for cart calculations with settings
final cartSubtotalProvider = Provider<double>((ref) {
  final settings = ref.watch(settingsProvider);
  final cartItems = settings.isApiMode
      ? ref.watch(apiCartProvider).valueOrNull ?? []
      : ref.watch(cartProvider);
  return cartItems.fold(0.0, (sum, item) => sum + item.totalPrice);
});

final cartVatProvider = Provider<double>((ref) {
  final subtotal = ref.watch(cartSubtotalProvider);
  final settings = ref.watch(settingsProvider);
  return settings.calculateVat(subtotal);
});

final cartDiscountProvider = Provider<double>((ref) {
  final subtotal = ref.watch(cartSubtotalProvider);
  final settings = ref.watch(settingsProvider);
  return settings.calculateDiscount(subtotal);
});

final cartRoundOffProvider = Provider<double>((ref) {
  final subtotal = ref.watch(cartSubtotalProvider);
  final settings = ref.watch(settingsProvider);
  return settings.calculateRoundOffAdjustment(subtotal);
});

final cartFinalTotalProvider = Provider<double>((ref) {
  final subtotal = ref.watch(cartSubtotalProvider);
  final settings = ref.watch(settingsProvider);
  return settings.calculateTotal(subtotal);
});

