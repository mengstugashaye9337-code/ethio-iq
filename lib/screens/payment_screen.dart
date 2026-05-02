import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class PaymentScreen extends StatefulWidget {
  final String tutorName;
  final String subject;
  final String selectedDate;
  final String selectedTime;
  final int duration;
  final String meetingType;
  final int pricePerHour;
  final int totalPrice;

  const PaymentScreen({
    super.key,
    required this.tutorName,
    required this.subject,
    required this.selectedDate,
    required this.selectedTime,
    required this.duration,
    required this.meetingType,
    required this.pricePerHour,
    required this.totalPrice,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  // Payment methods
  final List<Map<String, String>> paymentMethods = [
    {
      'id': 'cash',
      'name': 'Cash',
      'description': 'Pay at meeting',
      'icon': 'payments',
    },
    {
      'id': 'mobile',
      'name': 'Mobile Payment',
      'description': 'Coming soon',
      'icon': 'phone_android',
    },
    {
      'id': 'wallet',
      'name': 'Wallet',
      'description': 'Coming soon',
      'icon': 'account_balance_wallet',
    },
  ];

  int selectedPaymentIndex = 0;

  @override
  Widget build(BuildContext context) {
    // Calculate price breakdown
    final sessionPrice = widget.pricePerHour * widget.duration;
    final platformFee = (sessionPrice * 0.10).round();
    final total = sessionPrice + platformFee;

    return Scaffold(
      // AppBar
      appBar: AppBar(
        title: const Text('Payment'),
        centerTitle: true,
      ),

      // Main body
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spacingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Booking Summary Card
            Container(
              padding: const EdgeInsets.all(AppTheme.spacingL),
              decoration: AppTheme.cardDecoration,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Booking Summary',
                    style: AppTheme.titleMedium,
                  ),
                  const SizedBox(height: AppTheme.spacingL),
                  _buildSummaryRow('Tutor', widget.tutorName),
                  _buildSummaryRow('Subject', widget.subject),
                  _buildSummaryRow('Date', widget.selectedDate),
                  _buildSummaryRow('Time', widget.selectedTime),
                  _buildSummaryRow(
                      'Duration', '${widget.duration} hour${widget.duration > 1 ? 's' : ''}'),
                  _buildSummaryRow('Location', widget.meetingType),
                ],
              ),
            ),

            const SizedBox(height: AppTheme.spacingXL),

            // Price Breakdown Box
            Container(
              padding: const EdgeInsets.all(AppTheme.spacingL),
              decoration: AppTheme.grayCardDecoration,
              child: Column(
                children: [
                  const Text(
                    'Price Breakdown',
                    style: AppTheme.titleMedium,
                  ),
                  const SizedBox(height: AppTheme.spacingL),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Session Price:',
                        style: AppTheme.bodyMedium,
                      ),
                      Text('ETB $sessionPrice'),
                    ],
                  ),
                  const SizedBox(height: AppTheme.spacingS),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Platform Fee (10%):',
                        style: AppTheme.bodyMedium,
                      ),
                      Text('ETB $platformFee'),
                    ],
                  ),
                  const Divider(height: AppTheme.spacingXL),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total Payment:',
                        style: AppTheme.titleMedium,
                      ),
                      Text(
                        'ETB $total',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryBlue,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppTheme.spacingXL),

            // Payment Method Section
            const Text(
              'Payment Method',
              style: AppTheme.titleMedium,
            ),
            const SizedBox(height: AppTheme.spacingM),
            ...List.generate(paymentMethods.length, (index) {
              final method = paymentMethods[index];
              final isSelected = index == selectedPaymentIndex;
              final isDisabled = index > 0; // Only cash is available now

              return Padding(
                padding: const EdgeInsets.only(bottom: AppTheme.spacingS),
                child: InkWell(
                  onTap: isDisabled
                      ? null
                      : () {
                          setState(() {
                            selectedPaymentIndex = index;
                          });
                        },
                  child: Container(
                    padding: const EdgeInsets.all(AppTheme.spacingL),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppTheme.primaryBlue.withValues(alpha: 0.1)
                          : AppTheme.backgroundWhite,
                      borderRadius: BorderRadius.circular(AppTheme.radiusM),
                      border: Border.all(
                        color: isSelected
                            ? AppTheme.primaryBlue
                            : AppTheme.lightAccent,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          _getIcon(method['icon']!),
                          size: AppTheme.iconL,
                          color: isDisabled
                              ? AppTheme.textSecondary.withValues(alpha: 0.5)
                              : (isSelected
                                  ? AppTheme.primaryBlue
                                  : AppTheme.textSecondary),
                        ),
                        const SizedBox(width: AppTheme.spacingL),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                method['name']!,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: isDisabled
                                      ? AppTheme.textSecondary
                                          .withValues(alpha: 0.6)
                                      : AppTheme.textDark,
                                ),
                              ),
                              Text(
                                method['description']!,
                                style: AppTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                        if (isSelected)
                          Icon(
                            Icons.check_circle,
                            color: AppTheme.primaryBlue,
                          ),
                      ],
                    ),
                  ),
                ),
              );
            }),

            const SizedBox(height: 24),

            // Important Info Box
            Container(
              padding: const EdgeInsets.all(16),
              decoration: AppTheme.infoBoxDecoration,
              child: Row(
                children: [
                  Icon(
                    Icons.verified_user,
                    color: AppTheme.warningColor,
                    size: 32,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Your payment is protected by Ethio IQ until the session is completed.',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppTheme.textDark,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppTheme.spacingXL),

            // Confirm & Pay Button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  // Show confirmation message
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text(
                        'Payment successful! Your booking is confirmed.',
                      ),
                      backgroundColor: AppTheme.primaryBlue,
                      action: SnackBarAction(
                        label: 'OK',
                        textColor: Colors.white,
                        onPressed: () {
                          // Navigate back to home
                          Navigator.popUntil(context, (route) => route.isFirst);
                        },
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryBlue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppTheme.radiusM),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Confirm & Pay',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: AppTheme.spacingL),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.spacingS),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTheme.bodyMedium,
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIcon(String iconName) {
    switch (iconName) {
      case 'payments':
        return Icons.payments;
      case 'phone_android':
        return Icons.phone_android;
      case 'account_balance_wallet':
        return Icons.account_balance_wallet;
      default:
        return Icons.payment;
    }
  }
}