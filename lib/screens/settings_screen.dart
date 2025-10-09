import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/settings_provider.dart';
import '../widgets/modern_notification.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  late TextEditingController _vatController;
  late TextEditingController _discountController;
  bool _isDiscountPercentage = true;

  @override
  void initState() {
    super.initState();
    _vatController = TextEditingController();
    _discountController = TextEditingController();
  }

  @override
  void dispose() {
    _vatController.dispose();
    _discountController.dispose();
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
}