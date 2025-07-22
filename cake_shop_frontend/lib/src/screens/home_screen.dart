import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cake_provider.dart';
import '../models/cake.dart';
import 'cake_detail_screen.dart';
import 'cart_screen.dart';
import 'order_screen.dart';
import 'profile_screen.dart';
import 'admin_dashboard_screen.dart';
import '../providers/user_provider.dart';

/// Main app page with bottom navigation (Home, Categories, Orders, Profile)
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    final isAdmin = user?.isAdmin ?? false;
    return Scaffold(
      body: IndexedStack(
        index: _selected,
        children: [
          CatalogScreen(),
          OrderScreen(),
          CartScreen(),
          ProfileScreen(),
          if (isAdmin) AdminDashboardScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selected,
        onTap: (i) => setState(() => _selected = i),
        items: [
          const BottomNavigationBarItem(icon: Icon(Icons.cake_outlined), label: "Home"),
          const BottomNavigationBarItem(icon: Icon(Icons.history), label: "Orders"),
          const BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: "Cart"),
          const BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
          if (isAdmin) const BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: "Admin"),
        ],
      ),
    );
  }
}

class CatalogScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<CakeProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (provider.cakes.isEmpty) {
          provider.fetchCakes(context);
          return const Center(child: Text("No cakes to display"));
        }
        final cakes = provider.cakes;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 14, childAspectRatio: 0.74),
            itemCount: cakes.length,
            itemBuilder: (context, i) => CakeGridTile(cake: cakes[i]),
          ),
        );
      },
    );
  }
}

class CakeGridTile extends StatelessWidget {
  final Cake cake;
  const CakeGridTile({required this.cake});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => CakeDetailScreen(cakeId: cake.id)),
      ),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: Theme.of(context).cardColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(12)),
                child: cake.imageUrl.isNotEmpty
                    ? Image.network(cake.imageUrl, fit: BoxFit.cover)
                    : Container(color: Colors.grey[800]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(9),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(cake.name,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(fontSize: 16)),
                  Text('\$${cake.price.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.labelLarge),
                  Row(
                    children: [
                      Icon(Icons.star, size: 18, color: Colors.amber[300]),
                      const SizedBox(width: 3),
                      Text(
                        "${cake.rating} (${cake.reviewCount})",
                        style: TextStyle(fontSize: 12, color: Colors.grey[300]),
                      ),
                    ],
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
