import 'package:flutter/material.dart';

void main() => runApp(const AlhajTvApp());

const gold = Color(0xFFE5AD35);
const bg = Color(0xFF08090D);
const panel = Color(0xFF17191F);

class AlhajTvApp extends StatelessWidget {
  const AlhajTvApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ALHAJ TV',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: bg,
        colorScheme: const ColorScheme.dark(primary: gold, surface: panel),
        fontFamily: 'Roboto',
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class Movie {
  final String title;
  final String category;
  final IconData icon;
  const Movie(this.title, this.category, this.icon);
}

const movies = [
  Movie('فيلم أكشن', 'أفلام أجنبية', Icons.local_movies),
  Movie('دراما عربية', 'أفلام عربية', Icons.movie_creation),
  Movie('خيال علمي', 'أفلام أجنبية', Icons.rocket_launch),
  Movie('مسلسل جديد', 'مسلسلات عربية', Icons.live_tv),
  Movie('مسلسل أجنبي', 'مسلسلات أجنبية', Icons.theaters),
  Movie('أنمي', 'أنمي', Icons.auto_awesome),
];

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedTab = 2;
  String selectedCategory = 'الكل';
  final searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = movies.where((m) {
      final categoryMatch = selectedCategory == 'الكل' || m.category == selectedCategory;
      final query = searchController.text.trim();
      final queryMatch = query.isEmpty || m.title.contains(query) || m.category.contains(query);
      return categoryMatch && queryMatch;
    }).toList();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: _header()),
              SliverToBoxAdapter(child: _hero()),
              SliverToBoxAdapter(child: _categories()),
              SliverToBoxAdapter(
                child: _sectionTitle('أحدث الإضافات', onTap: () {}),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => _movieCard(filtered[index]),
                    childCount: filtered.length,
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 10,
                    childAspectRatio: .68,
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 24)),
            ],
          ),
        ),
        bottomNavigationBar: NavigationBar(
          backgroundColor: const Color(0xFF101116),
          indicatorColor: gold.withOpacity(.18),
          selectedIndex: selectedTab,
          onDestinationSelected: (i) => setState(() => selectedTab = i),
          destinations: const [
            NavigationDestination(icon: Icon(Icons.person_outline), label: 'حسابي'),
            NavigationDestination(icon: Icon(Icons.favorite_border), label: 'المفضلة'),
            NavigationDestination(icon: Icon(Icons.home_filled), label: 'الرئيسية'),
            NavigationDestination(icon: Icon(Icons.playlist_play), label: 'قائمتي'),
            NavigationDestination(icon: Icon(Icons.grid_view), label: 'الأقسام'),
          ],
        ),
      ),
    );
  }

  Widget _header() => Padding(
    padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
    child: Column(
      children: [
        Row(
          children: [
            const Icon(Icons.settings_outlined, color: gold),
            const Spacer(),
            const Text('ALHAJ ', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w900, letterSpacing: 1)),
            const Text('TV', style: TextStyle(fontSize: 25, color: gold, fontWeight: FontWeight.w900)),
            const Spacer(),
            const Icon(Icons.notifications_none, color: gold),
          ],
        ),
        const SizedBox(height: 5),
        const Text('مشاهدة بلا حدود', style: TextStyle(color: gold, fontWeight: FontWeight.w700)),
        const SizedBox(height: 14),
        TextField(
          controller: searchController,
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(
            hintText: 'ابحث عن فيلم أو مسلسل...',
            prefixIcon: const Icon(Icons.search),
            filled: true,
            fillColor: panel,
            contentPadding: const EdgeInsets.symmetric(vertical: 12),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(28), borderSide: BorderSide.none),
          ),
        ),
      ],
    ),
  );

  Widget _hero() => Container(
    margin: const EdgeInsets.symmetric(horizontal: 16),
    padding: const EdgeInsets.all(20),
    height: 190,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(22),
      gradient: const LinearGradient(
        colors: [Color(0xFF29251D), Color(0xFF10141F), Color(0xFF07080B)],
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
      ),
      border: Border.all(color: gold.withOpacity(.5)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('عالم من الترفيه', style: TextStyle(fontSize: 27, fontWeight: FontWeight.w900)),
        const SizedBox(height: 8),
        const Text('أفلام ومسلسلات بجودات متعددة\nوبدون إعلانات داخل التطبيق',
            style: TextStyle(color: Colors.white70, height: 1.5)),
        const SizedBox(height: 14),
        FilledButton.icon(
          style: FilledButton.styleFrom(backgroundColor: gold, foregroundColor: Colors.black),
          onPressed: () => _showInfo('المشغل', 'سيتم ربط مشغل الفيديو بمصدر بث تملك حق استخدامه.'),
          icon: const Icon(Icons.play_arrow),
          label: const Text('ابدأ المشاهدة'),
        ),
      ],
    ),
  );

  Widget _categories() {
    const cats = ['الكل', 'أفلام عربية', 'أفلام أجنبية', 'مسلسلات عربية', 'مسلسلات أجنبية', 'أنمي'];
    return SizedBox(
      height: 58,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        scrollDirection: Axis.horizontal,
        itemCount: cats.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final active = selectedCategory == cats[i];
          return ChoiceChip(
            label: Text(cats[i]),
            selected: active,
            onSelected: (_) => setState(() => selectedCategory = cats[i]),
            selectedColor: gold,
            backgroundColor: panel,
            labelStyle: TextStyle(color: active ? Colors.black : Colors.white),
            side: BorderSide(color: active ? gold : Colors.white12),
          );
        },
      ),
    );
  }

  Widget _sectionTitle(String title, {VoidCallback? onTap}) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 8, 16, 14),
    child: Row(
      children: [
        Container(width: 4, height: 23, decoration: BoxDecoration(color: gold, borderRadius: BorderRadius.circular(4))),
        const SizedBox(width: 9),
        Text(title, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
        const Spacer(),
        TextButton(onPressed: onTap, child: const Text('عرض الكل', style: TextStyle(color: gold))),
      ],
    ),
  );

  Widget _movieCard(Movie movie) => InkWell(
    borderRadius: BorderRadius.circular(14),
    onTap: () => _showInfo(movie.title, 'صفحة التفاصيل والسيرفرات والجودات ستُضاف في المرحلة التالية.'),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: gold.withOpacity(.25)),
              gradient: const LinearGradient(colors: [Color(0xFF34302A), Color(0xFF151820)], begin: Alignment.topLeft, end: Alignment.bottomRight),
            ),
            child: Icon(movie.icon, size: 48, color: gold),
          ),
        ),
        const SizedBox(height: 6),
        Text(movie.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(movie.category, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white54, fontSize: 11)),
      ],
    ),
  );

  void _showInfo(String title, String message) {
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: panel,
        title: Text(title),
        content: Text(message),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('حسناً', style: TextStyle(color: gold)))],
      ),
    );
  }
}
