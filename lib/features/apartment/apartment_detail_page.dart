// lib/features/apartment/apartment_detail_page.dart

import 'package:animated_rating_stars/animated_rating_stars.dart';
import 'package:appname/data/models/apartment_model.dart';
import 'package:appname/shared_widgets/primary_button.dart';
import 'package:flutter/material.dart';

class ApartmentDetailPage extends StatefulWidget {
  final Apartment apartment;
  const ApartmentDetailPage({super.key, required this.apartment});

  @override
  State<ApartmentDetailPage> createState() => _ApartmentDetailPageState();
}

class _ApartmentDetailPageState extends State<ApartmentDetailPage> {
  int _currentImageIndex = 0;
  late double _userRating;

  @override
  void initState() {
    super.initState();
    // في تطبيق حقيقي، يمكن جلب تقييم المستخدم المحفوظ لهذه الشقة.
    // حاليًا، سنبدأ بصفر.
    _userRating = 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 1. شريط الحجز السفلي الثابت
      bottomNavigationBar: _buildBottomBar(),
      
      body: CustomScrollView(
        slivers: [
          // 2. معرض الصور الاحترافي
          _buildImageGallery(),
          
          // 3. بقية التفاصيل
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
                    const SizedBox(height: 20), // مساحة إضافية
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  // --- مكونات الواجهة الداخلية (Internal UI Components) ---

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
              onPageChanged: (index) => setState(() => _currentImageIndex = index),
              itemBuilder: (context, index) {
                return Image.network(
                  widget.apartment.images[index],
                  fit: BoxFit.cover,
                  color: Colors.black38,
                  colorBlendMode: BlendMode.darken,
                  loadingBuilder: (context, child, progress) => progress == null ? child : const Center(child: CircularProgressIndicator(color: Colors.white)),
                  errorBuilder: (context, error, stack) => const Icon(Icons.broken_image, size: 50, color: Colors.white60),
                );
              },
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(widget.apartment.images.length, (index) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      height: 8,
                      width: _currentImageIndex == index ? 24 : 8,
                      decoration: BoxDecoration(color: _currentImageIndex == index ? Colors.white : Colors.white54, borderRadius: BorderRadius.circular(12)),
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

  Widget _buildHeader() {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: Text(widget.apartment.title, style: theme.textTheme.titleLarge)),
            const SizedBox(width: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: widget.apartment.isAvailable ? Colors.green.shade100 : Colors.red.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                widget.apartment.isAvailable ? 'متاحة الآن' : 'مؤجرة',
                style: theme.textTheme.bodySmall?.copyWith(color: widget.apartment.isAvailable ? Colors.green.shade800 : Colors.red.shade800, fontWeight: FontWeight.bold),
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
            Text('${widget.apartment.rating}', style: theme.textTheme.titleMedium?.copyWith(fontSize: 15)),
            const SizedBox(width: 6),
            Text('(${widget.apartment.reviewCount} تقييم)', style: theme.textTheme.bodySmall),
          ],
        ),
        const SizedBox(height: 8),
        Row(children: [
          Icon(Icons.location_on_outlined, color: theme.primaryColor, size: 18),
          const SizedBox(width: 4),
          Text(widget.apartment.location, style: theme.textTheme.bodySmall),
        ]),
      ],
    );
  }

  Widget _buildDescription() {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('عن هذه الشقة', style: theme.textTheme.titleMedium),
        const SizedBox(height: 8),
        Text(
          'هذا النص هو مثال لنص يمكن أن يستبدل في نفس المساحة، لقد تم توليد هذا النص من مولد النص العربى، حيث يمكنك أن تولد مثل هذا النص أو العديد من النصوص الأخرى...',
          style: theme.textTheme.bodyMedium?.copyWith(height: 1.6, color: theme.textTheme.bodySmall?.color),
        ),
      ],
    );
  }

  Widget _buildFeatures() {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('الميزات', style: theme.textTheme.titleMedium),
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

  Widget _buildRatingSection() {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('أضف تقييمك', style: theme.textTheme.titleMedium),
        const SizedBox(height: 16),
        // Center(
        //   child: AnimatedRatingStars(
        //     initialRating: _userRating,
        //     onChanged: (double rating) => setState(() => _userRating = rating),
        //     displayRatingValue: true,
        //     starSize: 32.0,
        //     filledColor: Colors.amber,
        //     emptyColor: Colors.grey.shade300,
        //   ),
        // ),
      ],
    );
  }

  Widget _buildOwnerInfo() {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('مقدمة من', style: theme.textTheme.titleMedium),
        const SizedBox(height: 12),
        Row(
          children: [
            const CircleAvatar(radius: 28, backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=12')),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('شركة العقار الذهبي', style: theme.textTheme.titleMedium?.copyWith(fontSize: 15)),
                  Text('عضو منذ 2021', style: theme.textTheme.bodySmall),
                ],
              ),
            ),
            IconButton(onPressed: () {}, icon: const Icon(Icons.message_outlined), color: theme.primaryColor),
            IconButton(onPressed: () {}, icon: const Icon(Icons.call_outlined), color: theme.primaryColor),
          ],
        ),
      ],
    );
  }

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
                Text(widget.apartment.price, style: theme.textTheme.titleMedium?.copyWith(color: theme.primaryColor, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(width: 20),
            Expanded(child: PrimaryButton(text: 'احجز الآن', onPressed: widget.apartment.isAvailable ? () {} : null)),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureIcon(IconData icon, String label) {
    final theme = Theme.of(context);
    return Column(children: [
      Icon(icon, size: 28, color: theme.textTheme.bodyMedium?.color),
      const SizedBox(height: 8),
      Text(label, style: theme.textTheme.bodySmall),
    ]);
  }
  
  Widget _buildSectionDivider() => const Divider(height: 48, thickness: 0.8);
}
