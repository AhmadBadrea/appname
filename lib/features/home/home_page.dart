// lib/features/home/home_page.dart

import 'package:appname/core/routing/app_router.dart';
import 'package:appname/data/models/apartment_model.dart';
import 'package:appname/data/providers/mock_data_provider.dart';
import 'package:appname/shared_widgets/custom_text_field.dart';
import 'package:flutter/material.dart';

/// الشاشة الرئيسية ومركز التحكم في التنقل السفلي للتطبيق.
/// تدير الحالة المركزية للشقق وقائمة المفضلة.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // ---------------------------------------------------------------------------
  // 1. إدارة الحالة (State Management)
  // ---------------------------------------------------------------------------

  /// المؤشر الذي يحدد أي تبويب (صفحة) نشط حاليًا.
  int _selectedIndex = 0;

  /// القائمة الرئيسية التي تحتوي على كل الشقق، وهي المصدر الوحيد للحقيقة.
  late List<Apartment> _allApartments;

  @override
  void initState() {
    super.initState();
    // نقوم بجلب البيانات من مصدر البيانات الوهمي مرة واحدة عند بدء الشاشة.
    _allApartments = MockDataProvider.apartments;
  }

  /// دالة مركزية لتغيير حالة "المفضلة" لشقة معينة.
  /// يتم استدعاؤها من أي مكان في التطبيق يريد تغيير هذه الحالة.
  void _toggleFavoriteStatus(String apartmentId) {
    setState(() {
      // نجد الشقة في القائمة الرئيسية ونغير قيمة `isFavorited`.
      final apartment = _allApartments.firstWhere((apt) => apt.id == apartmentId);
      apartment.isFavorited = !apartment.isFavorited;
    });
  }

  /// دالة لتحديث الحالة عند الضغط على أحد عناصر شريط التنقل السفلي.
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // ---------------------------------------------------------------------------
  // 2. بناء الواجهة (UI Building)
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    // قائمة الصفحات يتم إنشاؤها داخل `build` لتمرير البيانات المحدثة.
    // هذا يحل مشكلة `late final` ويضمن أن البيانات دائمًا حديثة.
    final List<Widget> widgetOptions = <Widget>[
      _HomeContent(
        apartments: _allApartments,
        onFavoriteToggle: _toggleFavoriteStatus,
      ),
      _FavoritesContent(
        favoritedApartments: _allApartments.where((apt) => apt.isFavorited).toList(),
        onFavoriteToggle: _toggleFavoriteStatus,
      ),
      const _PlaceholderPage(title: 'شققي'),
      const _PlaceholderPage(title: 'حسابي'),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: widgetOptions,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () { /* TODO: Implement "add apartment" functionality */ },
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            _buildNavItem(icon: Icons.home_filled, label: 'الرئيسية', index: 0),
            _buildNavItem(icon: Icons.favorite, label: 'المفضلة', index: 1),
            const SizedBox(width: 48), // مساحة فارغة للزر العائم
            _buildNavItem(icon: Icons.apartment, label: 'شققي', index: 2),
            _buildNavItem(icon: Icons.person, label: 'حسابي', index: 3),
          ],
        ),
      ),
    );
  }

  /// دالة مساعدة لبناء كل عنصر في شريط التنقل لتجنب تكرار الكود.
  Widget _buildNavItem({required IconData icon, required String label, required int index}) {
    final theme = Theme.of(context);
    final isSelected = _selectedIndex == index;

    return Expanded(
      child: InkWell(
        onTap: () => _onItemTapped(index),
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(
                icon,
                color: isSelected ? theme.primaryColor : Colors.grey.shade500,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: isSelected ? theme.primaryColor : Colors.grey.shade600,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// 3. مكونات الواجهة الداخلية (Internal UI Components)
// -----------------------------------------------------------------------------

/// ويدجت يمثل محتوى تبويب "الرئيسية".
class _HomeContent extends StatelessWidget {
  final List<Apartment> apartments;
  final Function(String) onFavoriteToggle;

  const _HomeContent({required this.apartments, required this.onFavoriteToggle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الرئيسية'),
        actions: [
          IconButton(icon: const Icon(Icons.notifications_outlined), onPressed: () {}),
          IconButton(
            icon: const Icon(Icons.chat_bubble_outline),
            onPressed: () => Navigator.pushNamed(context, AppRouter.chats),
          ),
        ],
      ),
      body: Column(
        children: [
          // شريط البحث والفلترة
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
            child: Row(
              children: [
                const Expanded(child: CustomTextField(hint: 'ابحث عن منطقة، مدينة...', icon: Icons.search)),
                const SizedBox(width: 12),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.filter_list),
                  style: IconButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    padding: const EdgeInsets.all(12),
                  ),
                ),
              ],
            ),
          ),
          // قائمة الشقق
          Expanded(
            child: ListView.builder(
              itemCount: apartments.length,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              itemBuilder: (context, index) {
                final apartment = apartments[index];
                return _ApartmentListItem(
                  apartment: apartment,
                  onFavoriteToggle: () => onFavoriteToggle(apartment.id),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// ويدجت يمثل محتوى تبويب "المفضلة".
class _FavoritesContent extends StatelessWidget {
  final List<Apartment> favoritedApartments;
  final Function(String) onFavoriteToggle;

  const _FavoritesContent({required this.favoritedApartments, required this.onFavoriteToggle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('المفضلة')),
      body: favoritedApartments.isEmpty
          ? const Center(child: Text('قائمة المفضلة فارغة.'))
          : ListView.builder(
              itemCount: favoritedApartments.length,
              padding: const EdgeInsets.all(16.0),
              itemBuilder: (context, index) {
                final apartment = favoritedApartments[index];
                return _ApartmentListItem(
                  apartment: apartment,
                  onFavoriteToggle: () => onFavoriteToggle(apartment.id),
                );
              },
            ),
    );
  }
}

/// ويدجت يعرض تفاصيل شقة واحدة في قائمة.
class _ApartmentListItem extends StatelessWidget {
  final Apartment apartment;
  final VoidCallback onFavoriteToggle;

  const _ApartmentListItem({required this.apartment, required this.onFavoriteToggle});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, AppRouter.apartmentDetail, arguments: apartment);
      },
      borderRadius: BorderRadius.circular(15),
      child: Card(
        elevation: 2,
        margin: const EdgeInsets.only(bottom: 20),
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Image.network(
                  apartment.imageUrl,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, progress) => progress == null ? child : const SizedBox(height: 180, child: Center(child: CircularProgressIndicator())),
                  errorBuilder: (context, error, stack) => const SizedBox(height: 180, child: Icon(Icons.broken_image, size: 40, color: Colors.grey)),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: CircleAvatar(
                    backgroundColor: Colors.black.withOpacity(0.4),
                    child: IconButton(
                      icon: Icon(
                        apartment.isFavorited ? Icons.favorite : Icons.favorite_border,
                        color: apartment.isFavorited ? Colors.redAccent : Colors.white,
                      ),
                      onPressed: onFavoriteToggle,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(apartment.title, style: theme.textTheme.titleMedium, maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.location_on_outlined, color: theme.primaryColor, size: 16),
                      const SizedBox(width: 4),
                      Expanded(child: Text(apartment.location, style: theme.textTheme.bodySmall, overflow: TextOverflow.ellipsis)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(apartment.price, style: theme.textTheme.titleMedium?.copyWith(color: theme.primaryColor, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ويدجت بسيط للصفحات الأخرى (شققي، حسابي).
class _PlaceholderPage extends StatelessWidget {
  final String title;
  const _PlaceholderPage({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text('محتوى صفحة $title', style: const TextStyle(fontSize: 24))),
    );
  }
}
