// lib/features/booking/booking_page.dart

import 'package:appname/data/models/apartment_model.dart';
import 'package:appname/shared_widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // تأكد من إضافة `intl` إلى pubspec.yaml

/// شاشة تفاصيل وإتمام الحجز.
/// تدير حالة التواريخ والضيوف، وتحسب السعر الإجمالي بشكل ديناميكي.
class BookingPage extends StatefulWidget {
  final Apartment apartment;
  const BookingPage({super.key, required this.apartment});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  // ---------------------------------------------------------------------------
  // 1. إدارة الحالة (State Management)
  // ---------------------------------------------------------------------------

  /// نطاق التواريخ المختار من قبل المستخدم.
  DateTimeRange? _selectedDateRange;

  /// عدد الضيوف.
  int _guestCount = 1;

  // ---------------------------------------------------------------------------
  // 2. دوال منطقية (Logic Functions)
  // ---------------------------------------------------------------------------

  /// تفتح منتقي نطاق التواريخ وتقوم بتحديث الحالة.
  Future<void> _pickDateRange() async {
    final newDateRange = await showDateRangePicker(
      context: context,
      initialDateRange: _selectedDateRange,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        // يرث الثيم العام (النهاري أو الليلي) تلقائيًا.
        return Theme(data: Theme.of(context), child: child!);
      },
    );

    if (newDateRange != null) {
      setState(() {
        _selectedDateRange = newDateRange;
      });
    }
  }

  // ---------------------------------------------------------------------------
  // 3. بناء الواجهة (UI Building)
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تأكيد الحجز')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildApartmentSummary(),
            _buildSectionDivider(),
            _buildTripDetails(),
            _buildSectionDivider(),
            _buildPriceDetails(),
            const SizedBox(height: 32),
            PrimaryButton(
              text: 'إتمام الحجز والدفع',
              onPressed: _selectedDateRange != null 
                ? () {
                    Navigator.pop(context, true); 
                  } 
                : null,
            ),
          ],
        ),
      ),
    );
  }

  // --- 4. مكونات الواجهة الداخلية (Internal UI Components) ---

  /// يبني ملخص الشقة في الأعلى.
  Widget _buildApartmentSummary() {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            widget.apartment.images.first,
            width: 100,
            height: 100,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.apartment.title,
                style: theme.textTheme.titleMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Text(widget.apartment.location, style: theme.textTheme.bodySmall),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.star, color: Colors.amber.shade700, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    '${widget.apartment.rating} (${widget.apartment.reviewCount} تقييم)',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// يبني قسم تفاصيل الرحلة (التواريخ والضيوف).
  Widget _buildTripDetails() {
    final theme = Theme.of(context);
    final formatter = DateFormat('d MMM, yyyy');
    final checkIn = _selectedDateRange != null
        ? formatter.format(_selectedDateRange!.start)
        : 'اختر';
    final checkOut = _selectedDateRange != null
        ? formatter.format(_selectedDateRange!.end)
        : 'اختر';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('رحلتك', style: theme.textTheme.titleLarge),
        const SizedBox(height: 16),
        _buildDetailRow(
          title: 'التواريخ',
          content: '$checkIn - $checkOut',
          actionText: 'تعديل',
          onActionPressed: _pickDateRange,
        ),
        const SizedBox(height: 16),
        _buildDetailRow(
          title: 'الضيوف',
          content: '$_guestCount ضيف',
          actionText: 'تعديل',
          onActionPressed: () {
            /* TODO: Implement guest picker */
          },
        ),
      ],
    );
  }

  /// يبني قسم تفاصيل السعر بشكل ديناميكي.
  Widget _buildPriceDetails() {
    final theme = Theme.of(context);
    final nights = _selectedDateRange?.duration.inDays ?? 0;
    final pricePerNight = widget.apartment.pricePerNight;
    final serviceFee = 50; // يمكن أن تكون نسبة مئوية في المستقبل
    final total = (pricePerNight * nights) + serviceFee;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('تفاصيل السعر', style: theme.textTheme.titleLarge),
        const SizedBox(height: 16),
        _buildPriceRow(
          '$pricePerNight ريال × $nights ليالي',
          '${pricePerNight * nights} ريال',
        ),
        const SizedBox(height: 8),
        _buildPriceRow('رسوم الخدمة', '$serviceFee ريال'),
        const Divider(height: 24),
        _buildPriceRow('الإجمالي', '$total ريال', isTotal: true),
      ],
    );
  }

  // --- 5. دوال مساعدة (Helper Functions) ---

  Widget _buildDetailRow({
    required String title,
    required String content,
    required String actionText,
    required VoidCallback onActionPressed,
  }) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: theme.textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(content, style: theme.textTheme.bodySmall),
          ],
        ),
        TextButton(onPressed: onActionPressed, child: Text(actionText)),
      ],
    );
  }

  Widget _buildPriceRow(String title, String value, {bool isTotal = false}) {
    final theme = Theme.of(context);
    final style = theme.textTheme.bodyMedium?.copyWith(
      fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: style),
        Text(value, style: style),
      ],
    );
  }

  Widget _buildSectionDivider() => const Divider(height: 40, thickness: 0.8);
}
