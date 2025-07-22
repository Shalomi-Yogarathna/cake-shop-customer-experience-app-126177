import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/cake.dart';
import '../services/api_service.dart';
import '../providers/cart_provider.dart';
import 'cart_screen.dart';

class CakeDetailScreen extends StatefulWidget {
  final int cakeId;
  const CakeDetailScreen({super.key, required this.cakeId});
  @override
  State<CakeDetailScreen> createState() => _CakeDetailScreenState();
}

class _CakeDetailScreenState extends State<CakeDetailScreen> {
  late Future<Cake> _cakeFuture;

  @override
  void initState() {
    super.initState();
    _cakeFuture = ApiService.getCakeDetail(widget.cakeId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cake Details")),
      body: FutureBuilder<Cake>(
        future: _cakeFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            if (snapshot.hasError) {
              return Center(child: Text('Error loading cake'));
            }
            return const Center(child: CircularProgressIndicator());
          }
          final cake = snapshot.data!;
          return ListView(
            children: [
              cake.imageUrl.isNotEmpty
                  ? Image.network(
                      cake.imageUrl,
                      fit: BoxFit.cover,
                      height: 230,
                    )
                  : Container(height: 230, color: Colors.grey[800]),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(cake.name, style: Theme.of(context).textTheme.headlineMedium),
                    const SizedBox(height: 8),
                    Text('\$${cake.price.toStringAsFixed(2)}', style: Theme.of(context).textTheme.labelLarge),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.star, size: 19, color: Colors.amber[300]),
                        const SizedBox(width: 3),
                        Text(
                          "${cake.rating} (${cake.reviewCount} reviews)",
                          style: TextStyle(fontSize: 13, color: Colors.grey[300]),
                        ),
                      ],
                    ),
                    const SizedBox(height: 7),
                    Text(cake.description, style: TextStyle(color: Colors.grey[300])),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.shopping_cart_outlined),
                      label: const Text('Customize and Add to Cart'),
                      onPressed: () async {
                        await showModalBottomSheet(
                          context: context,
                          backgroundColor: Theme.of(context).cardColor,
                          shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(18)),
                          ),
                          isScrollControlled: true,
                          builder: (_) => CakeCustomizationModal(cake: cake),
                        );
                      },
                    ),
                  ],
                ),
              ),
              // TODO: Add a section for cake reviews if provided by backend
            ],
          );
        },
      ),
    );
  }
}

class CakeCustomizationModal extends StatefulWidget {
  final Cake cake;
  const CakeCustomizationModal({required this.cake});

  @override
  State<CakeCustomizationModal> createState() => _CakeCustomizationModalState();
}

class _CakeCustomizationModalState extends State<CakeCustomizationModal> {
  String? _selectedSize;
  String? _selectedFlavor;
  final List<String> _selectedToppings = [];
  String _customMessage = '';
  int _quantity = 1;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // Fallbacks if empty
    final sizes = widget.cake.sizes.isEmpty ? ["Small", "Medium", "Large"] : widget.cake.sizes;
    final flavors = widget.cake.flavors.isEmpty ? ["Chocolate", "Vanilla"] : widget.cake.flavors;
    final toppings = widget.cake.toppings.isEmpty ? ["Sprinkles", "Fruit", "Nuts"] : widget.cake.toppings;

    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 18,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Customize Cake",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: "Size"),
              value: _selectedSize,
              items: sizes.map((size) => DropdownMenuItem(value: size, child: Text(size))).toList(),
              onChanged: (v) => setState(() => _selectedSize = v),
              validator: (v) => v == null ? 'Select size' : null,
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: "Flavor"),
              value: _selectedFlavor,
              items: flavors.map((flavor) => DropdownMenuItem(value: flavor, child: Text(flavor))).toList(),
              onChanged: (v) => setState(() => _selectedFlavor = v),
              validator: (v) => v == null ? 'Select flavor' : null,
            ),
            const SizedBox(height: 10),
            Wrap(
              runSpacing: 7,
              spacing: 6,
              children: toppings
                  .map(
                    (topping) => FilterChip(
                      label: Text(topping),
                      selected: _selectedToppings.contains(topping),
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            _selectedToppings.add(topping);
                          } else {
                            _selectedToppings.remove(topping);
                          }
                        });
                      },
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 10),
            TextFormField(
              decoration: const InputDecoration(labelText: "Custom Message (optional)"),
              onChanged: (v) => _customMessage = v,
            ),
            const SizedBox(height: 7),
            Row(
              children: [
                const Text("Quantity:"),
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline),
                  onPressed: () => setState(() => _quantity = (_quantity > 1) ? _quantity - 1 : 1),
                ),
                Text('$_quantity', style: const TextStyle(fontWeight: FontWeight.bold)),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  onPressed: () => setState(() => _quantity++),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              icon: const Icon(Icons.shopping_cart_checkout),
              label: const Text("Add to Cart"),
              onPressed: () {
                if (!_formKey.currentState!.validate()) return;
                Provider.of<CartProvider>(context, listen: false).addToCart(
                  widget.cake,
                  _selectedSize!,
                  _selectedFlavor!,
                  _selectedToppings,
                  _customMessage,
                  _quantity,
                );
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Cake added to cart')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
