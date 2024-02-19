import 'package:flutter/material.dart';
import 'package:shopping_list/models/grocery_item.dart';
import 'package:shopping_list/widgets/new_item.dart';

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  final List<GroceryItem> _groceryList = [];
  void _newItem() async {
    final newItem = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: ((context) => NewItem()),
      ),
    );
    setState(() {
      _groceryList.add(newItem);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Grocery List'),
        actions: [
          IconButton(
            onPressed: _newItem,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _groceryList.length,
        itemBuilder: (ctx, index) => ListTile(
          title: Text(_groceryList[index].name),
          leading: Container(
            width: 20,
            height: 20,
            color: _groceryList[index].category.color,
          ),
          trailing: Text(_groceryList[index].quantity.toString()),
        ),
      ),
    );
  }
}
