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
    Widget groceryListBody = const Center(
      child: Text(
        'No Items added... Click the + icon to add some.',
      ),
    );
    if (_groceryList.isNotEmpty) {
      groceryListBody = ListView.builder(
        itemCount: _groceryList.length,
        itemBuilder: (ctx, index) => Dismissible(
          key: ValueKey(
            _groceryList[index],
          ),
          background: const Card(
            color: Colors.red,
          ),
          onDismissed: (direction) {
            setState(() {
              _groceryList.removeAt(index);
            });
          },
          child: ListTile(
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
      body: groceryListBody,
    );
  }
}
