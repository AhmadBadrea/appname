// lib/features/apartment/apartment_detail_page.dart

import 'package:animated_rating_stars/animated_rating_stars.dart';
import 'package:appname/core/routing/app_router.dart';
import 'package:appname/data/models/apartment_model.dart';
import 'package:appname/data/models/chat_model.dart' show Chat;
import 'package:appname/shared_widgets/primary_button.dart';
import 'package:flutter/material.dart';

/// شاشة عرض التفاصيل الكاملة لشقة واحدة.
/// تتميز بتصميم احترافي مع معرض صور، تقييم تفاعلي، وشريط حجز ثابت.
class ApartmentDetailPage extends StatefulWidget {
  final Apartment apartment;
  const ApartmentDetailPage({super.key, required this.apartment});

  @override
  State<ApartmentDetailPage> createState() => _ApartmentDetailPageState();
}

class _ApartmentDetailPageState extends State<ApartmentDetailPage> {
  // ---------------------------------------------------------------------------
  // 1. إدارة الحالة (State Management)
  // ---------------------------------------------------------------------------

  /// مؤشر الصورة الحالية في معرض الصور.
  int _currentImageIndex = 0;

  /// تقييم المستخدم الحالي لهذه الشقة.
  late double _userRating;
  late bool _isAvailable; // <-- 3. متغير حالة جديد

  @override
  void initState() {
    super.initState();
    // في تطبيق حقيقي، يمكن جلب تقييم المستخدم المحفوظ لهذه الشقة.
    // حاليًا، سنبدأ بصفر.
    _userRating = 0.0;
    _isAvailable = widget.apartment.isAvailable; // تهيئة الحالة من الويدجت
  }

  // ---------------------------------------------------------------------------
  // 2. بناء الواجهة (UI Building)
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // شريط الحجز السفلي الثابت
      bottomNavigationBar: _buildBottomBar(),

      body: CustomScrollView(
        slivers: [
          // معرض الصور الاحترافي مع شريط علوي يتقلص
          _buildImageGallery(),

          // بقية تفاصيل الشقة
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    _buildSectionDivider(),
                    _buildDescription(),
                    _buildSectionDivider(),
                    _buildFeatures(),
                    _buildSectionDivider(),
                    _buildRatingSection(),
                    _buildSectionDivider(),
                    _buildOwnerInfo(),
                    const SizedBox(
                      height: 20,
                    ), // مساحة إضافية قبل الشريط السفلي
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  // --- 3. مكونات الواجهة الداخلية (Internal UI Components) ---

  /// يبني معرض الصور العلوي مع شريط `SliverAppBar`.
  Widget _buildImageGallery() {
    return SliverAppBar(
      expandedHeight: 280.0,
      pinned: true,
      stretch: true,
      title: Text(widget.apartment.title, style: const TextStyle(fontSize: 16)),
      centerTitle: true,

      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            PageView.builder(
              itemCount: widget.apartment.images.length,
              onPageChanged: (index) =>
                  setState(() => _currentImageIndex = index),
              itemBuilder: (context, index) {
                return Image.network(
                  widget.apartment.images[index],
                  fit: BoxFit.cover,
                  color: Colors.black38,
                  colorBlendMode: BlendMode.darken,
                  loadingBuilder: (context, child, progress) => progress == null
                      ? child
                      : const Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        ),
                  errorBuilder: (context, error, stack) => const Icon(
                    Icons.broken_image,
                    size: 50,
                    color: Colors.white60,
                  ),
                );
              },
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(widget.apartment.images.length, (
                    index,
                  ) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      height: 8,
                      width: _currentImageIndex == index ? 24 : 8,
                      decoration: BoxDecoration(
                        color: _currentImageIndex == index
                            ? Colors.white
                            : Colors.white54,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// دالة لإلغاء الحجز
  void _cancelBooking() {
    // TODO: Implement actual cancellation logic with confirmation dialog
    setState(() {
      _isAvailable = true; // إعادة الشقة إلى حالة "متاحة"
    });
  }

  /// دالة للانتقال إلى صفحة الحجز وانتظار النتيجة
  Future<void> _navigateToBooking() async {
    // `await` تنتظر حتى يتم إغلاق BookingPage
    final bool? bookingConfirmed =
        await Navigator.pushNamed(
              context,
              AppRouter.booking,
              arguments: widget.apartment,
            )
            as bool?; // استقبال القيمة العائدة

    // إذا كانت النتيجة `true` (تم تأكيد الحجز)
    if (bookingConfirmed == true) {
      setState(() {
        _isAvailable = false; // تحديث الحالة وتغيير الواجهة
      });
    }
  }

  /// يبني رأس الصفحة الذي يحتوي على العنوان، حالة الإتاحة، التقييم، والموقع.
  Widget _buildHeader() {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                widget.apartment.title,
                style: theme.textTheme.titleLarge,
              ),
            ),
            const SizedBox(width: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: _isAvailable
                    ? Colors.green.shade100
                    : Colors.red.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _isAvailable ? 'متاحة الآن' : 'محجوزة',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: _isAvailable
                      ? Colors.green.shade800
                      : Colors.red.shade800,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.star, color: Colors.amber.shade700, size: 20),
            const SizedBox(width: 4),
            Text(
              '${widget.apartment.rating}',
              style: theme.textTheme.titleMedium?.copyWith(fontSize: 15),
            ),
            const SizedBox(width: 6),
            Text(
              '(${widget.apartment.reviewCount} تقييم)',
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(
              Icons.location_on_outlined,
              color: theme.primaryColor,
              size: 18,
            ),
            const SizedBox(width: 4),
            Text(widget.apartment.location, style: theme.textTheme.bodySmall),
          ],
        ),
      ],
    );
  }

  /// يبني قسم الوصف.
  Widget _buildDescription() {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('عن هذه الشقة', style: theme.textTheme.titleMedium),
        const SizedBox(height: 8),
        Text(
          'هذا النص هو مثال لنص يمكن أن يستبدل في نفس المساحة، لقد تم توليد هذا النص من مولد النص العربى، حيث يمكنك أن تولد مثل هذا النص أو العديد من النصوص الأخرى...',
          style: theme.textTheme.bodyMedium?.copyWith(
            height: 1.6,
            color: theme.textTheme.bodySmall?.color,
          ),
        ),
      ],
    );
  }

  /// يبني قسم الميزات.
  Widget _buildFeatures() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('الميزات', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildFeatureIcon(Icons.bed_outlined, '3 غرف نوم'),
            _buildFeatureIcon(Icons.bathtub_outlined, '2 حمام'),
            _buildFeatureIcon(Icons.square_foot_outlined, '180 م²'),
            _buildFeatureIcon(Icons.balcony_outlined, 'شرفة'),
          ],
        ),
      ],
    );
  }

  /// يبني قسم تقييم المستخدم.
  Widget _buildRatingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('أضف تقييمك', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 16),
        Center(
          child: AnimatedRatingStars(
            initialRating: _userRating,
            onChanged: (rating) => setState(() => _userRating = rating),
            displayRatingValue: true,
            interactiveTooltips: true,
            customFilledIcon: Icons.star,
            customHalfFilledIcon: Icons.star_half,
            customEmptyIcon: Icons.star_border,
            starSize: 40.0,
            animationDuration: const Duration(milliseconds: 500),
            animationCurve: Curves.easeInOut,
          ),
        ),
      ],
    );
  }

  Widget _buildOwnerInfo() {
    final theme = Theme.of(context);

    // --- 3. بيانات المالك الوهمية ---
    const ownerName = 'شركة العقار الذهبي';
    const ownerImageUrl = 'https://i.pravatar.cc/150?img=12';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('مقدمة من', style: theme.textTheme.titleMedium),
        const SizedBox(height: 12),
        Row(
          children: [
            const CircleAvatar(
              radius: 28,
              backgroundImage: NetworkImage(ownerImageUrl),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ownerName,
                    style: theme.textTheme.titleMedium?.copyWith(fontSize: 15),
                  ),
                  Text('عضو منذ 2021', style: theme.textTheme.bodySmall),
                ],
              ),
            ),

            // --- 4. هذا هو التعديل الجوهري ---
            IconButton(
              onPressed: () {
                // إنشاء كائن Chat وهمي ومؤقت
                final ownerChat = Chat(
                  name: ownerName,
                  imageUrl: ownerImageUrl,
                  lastMessage: 'يمكنك بدء المحادثة الآن...', // رسالة افتراضية
                  time: '', // الوقت غير مهم هنا
                  unreadCount: 0,
                );

                // استخدام التوجيه المركزي للانتقال
                Navigator.pushNamed(
                  context,
                  AppRouter.chatDetail,
                  arguments: ownerChat, // تمرير الكائن
                );
              },
              icon: const Icon(Icons.message_outlined),
              color: theme.primaryColor,
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.call_outlined),
              color: theme.primaryColor,
            ),
          ],
        ),
      ],
    );
  }

  /// يبني شريط الحجز السفلي الثابت.
  Widget _buildBottomBar() {
    final theme = Theme.of(context);
    return BottomAppBar(
      elevation: 10,
      surfaceTintColor: theme.colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('السعر', style: theme.textTheme.bodySmall),
                Text(
                  widget.apartment.price,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 20),
            Expanded(
              // --- 4. هذا هو التعديل الجوهري ---
              child: _isAvailable
                  ? PrimaryButton(
                      text: 'احجز الآن',
                      onPressed:
                          _navigateToBooking, // <-- استدعاء الدالة الجديدة
                    )
                  : ElevatedButton(
                      // <-- استخدام زر مختلف لإلغاء الحجز
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade700,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: _cancelBooking,
                      child: const Text('إلغاء الحجز'),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  /// دالة مساعدة لبناء أيقونة الميزات.
  Widget _buildFeatureIcon(IconData icon, String label) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Icon(icon, size: 28, color: theme.textTheme.bodyMedium?.color),
        const SizedBox(height: 8),
        Text(label, style: theme.textTheme.bodySmall),
      ],
    );
  }

  /// دالة مساعدة لبناء فاصل بين الأقسام.
  Widget _buildSectionDivider() => const Divider(height: 48, thickness: 0.8);
}

/// دالة مساعدة لبناء فاصل بين الأقسام.
Widget _buildSectionDivider() => const Divider(height: 48, thickness: 0.8);
