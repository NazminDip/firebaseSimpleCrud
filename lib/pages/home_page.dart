import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CollectionReference _products =
      FirebaseFirestore.instance.collection('productions');
  /*

        await _products.add({"name": name, "price":price});
        await _products.update({"name": name, "price":price});
        await _products.doc(productId).delete();
      */
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
          backgroundColor: Colors.teal,
          title: const Text(
            'FireBase Crud',
            style: TextStyle(color: Colors.white, fontSize: 30),
          )),
   
      backgroundColor: Colors.teal,
      body: StreamBuilder(
        stream: _products.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData) {
            return ListView.builder(
              itemCount: streamSnapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final DocumentSnapshot documentSnapshot =
                    streamSnapshot.data!.docs[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: ListTile(
                      title: Text(documentSnapshot['name'],
                          style: const TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold)),
                      subtitle: Text(documentSnapshot['price'].toString(),
                          style: const TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold)),
                      //Update
                      trailing: SizedBox(
                        width: 100,
                        child: Row(
                          children: [
                            IconButton(
                                onPressed: () {
                                  _update(documentSnapshot);
                                },
                                icon: const Icon(Icons.edit,
                                    size: 40, color: Colors.teal)),

                            //Delete
                            IconButton(
                                onPressed: () {
                                  _delete(documentSnapshot.id);
                                },
                                icon: const Icon(Icons.delete,
                                    size: 40, color: Colors.red))
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.red,
            ),
          );
        },
      ),

      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.teal,
        onPressed: () {
          _create();
        },
        label: const Text('Create',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 30)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      ),
    );
  }

  //Create
  Future<void> _create([DocumentSnapshot? documentSnapshot]) async {
    if (documentSnapshot != null) {
      _nameController.text = documentSnapshot['name'];
      _priceController.text = documentSnapshot['price'].toString();
    }
    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
              padding: EdgeInsets.only(
                  top: 20,
                  left: 20,
                  right: 20,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 20),
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(labelText: 'Name'),
                    ),
                    TextField(
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      controller: _priceController,
                      decoration: const InputDecoration(labelText: 'Price'),
                    ),
                    const SizedBox(height: 20),
                    //Update Button

                    ElevatedButton(
                        onPressed: () async {
                          final String name = _nameController.text;
                          final double? price =
                              double.tryParse(_priceController.text);
                          if (price != null) {
                            await _products.add({"name": name, "price": price});
                            _nameController.text = '';
                            _priceController.text = '';
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            fixedSize: const Size(240, 80),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50)),
                            backgroundColor: Colors.teal),
                        child: const Text(
                          'Create',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 25),
                        )),
                  ]));
        });
  }

  //Update
  Future<void> _update([DocumentSnapshot? documentSnapshot]) async {
    if (documentSnapshot != null) {
      _nameController.text = documentSnapshot['name'];
      _priceController.text = documentSnapshot['price'].toString();
    }
    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
              padding: EdgeInsets.only(
                  top: 20,
                  left: 20,
                  right: 20,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 20),
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(labelText: 'Name'),
                    ),
                    TextField(
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      controller: _priceController,
                      decoration: const InputDecoration(labelText: 'Price'),
                    ),
                    const SizedBox(height: 20),
                    //Update Button

                    ElevatedButton(
                        onPressed: () async {
                          final String name = _nameController.text;
                          final double? price =
                              double.tryParse(_priceController.text);
                          if (price != null) {
                            await _products
                                .doc(documentSnapshot!.id)
                                .update({"name": name, "price": price});
                            _nameController.text = '';
                            _priceController.text = '';
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            fixedSize: const Size(240, 80),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50)),
                            backgroundColor: Colors.teal),
                        child: const Text(
                          'Update',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 25),
                        )),
                  ]));
        });
  }
  //Delete

  Future<void> _delete(String productId) async {
    await _products.doc(productId).delete();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('You have successfully deleted a product')));
  }
}
