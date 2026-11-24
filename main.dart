import 'package:flutter/material.dart';

void main() => runApp(const TTailorsApp());

const ink = Color(0xFF253B30);
const cream = Color(0xFFF7F4EF);
const gold = Color(0xFFC69A63);

class TTailorsApp extends StatelessWidget {
  const TTailorsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'T Tailors',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: cream,
        colorScheme: ColorScheme.fromSeed(seedColor: ink, surface: cream),
        appBarTheme: const AppBarTheme(
          backgroundColor: cream, foregroundColor: ink, elevation: 0,
          centerTitle: false,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true, fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
      home: const HomePage(),
    );
  }
}

class Product {
  final String name, category, description;
  final int price;
  final IconData icon;
  const Product(this.name, this.category, this.description, this.price, this.icon);
}

const products = <Product>[
  Product('Classic Men’s Shirt', 'Men', 'Custom-stitched shirt made to your measurements.', 499, Icons.checkroom),
  Product('Men’s Trousers', 'Men', 'A tailored fit for everyday comfort.', 599, Icons.straighten),
  Product('Women’s Blouse', 'Women', 'Custom blouse stitching with design choices.', 449, Icons.style),
  Product('Churidar Suit', 'Women', 'Made-to-measure suit stitching.', 799, Icons.dry_cleaning),
  Product('Saree Fall & Pico', 'Women', 'Saree fall attachment and pico stitching.', 150, Icons.auto_awesome),
];

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int tab = 0;
  String category = 'All';
  String search = '';
  final cart = <Product>[];

  List<Product> get visibleProducts => products.where((p) {
    final categoryMatch = category == 'All' || p.category == category;
    final queryMatch = (p.name + p.description).toLowerCase().contains(search.toLowerCase());
    return categoryMatch && queryMatch;
  }).toList();

  @override
  Widget build(BuildContext context) {
    final pages = [
      _home(),
      _simplePage('Wishlist', 'Save your favourite tailoring services here.', Icons.favorite_border),
      _cartPage(),
      _simplePage('My Account', 'Your profile, saved measurements and addresses will appear here.', Icons.person_outline),
    ];
    return Scaffold(
      appBar: AppBar(
        title: Row(children: [
          Container(width: 38, height: 38, decoration: BoxDecoration(
            color: ink, borderRadius: BorderRadius.circular(12)),
            child: const Center(child: Text('T', style: TextStyle(
              color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)))),
          const SizedBox(width: 10),
          const Text('T Tailors', style: TextStyle(fontWeight: FontWeight.w800)),
        ]),
        actions: [
          IconButton(onPressed: () => setState(() => tab = 2),
            icon: Badge(label: Text('${cart.length}'), child: const Icon(Icons.shopping_bag_outlined))),
          IconButton(onPressed: () => _notice('Notifications will appear here.'), icon: const Icon(Icons.notifications_none)),
        ],
      ),
      body: pages[tab],
      bottomNavigationBar: NavigationBar(
        selectedIndex: tab,
        onDestinationSelected: (v) => setState(() => tab = v),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.favorite_border), label: 'Wishlist'),
          NavigationDestination(icon: Icon(Icons.shopping_bag_outlined), label: 'Cart'),
          NavigationDestination(icon: Icon(Icons.person_outline), label: 'Account'),
        ],
      ),
    );
  }

  Widget _home() => ListView(
    padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
    children: [
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: ink, borderRadius: BorderRadius.circular(24)),
        child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('MADE TO FIT YOU', style: TextStyle(color: gold, letterSpacing: 2, fontSize: 11, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Text('Your style,\\nyour perfect fit.', style: TextStyle(color: Colors.white, fontSize: 27, height: 1.15, fontWeight: FontWeight.w800)),
          SizedBox(height: 8),
          Text('Custom tailoring made simple.', style: TextStyle(color: Colors.white70)),
        ]),
      ),
      const SizedBox(height: 20),
      TextField(
        onChanged: (v) => setState(() => search = v),
        decoration: const InputDecoration(
          hintText: 'Search shirts, blouses, stitching...',
          prefixIcon: Icon(Icons.search),),
      ),
      const SizedBox(height: 22),
      const Text('SHOP BY CATEGORY', style: TextStyle(color: ink, fontWeight: FontWeight.w800, letterSpacing: 1.2)),
      const SizedBox(height: 14),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        _categoryButton('Men', 'M'),
        const SizedBox(width: 28),
        _categoryButton('Women', 'W'),
      ]),
      const SizedBox(height: 22),
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        const Text('Our Services', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: ink)),
        TextButton(onPressed: () => setState(() => category = 'All'), child: const Text('View all')),
      ]),
      if (visibleProducts.isEmpty)
        const Padding(padding: EdgeInsets.all(24), child: Text('No matching services found.')),
      ...visibleProducts.map(_productCard),
    ],
  );

  Widget _categoryButton(String name, String letter) => InkWell(
    onTap: () => setState(() => category = category == name ? 'All' : name),
    borderRadius: BorderRadius.circular(100),
    child: Container(
      width: 112, height: 112,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: category == name ? const Color(0xFFE9DDCE) : Colors.white,
        border: Border.all(color: category == name ? gold : const Color(0xFFE7E0D7), width: 1.5),
      ),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(letter, style: const TextStyle(fontFamily: 'serif', fontSize: 30, color: ink)),
        Text(name, style: const TextStyle(fontWeight: FontWeight.w700, color: ink)),
      ]),
    ),
  );

  Widget _productCard(Product p) => Card(
    color: Colors.white, elevation: 0, margin: const EdgeInsets.only(bottom: 12),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18), side: const BorderSide(color: Color(0xFFECE6DE))),
    child: Padding(padding: const EdgeInsets.all(14), child: Row(children: [
      Container(width: 74, height: 82, decoration: BoxDecoration(
        color: const Color(0xFFF2EAE0), borderRadius: BorderRadius.circular(14)),
        child: Icon(p.icon, size: 34, color: ink)),
      const SizedBox(width: 13),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(p.name, style: const TextStyle(fontWeight: FontWeight.w800, color: ink)),
        const SizedBox(height: 4),
        Text(p.description, maxLines: 2, overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: Colors.black54, fontSize: 12)),
        const SizedBox(height: 7),
        Text('₹${p.price}', style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: ink)),
      ])),
      IconButton(onPressed: () { setState(() => cart.add(p)); _notice('${p.name} added to cart.'); },
        icon: const Icon(Icons.add_circle, color: ink, size: 30)),
    ])),
  );

  Widget _cartPage() => cart.isEmpty
    ? _simplePage('Your Cart', 'Your selected tailoring services will appear here.', Icons.shopping_bag_outlined)
    : ListView(padding: const EdgeInsets.all(18), children: [
        const Text('Your selected services', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: ink)),
        const SizedBox(height: 12),
        ...cart.asMap().entries.map((e) => ListTile(
          tileColor: Colors.white, title: Text(e.value.name),
          subtitle: Text('₹${e.value.price}'),
          trailing: IconButton(icon: const Icon(Icons.delete_outline),
            onPressed: () => setState(() => cart.removeAt(e.key))),
        )),
        const SizedBox(height: 18),
        FilledButton(onPressed: () => _notice('Checkout will be connected in the next development stage.'),
          child: const Text('Continue to checkout')),
      ]);

  Widget _simplePage(String title, String message, IconData icon) => Center(
    child: Padding(padding: const EdgeInsets.all(28), child: Column(
      mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 54, color: gold), const SizedBox(height: 14),
        Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: ink)),
        const SizedBox(height: 8), Text(message, textAlign: TextAlign.center, style: const TextStyle(color: Colors.black54)),
      ],
    )),
  );

  void _notice(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}
