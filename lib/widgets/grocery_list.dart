import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shopping_list/models/categories.dart';
import 'package:shopping_list/models/grocery_item.dart';
import 'package:shopping_list/widgets/new_item.dart';

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  @override
  void initState() {
    super.initState();
    _loadItem();
  }

  List<GroceryItem> _groceryList = [];
  var _isLoading = true;
  final List<GroceryItem> _loadedList = [];
  String? errorMessage;

  void _loadItem() async {
    try {
      final url = Uri.https(
          'flutter-grocerylist-89baa-default-rtdb.firebaseio.com',
          'grocery-list.json');
      final response = await http.get(url);
      print(response.statusCode);
      if (response.statusCode >= 400) {
        _isLoading = false;
        setState(
          () {
            errorMessage = 'Couldn\'t fetch data! Please try again later';
          },
        );
      }
      final Map<String, dynamic> listData = json.decode(response.body);
      for (final item in listData.entries) {
        final category = categories.entries
            .firstWhere(
              (cat) => cat.value.title == item.value['category'],
            )
            .value;
        _loadedList.add(
          GroceryItem(
            id: item.key,
            name: item.value['name'],
            quantity: item.value['quantity'],
            category: category,
          ),
        );
        setState(() {
          _groceryList = _loadedList;
        });
      }
    } catch (e) {
      errorMessage = 'Something Went Wrong! Please try again later.';
    }
  }

  void _newItem() async {
    final newItem = await Navigator.of(context).push<GroceryItem>(
      MaterialPageRoute(
        builder: ((context) => NewItem()),
      ),
    );
    if (newItem == null) {
      return;
    }
    setState(() {
      _groceryList.add(newItem);
      _isLoading = false;
    });
  }

  void _removeItem(item) {
    final url = Uri.https(
        'flutter-grocerylist-89baa-default-rtdb.firebaseio.com',
        'grocery-list/${item.id}.json');
    http.delete(url);
    setState(() {
      _groceryList.remove(item);
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget groceryListBody = const Center(
      child: Text(
        'No Items added... Click the + icon to add some.',
      ),
    );
    if (_isLoading) {
      groceryListBody = const Center(
        child: CircularProgressIndicator(),
      );
    }
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
              _removeItem(_groceryList[index]);
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

    if (errorMessage != null) {
      groceryListBody = Center(
        child: Text(errorMessage!),
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
