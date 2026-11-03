import 'package:flutter/material.dart';

void main() => runApp(const CatalogApp());

class Product {
  final String name;
  final String category;
  final double price;
  final double rating;
  final IconData icon;
  const Product(this.name, this.category, this.price, this.rating, this.icon);
}

const List<Product> products = [
  Product('Smartphone', 'Electronics', 15999, 4.5, Icons.smartphone),
  Product('Laptop', 'Electronics', 45999, 4.6, Icons.laptop),
  Product('Headphones', 'Accessories', 1999, 4.2, Icons.headphones),
  Product('Smart Watch', 'Accessories', 3499, 4.1, Icons.watch),
  Product('Camera', 'Electronics', 28999, 4.7, Icons.camera_alt),
  Product('Keyboard', 'Accessories', 999, 4.0, Icons.keyboard),
  Product('Tablet', 'Electronics', 19999, 4.3, Icons.tablet_mac),
  Product('Speaker', 'Audio', 2499, 4.4, Icons.speaker),
];

class CatalogApp extends StatelessWidget {
  const CatalogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Product Catalog',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      home: const CatalogPage(),
    );
  }
}

class CatalogPage extends StatelessWidget {
  const CatalogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('E-Commerce Product Catalog')),
      body: Column(children: [
        Expanded(child: LayoutBuilder(
        builder: (context, constraints) {
          final double w = constraints.maxWidth;
          final int columns = w >= 1000 ? 4 : (w >= 700 ? 3 : 2);
          final String device =
              w >= 1000 ? 'Desktop' : (w >= 700 ? 'Tablet' : 'Mobile');

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  'Width: ${w.toInt()} px  |  Layout: $device  |  Columns: $columns',
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(12),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: columns,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: w >= 700 ? 0.9 : 0.72,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, i) => ProductCard(product: products[i]),
                ),
              ),
            ],
          );
        },
      )),
        const Padding(padding: EdgeInsets.all(8), child: Text('Register No: URK23CS7016', textAlign: TextAlign.center)),
      ]),
    );
  }
}

// Reusable custom product widget
class ProductCard extends StatelessWidget {
  final Product product;
  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.indigo.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(product.icon, size: 56, color: Colors.indigo),
              ),
            ),
            const SizedBox(height: 8),
            Text(product.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(product.category,
                style: const TextStyle(color: Colors.grey, fontSize: 12)),
            const SizedBox(height: 4),
            Row(
              children: [
                Text('₹${product.price.toStringAsFixed(0)}',
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, color: Colors.green)),
                const Spacer(),
                const Icon(Icons.star, size: 16, color: Colors.amber),
                Text(' ${product.rating}'),
              ],
            ),
            const SizedBox(height: 6),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${product.name} added to cart')),
                  );
                },
                child: const Text('Add to Cart'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
