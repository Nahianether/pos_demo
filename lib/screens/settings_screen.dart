import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/settings_provider.dart';
import '../providers/api_pos_provider.dart';
import '../providers/pos_riverpod_provider.dart';
import '../services/api_service.dart';
import '../services/database_service.dart';
import '../widgets/modern_notification.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  late TextEditingController _vatController;
  late TextEditingController _discountController;
  late TextEditingController _apiUrlController;
  bool _isDiscountPercentage = true;

  @override
  void initState() {
    super.initState();
    _vatController = TextEditingController();
    _discountController = TextEditingController();
    _apiUrlController = TextEditingController(text: ApiService.baseUrl);
  }

  @override
  void dispose() {
    _vatController.dispose();
    _discountController.dispose();
    _apiUrlController.dispose();
    super.dispose();
  }

  void _initializeValues() {
    final settings = ref.read(settingsProvider);
    _vatController.text = settings.vatPercentage.toString();
    _discountController.text = _isDiscountPercentage
        ? settings.discountPercentage.toString()
        : settings.discountAmount.toString();
    _isDiscountPercentage = settings.isDiscountPercentage;
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);
    final theme = Theme.of(context);

    // Initialize values if not already done
    if (_vatController.text.isEmpty) {
      _initializeValues();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: theme.colorScheme.surface,
        foregroundColor: theme.colorScheme.onSurface,
        elevation: 0,
      ),
      body: ModernNotificationOverlay(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // API Settings
              _buildSection(
                title: 'API Configuration',
                icon: Icons.cloud,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                      Text(
                        'API Base URL',
                        style: theme.textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _apiUrlController,
                              decoration: InputDecoration(
                                hintText: 'http://localhost:3000/api',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton(
                            onPressed: _updateApiUrl,
                            child: const Text('Update'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          _buildQuickActionChip(
                            label: 'Localhost',
                            onPressed: () {
                              _apiUrlController.text = ApiService.localhost;
                              _updateApiUrl();
                            },
                          ),
                          const SizedBox(width: 8),
                          _buildQuickActionChip(
                            label: 'Android Emulator',
                            onPressed: () {
                              _apiUrlController.text = ApiService.androidEmulator;
                              _updateApiUrl();
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Connection Status
                      FutureBuilder<bool>(
                        future: ApiService.checkConnection(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Row(
                              children: [
                                SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                ),
                                SizedBox(width: 8),
                                Text('Checking connection...'),
                              ],
                            );
                          }

                          final isConnected = snapshot.data ?? false;
                          return Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isConnected
                                  ? Colors.green.withValues(alpha: 0.1)
                                  : Colors.red.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: isConnected ? Colors.green : Colors.red,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  isConnected ? Icons.check_circle : Icons.error,
                                  color: isConnected ? Colors.green : Colors.red,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    isConnected
                                        ? 'API Connected'
                                        : 'API Disconnected - Check URL and backend status',
                                    style: TextStyle(
                                      color: isConnected ? Colors.green : Colors.red,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // VAT Settings
              _buildSection(
                title: 'VAT Settings',
                icon: Icons.receipt_long,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'VAT Percentage',
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _vatController,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            decoration: InputDecoration(
                              hintText: 'Enter VAT percentage',
                              suffixText: '%',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: () => _updateVat(),
                          child: const Text('Update'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Current VAT: ${settings.vatPercentage.toStringAsFixed(1)}%',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Discount Settings
              _buildSection(
                title: 'Discount Settings',
                icon: Icons.local_offer,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Discount Type',
                          style: theme.textTheme.titleMedium,
                        ),
                        const Spacer(),
                        SegmentedButton<bool>(
                          segments: const [
                            ButtonSegment(value: true, label: Text('Percentage')),
                            ButtonSegment(value: false, label: Text('Fixed Amount')),
                          ],
                          selected: {_isDiscountPercentage},
                          onSelectionChanged: (Set<bool> selected) {
                            setState(() {
                              _isDiscountPercentage = selected.first;
                              _discountController.text = _isDiscountPercentage
                                  ? settings.discountPercentage.toString()
                                  : settings.discountAmount.toString();
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _discountController,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            decoration: InputDecoration(
                              hintText: _isDiscountPercentage ? 'Enter discount percentage' : 'Enter discount amount',
                              suffixText: _isDiscountPercentage ? '%' : '\$',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: () => _updateDiscount(),
                          child: const Text('Update'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _isDiscountPercentage
                          ? 'Current Discount: ${settings.discountPercentage.toStringAsFixed(1)}%'
                          : 'Current Discount: \$${settings.discountAmount.toStringAsFixed(2)}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Round Off Settings
              _buildSection(
                title: 'Round Off Settings',
                icon: Icons.rounded_corner,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SwitchListTile(
                      title: const Text('Enable Round Off'),
                      subtitle: const Text('Round final total to nearest whole number'),
                      value: settings.enableRoundOff,
                      onChanged: (value) {
                        ref.read(settingsProvider.notifier).setRoundOff(value);
                        NotificationHelpers.showInfo(
                          ref,
                          'Round off ${value ? 'enabled' : 'disabled'}',
                        );
                      },
                    ),
                    if (settings.enableRoundOff) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: theme.colorScheme.primary,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'When enabled, bills for friends will be rounded to the nearest whole number for convenience.',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Quick Actions
              _buildSection(
                title: 'Quick Actions',
                icon: Icons.flash_on,
                child: Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    _buildQuickActionChip(
                      label: 'Reset VAT (15%)',
                      onPressed: () {
                        _vatController.text = '15.0';
                        _updateVat();
                      },
                    ),
                    _buildQuickActionChip(
                      label: 'No Discount',
                      onPressed: () {
                        _discountController.text = '0.0';
                        _updateDiscount();
                      },
                    ),
                    _buildQuickActionChip(
                      label: '10% Discount',
                      onPressed: () {
                        setState(() {
                          _isDiscountPercentage = true;
                          _discountController.text = '10.0';
                        });
                        _updateDiscount();
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Data Management
              _buildSection(
                title: 'Data Management',
                icon: Icons.storage,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.orange.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.orange),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.warning, color: Colors.orange),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Clear all cached data including categories and products. Settings will be preserved.',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Colors.orange.shade900,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _clearAllData,
                        icon: const Icon(Icons.delete_sweep),
                        label: const Text('Clear All Cached Data'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: theme.colorScheme.primary),
              const SizedBox(width: 8),
              Text(
                title,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildQuickActionChip({
    required String label,
    required VoidCallback onPressed,
  }) {
    return ActionChip(
      label: Text(label),
      onPressed: onPressed,
      backgroundColor: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.5),
    );
  }

  void _updateVat() {
    final value = double.tryParse(_vatController.text);
    if (value != null && value >= 0 && value <= 100) {
      ref.read(settingsProvider.notifier).updateVat(value);
      NotificationHelpers.showSuccess(ref, 'VAT updated to ${value.toStringAsFixed(1)}%');
    } else {
      NotificationHelpers.showError(ref, 'Please enter a valid VAT percentage (0-100)');
    }
  }

  void _updateDiscount() {
    final value = double.tryParse(_discountController.text);
    if (value != null && value >= 0) {
      if (_isDiscountPercentage) {
        if (value <= 100) {
          ref.read(settingsProvider.notifier).updateDiscount(
            percentage: value,
            isPercentage: true,
          );
          NotificationHelpers.showSuccess(ref, 'Discount updated to ${value.toStringAsFixed(1)}%');
        } else {
          NotificationHelpers.showError(ref, 'Discount percentage cannot exceed 100%');
        }
      } else {
        ref.read(settingsProvider.notifier).updateDiscount(
          amount: value,
          isPercentage: false,
        );
        NotificationHelpers.showSuccess(ref, 'Discount updated to \$${value.toStringAsFixed(2)}');
      }
    } else {
      NotificationHelpers.showError(ref, 'Please enter a valid discount value');
    }
  }

  void _updateApiUrl() {
    final url = _apiUrlController.text.trim();
    if (url.isEmpty) {
      NotificationHelpers.showError(ref, 'Please enter a valid API URL');
      return;
    }

    try {
      // Validate URL format
      Uri.parse(url);

      // Update API base URL
      ref.read(setApiBaseUrlProvider)(url);

      NotificationHelpers.showSuccess(ref, 'API URL updated successfully');

      // Check connection
      setState(() {});
    } catch (e) {
      NotificationHelpers.showError(ref, 'Invalid URL format');
    }
  }

  Future<void> _clearAllData() async {
    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Data?'),
        content: const Text(
          'This will remove all cached categories, products, and cart items. '
          'Your settings will be preserved.\n\n'
          'This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Clear Data'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        // Clear all data from Hive
        await DatabaseService.clearAllData();

        // Clear the cart provider state
        ref.read(cartProvider.notifier).clearCart();

        if (mounted) {
          NotificationHelpers.showSuccess(
            ref,
            'All cached data has been cleared successfully. Please restart the app or fetch data from API.',
          );

          // Pop back to main screen
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          NotificationHelpers.showError(
            ref,
            'Failed to clear data: ${e.toString()}',
          );
        }
      }
    }
  }
}