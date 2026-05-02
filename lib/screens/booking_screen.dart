import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'payment_screen.dart';

class BookingScreen extends StatefulWidget {
  final String tutorName;
  final String subject;
  final double rating;
  final int pricePerHour;

  const BookingScreen({
    super.key,
    required this.tutorName,
    required this.subject,
    required this.rating,
    required this.pricePerHour,
  });

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  // Date options
  final List<String> dateOptions = ['Today', 'Tomorrow', 'This Weekend'];
  int selectedDateIndex = 0;

  // Time options
  final List<String> timeOptions = [
    '8:00 AM',
    '10:00 AM',
    '2:00 PM',
    '4:00 PM',
    '6:00 PM'
  ];
  int selectedTimeIndex = 0;

  // Duration options
  final List<int> durationOptions = [1, 2, 3];
  int selectedDurationIndex = 0;

  // Meeting type options
  final List<String> meetingOptions = ['Family Home', 'Tutor Place', 'Online'];
  int selectedMeetingIndex = 0;

  @override
  Widget build(BuildContext context) {
    // Calculate prices
    final hours = durationOptions[selectedDurationIndex];
    final subtotal = widget.pricePerHour * hours;
    final platformFee = (subtotal * 0.10).round();
    final total = subtotal + platformFee;

    return Scaffold(
      // AppBar
      appBar: AppBar(
        title: const Text('Book Tutor'),
        centerTitle: true,
      ),

      // Main body
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spacingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tutor Summary Card
            Container(
              padding: const EdgeInsets.all(AppTheme.spacingL),
              decoration: AppTheme.cardDecoration,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: AppTheme.avatarL,
                    backgroundColor: AppTheme.primaryBlue,
                    child: const Icon(
                      Icons.person,
                      size: AppTheme.iconL,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: AppTheme.spacingL),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.tutorName,
                          style: AppTheme.titleMedium,
                        ),
                        const SizedBox(height: AppTheme.spacingXS),
                        Text(
                          widget.subject,
                          style: AppTheme.bodyMedium,
                        ),
                        const SizedBox(height: AppTheme.spacingXS),
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              size: AppTheme.iconS,
                              color: AppTheme.ratingColor,
                            ),
                            const SizedBox(width: AppTheme.spacingXS),
                            Text(
                              '${widget.rating}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: AppTheme.spacingL),
                            Text(
                              'ETB ${widget.pricePerHour}/hr',
                              style: TextStyle(
                                color: AppTheme.primaryBlue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppTheme.spacingXL),

            // Date Selection
            const Text(
              'Select Date',
              style: AppTheme.titleSmall,
            ),
            const SizedBox(height: AppTheme.spacingM),
            Wrap(
              spacing: AppTheme.spacingS,
              children: List.generate(dateOptions.length, (index) {
                final isSelected = index == selectedDateIndex;
                return ChoiceChip(
                  label: Text(dateOptions[index]),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      selectedDateIndex = index;
                    });
                  },
                  selectedColor: AppTheme.primaryBlue.withValues(alpha: 0.2),
                  labelStyle: TextStyle(
                    color: isSelected
                        ? AppTheme.primaryBlue
                        : AppTheme.textSecondary,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                );
              }),
            ),

            const SizedBox(height: AppTheme.spacingXL),

            // Time Selection
            const Text(
              'Select Time',
              style: AppTheme.titleSmall,
            ),
            const SizedBox(height: AppTheme.spacingM),
            Wrap(
              spacing: AppTheme.spacingS,
              children: List.generate(timeOptions.length, (index) {
                final isSelected = index == selectedTimeIndex;
                return ChoiceChip(
                  label: Text(timeOptions[index]),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      selectedTimeIndex = index;
                    });
                  },
                  selectedColor: AppTheme.primaryBlue.withValues(alpha: 0.2),
                  labelStyle: TextStyle(
                    color: isSelected
                        ? AppTheme.primaryBlue
                        : AppTheme.textSecondary,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                );
              }),
            ),

            const SizedBox(height: 24),

            // Duration Selection
            const Text(
              'Select Duration',
              style: AppTheme.titleSmall,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: AppTheme.spacingS,
              children: List.generate(durationOptions.length, (index) {
                final isSelected = index == selectedDurationIndex;
                return ChoiceChip(
                  label: Text('${durationOptions[index]} Hour'),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      selectedDurationIndex = index;
                    });
                  },
                  selectedColor: AppTheme.primaryBlue.withValues(alpha: 0.2),
                  labelStyle: TextStyle(
                    color: isSelected
                        ? AppTheme.primaryBlue
                        : AppTheme.textSecondary,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                );
              }),
            ),

            const SizedBox(height: AppTheme.spacingXL),

            // Meeting Type
            const Text(
              'Meeting Type',
              style: AppTheme.titleSmall,
            ),
            const SizedBox(height: AppTheme.spacingM),
            Wrap(
              spacing: AppTheme.spacingS,
              children: List.generate(meetingOptions.length, (index) {
                final isSelected = index == selectedMeetingIndex;
                return ChoiceChip(
                  label: Text(meetingOptions[index]),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      selectedMeetingIndex = index;
                    });
                  },
                  selectedColor: AppTheme.primaryBlue.withValues(alpha: 0.2),
                  labelStyle: TextStyle(
                    color: isSelected
                        ? AppTheme.primaryBlue
                        : AppTheme.textSecondary,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                );
              }),
            ),

            const SizedBox(height: AppTheme.spacingXL),

            // Price Summary Box
            Container(
              padding: const EdgeInsets.all(AppTheme.spacingL),
              decoration: AppTheme.grayCardDecoration,
              child: Column(
                children: [
                  const Text(
                    'Price Summary',
                    style: AppTheme.titleSmall,
                  ),
                  const SizedBox(height: AppTheme.spacingM),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '$hours Hour${hours > 1 ? 's' : ''}',
                        style: AppTheme.bodyMedium,
                      ),
                      Text('ETB $subtotal'),
                    ],
                  ),
                  const SizedBox(height: AppTheme.spacingS),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Platform Fee (10%)',
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
                        'Total',
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

            // Confirm Booking Button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PaymentScreen(
                        tutorName: widget.tutorName,
                        subject: widget.subject,
                        selectedDate: dateOptions[selectedDateIndex],
                        selectedTime: timeOptions[selectedTimeIndex],
                        duration: durationOptions[selectedDurationIndex],
                        meetingType: meetingOptions[selectedMeetingIndex],
                        pricePerHour: widget.pricePerHour,
                        totalPrice: total,
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
                  'Confirm Booking',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}