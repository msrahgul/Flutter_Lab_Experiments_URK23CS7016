import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ListViewDemo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.deepPurple, useMaterial3: true),
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Custom List View',
              style: TextStyle(letterSpacing: 10)),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(8),
                children: const [
                  MyListItem(fruitname: 'Apple', price: 180, image: 'assets/images/apple.png'),
                  MyListItem(fruitname: 'Orange', price: 100, image: 'assets/images/orange.jpg'),
                  MyListItem(fruitname: 'Mango', price: 70, image: 'assets/images/mango.png'),
                  MyListItem(fruitname: 'Pomegranate', price: 250, image: 'assets/images/pomegranate.png'),
                  MyListItem(fruitname: 'Banana', price: 60, image: 'assets/images/banana.png'),
                ],
              ),
            ),
            const RegisterNumberFooter(),
          ],
        ),
      ),
    );
  }
}

class RegisterNumberFooter extends StatelessWidget {
  const RegisterNumberFooter({super.key});

  @override
  Widget build(BuildContext context) => const Padding(
        padding: EdgeInsets.all(8),
        child: Text('Register No: URK23CS7016'),
      );
}

// Reusable custom widget for one row of the list
class MyListItem extends StatelessWidget {
  final String fruitname;
  final double price;
  final String image;

  const MyListItem({
    super.key,
    required this.fruitname,
    required this.price,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.currency(locale: 'en_IN', symbol: '₹');
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            Image.asset(image, width: 100, height: 100, fit: BoxFit.cover),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(fruitname,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(currency.format(price)),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('$fruitname added to cart')),
                      );
                    },
                    child: const Text('Buy Now'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
