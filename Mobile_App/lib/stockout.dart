import 'package:flutter/material.dart';
import 'package:inventory/Services/database.dart';
import 'package:inventory/models/products.dart';
import 'package:inventory/ItemsCard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:inventory/showDialog.dart';

class StockOutPage extends StatefulWidget {
  @override
  _StockOutPageState createState() => _StockOutPageState();
}

class _StockOutPageState extends State<StockOutPage> {
  final TextEditingController _pidController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final FirestoreService _firestoreService = FirestoreService();
  String? _selectedOption;
  Product? _selectedProduct;
  late Product pro;

  @override
  void dispose() {
    _pidController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  Future<void> _fetchProductByPid(String pid) async {
    try {
      Product product = await _firestoreService.getProductByPid(pid);
      setState(() {
        _selectedProduct = product;
        pro = product;
      });
    } catch (error) {
      print('Error fetching product: $error');
      _showAlertDialog('Error', 'Product not found');
    }
  }

  void _handleOptionChange(String? option) {
    setState(() {
      _selectedOption = option;
    });
  }

  Future<void> registerTransaction() async {
    print(" ********** transaction update");
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    User? user = FirebaseAuth.instance.currentUser;
    final transactionsRef = _firestore
        .collection('users')
        .doc(user!.uid)
        .collection('transactions');

    await transactionsRef.add({
      'productId': _selectedProduct!.pid,
      'quantitySold': int.parse(_quantityController.text),
      'saleDate': FieldValue.serverTimestamp(),
    });

    // Update product status or other necessary actions
  }

  Future<void> _updateProductQuantity() async {
    if (_selectedOption == null ||
        _quantityController.text.isEmpty ||
        _selectedProduct == null) {
      return; // Ensure both option, quantity, and product are selected
    }

    final int quantity = int.parse(_quantityController.text);
    int newQuantity = _selectedProduct!.quantity;

    if (_selectedOption == "Sold Out" || _selectedOption == "Worn Out") {
      if (quantity > newQuantity) {
        _showAlertDialog("Error", "Quantity is greater than available stock.");
        return;
      }
      newQuantity -= quantity;
    }
    if (_selectedOption == "Sold Out") {
      registerTransaction();
    }

    if (newQuantity <= 0) {
      await _firestoreService.deleteProduct(_selectedProduct!.pid);
    } else {
      await _firestoreService.updateProduct(_selectedProduct!.pid, {
        'quantity': newQuantity,
      });
    }
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text('product $_selectedOption successfuly'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showAlertDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color.fromRGBO(107, 59, 225, 1),
        title: Text('Stock OUt'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                cursorColor: Color.fromRGBO(107, 59, 225, 1),
                controller: _pidController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    labelText: 'Product ID',
                    labelStyle:
                        TextStyle(color: Color.fromRGBO(107, 59, 225, 1)),
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color.fromRGBO(107, 59, 225, 1))),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromRGBO(107, 59, 225, 1)))),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  await _fetchProductByPid(_pidController.text);
                },
                child: Text('Fetch Product'),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Color.fromRGBO(107, 59, 225, 1)),
                ),
              ),
              const SizedBox(height: 16),
              if (_selectedProduct != null) ...[
                Text(
                  'Selected Product',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                ItmeCard(pro),
                Text(
                  'Select Stock Out Option:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                ListTile(
                  title: Text('Sold Out'),
                  leading: Radio<String>(
                    activeColor: Color.fromRGBO(107, 59, 225, 1),
                    value: 'Sold Out',
                    groupValue: _selectedOption,
                    onChanged: _handleOptionChange,
                  ),
                ),
                ListTile(
                  title: Text('Worn Out'),
                  leading: Radio<String>(
                    activeColor: Color.fromRGBO(107, 59, 225, 1),
                    value: 'Worn Out',
                    groupValue: _selectedOption,
                    onChanged: _handleOptionChange,
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _quantityController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      labelText: 'Quantity',
                      labelStyle:
                          TextStyle(color: Color.fromRGBO(107, 59, 225, 1)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromRGBO(107, 59, 225, 1))),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromRGBO(107, 59, 225, 1)))),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _updateProductQuantity,
                  child: Text('Update Quantity'),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Color.fromRGBO(107, 59, 225, 1))),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
