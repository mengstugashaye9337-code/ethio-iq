import 'package:flutter/material.dart';
import 'package:ethio_iq/core/theme/app_theme.dart';
import 'package:ethio_iq/features/bookings/data/booking_repository.dart';
import 'package:ethio_iq/core/models/booking_request.dart';

class BookingRequestForm extends StatefulWidget {
  final String subject;
  final bool isBeyondCurriculum;

  const BookingRequestForm({
    super.key,
    required this.subject,
    required this.isBeyondCurriculum,
  });

  @override
  State<BookingRequestForm> createState() => _BookingRequestFormState();
}

class _BookingRequestFormState extends State<BookingRequestForm> {
  final _gradeController = TextEditingController();
  final _studentNameController = TextEditingController();
  final _locationController = TextEditingController();
  final _instructionsController = TextEditingController();

  @override
  void dispose() {
    _gradeController.dispose();
    _studentNameController.dispose();
    _locationController.dispose();
    _instructionsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isBeyondCurriculum
              ? 'Request a Specialist'
              : 'Academic Support Request',
          style: AppTheme.titleMedium,
        ),
        backgroundColor: AppTheme.backgroundWhite,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.textDark),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: AppTheme.backgroundLight,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.paddingStandard),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.isBeyondCurriculum) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppTheme.paddingStandard),
                decoration: AppTheme.whiteCardDecoration,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Selected Track', style: AppTheme.bodySmall),
                    const SizedBox(height: AppTheme.spacingS),
                    Text(widget.subject, style: AppTheme.titleSmall),
                    const SizedBox(height: AppTheme.spacingS),
                    Text(
                      'This is a specialized track. We will match you with a tutor who can deliver hands-on coaching.',
                      style: AppTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppTheme.spacingXL),
            ],
            Text('Student Details', style: AppTheme.titleMedium),
            const SizedBox(height: AppTheme.spacingL),
            _buildTextField(
              controller: _studentNameController,
              label: 'Student Name',
              hintText: 'Enter the student name',
            ),
            const SizedBox(height: AppTheme.spacingL),
            _buildTextField(
              controller: _gradeController,
              label: 'Grade Level',
              hintText: 'e.g. Grade 10, University Prep',
            ),
            const SizedBox(height: AppTheme.spacingL),
            _buildTextField(
              controller: _locationController,
              label: 'Location',
              hintText: 'e.g. Addis Ababa, Bole',
            ),
            const SizedBox(height: AppTheme.spacingL),
            _buildTextField(
              controller: _instructionsController,
              label: 'Special Instructions',
              hintText: 'Enter program goals, exam timing, or skills needed',
              maxLines: 4,
            ),
            const SizedBox(height: AppTheme.spacingXL),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _submitRequest,
                style: AppTheme.elevatedButtonStyle,
                child: Text('Submit Request', style: AppTheme.buttonText),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      minLines: 1,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        hintStyle: AppTheme.bodySmall,
        filled: true,
        fillColor: AppTheme.backgroundWhite,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusM),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusM),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
      ),
      style: AppTheme.bodyLarge,
    );
  }

  void _submitRequest() {
    if (_studentNameController.text.isEmpty ||
        _gradeController.text.isEmpty ||
        _locationController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Please fill in the student's name, grade level, and location.",
            style: AppTheme.bodyMedium.copyWith(color: Colors.white),
          ),
          backgroundColor: AppTheme.warningColor,
        ),
      );
      return;
    }

    final repository = BookingRepository.instance;
    final nextId = repository.requests.value.isEmpty
        ? 1
        : repository.requests.value
                  .map((r) => r.id)
                  .reduce(
                    (value, element) => value > element ? value : element,
                  ) +
              1;

    repository.requests.value = [
      ...repository.requests.value,
      BookingRequest(
        id: nextId,
        familyName: _studentNameController.text.trim(),
        subject: widget.subject,
        grade: _gradeController.text.trim(),
        location: _locationController.text.trim(),
        requestDate: DateTime.now().toIso8601String().substring(0, 10),
        status: 'Pending',
        studentName: _studentNameController.text.trim(),
        specialInstructions: _instructionsController.text.trim(),
        createdAt: DateTime.now(),
      ),
    ];

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          widget.isBeyondCurriculum
              ? 'Your request for ${widget.subject} has been received!'
              : 'Your academic support request has been received!',
          style: AppTheme.bodyMedium.copyWith(color: Colors.white),
        ),
        backgroundColor: AppTheme.successColor,
      ),
    );

    Navigator.pop(context);
  }
}
