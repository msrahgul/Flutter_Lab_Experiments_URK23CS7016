import 'package:flutter/material.dart';

void main() => runApp(const ProductSearchApp());

class Product {
  final String name;
  final String category;
  final double price;
  const Product(this.name, this.category, this.price);
}

const List<Product> allProducts = [
  Product('Smartphone', 'Electronics', 15999),
  Product('Laptop', 'Electronics', 45999),
  Product('Tablet', 'Electronics', 19999),
  Product('Headphones', 'Accessories', 1999),
  Product('Smart Watch', 'Accessories', 3499),
  Product('Keyboard', 'Accessories', 999),
  Product('Bluetooth Speaker', 'Audio', 2499),
  Product('Earphones', 'Audio', 799),
];

class ProductSearchApp extends StatelessWidget {
  const ProductSearchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Product Search',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.teal, useMaterial3: true),
      home: const ProductSearchPage(),
    );
  }
}

class ProductSearchPage extends StatefulWidget {
  const ProductSearchPage({super.key});

  @override
  State<ProductSearchPage> createState() => _ProductSearchPageState();
}

class _ProductSearchPageState extends State<ProductSearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> _categories = ['All', 'Electronics', 'Accessories', 'Audio'];
  String _query = '';
  String _selectedCategory = 'All';

  List<Product> get _filteredProducts {
    return allProducts.where((p) {
      final matchesName = p.name.toLowerCase().contains(_query.toLowerCase());
      final matchesCategory =
          _selectedCategory == 'All' || p.category == _selectedCategory;
      return matchesName && matchesCategory;
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final results = _filteredProducts;
    return Scaffold(
      appBar: AppBar(title: const Text('Product Search & Filter')),
      body: Column(children: [
        Expanded(child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search products...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _query.isEmpty
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _query = '');
                        },
                      ),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onChanged: (value) => setState(() => _query = value),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              children: _categories.map((c) {
                return ChoiceChip(
                  label: Text(c),
                  selected: _selectedCategory == c,
                  onSelected: (_) => setState(() => _selectedCategory = c),
                );
              }).toList(),
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerLeft,
              child: Text('${results.length} product(s) found'),
            ),
            Expanded(
              child: results.isEmpty
                  ? const Center(child: Text('No products found'))
                  : ListView.builder(
                      itemCount: results.length,
                      itemBuilder: (context, index) {
                        final p = results[index];
                        return Card(
                          child: ListTile(
                            leading: const CircleAvatar(
                                child: Icon(Icons.shopping_bag)),
                            title: Text(p.name),
                            subtitle: Text(p.category),
                            trailing: Text('₹${p.price.toStringAsFixed(0)}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      )),
        const Padding(padding: EdgeInsets.all(8), child: Text('Register No: URK23CS7016', textAlign: TextAlign.center)),
      ]),
    );
  }
}
