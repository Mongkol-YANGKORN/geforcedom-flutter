import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const MyHomePage(title: 'Add loction dom'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _domNameController = TextEditingController();
  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _longitudeController = TextEditingController();
  final CollectionReference location =
      FirebaseFirestore.instance.collection('location');

  // create and update
  Future<void> _createOrUpdate([DocumentSnapshot? documentSnapshot]) async {
    String action = 'create';
    if (documentSnapshot != null) {
      action = 'update';
      _domNameController.text = documentSnapshot['Dom'];
      _latitudeController.text = documentSnapshot['latitude'];
      _longitudeController.text = documentSnapshot['longitude'];
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
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
            child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _domNameController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: "Dom name",
                      hintText: 'Enter dom name',
                      border: OutlineInputBorder(),
                      hintStyle: TextStyle(color: Colors.grey),
                      labelStyle: TextStyle(color: Colors.black),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    controller: _latitudeController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: "Latitude",
                      hintText: 'Enter Latitude',
                      border: OutlineInputBorder(),
                      hintStyle: TextStyle(color: Colors.grey),
                      labelStyle: TextStyle(color: Colors.black),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    controller: _longitudeController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: "Longitude",
                      hintText: 'Enter Longitude',
                      border: OutlineInputBorder(),
                      hintStyle: TextStyle(color: Colors.grey),
                      labelStyle: TextStyle(color: Colors.black),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        final String? Dom = _domNameController.text;
                        final String? latitude = _latitudeController.text;
                        final String? longitude = _longitudeController.text;

                        if (Dom != null &&
                            latitude != null &&
                            longitude != null) {
                          if (action == 'create') {
                            await location.add({
                              'Dom': Dom,
                              "latitude": latitude,
                              "longitude": longitude
                            });
                          }
                          if (action == 'update') {
                            await location.doc(documentSnapshot!.id).update({
                              'Dom': Dom,
                              "latitude": latitude,
                              "longitude": longitude
                            });
                          }
                          _domNameController.text = '';
                          _latitudeController.text = '';
                          _longitudeController.text = '';

                          Navigator.of(context).pop();
                        }
                      },
                      child: Text(action == 'create' ? 'Create' : 'Update'))
                ]),
          );
        });
  }

  // delete
  Future<void> _deleteProduct(String productId) async {
    await location.doc(productId).delete();

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Delete complete")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: StreamBuilder(
        stream: location.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData) {
            return ListView.builder(
              itemCount: streamSnapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final DocumentSnapshot documentSnapshot =
                    streamSnapshot.data!.docs[index];
                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    title: Text(documentSnapshot['Dom'].toString()),
                    trailing: SizedBox(
                      width: 100,
                      child: Row(
                        children: [
                          IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () =>
                                  _createOrUpdate(documentSnapshot)),
                          IconButton(
                              onPressed: () =>
                                  _deleteProduct(documentSnapshot.id),
                              icon: const Icon(Icons.delete)),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _createOrUpdate(),
        child: const Icon(Icons.add),
      ),
    );
  }
}



// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(const AddlocationDom());
// }

// class AddlocationDom extends StatelessWidget {
//   const AddlocationDom({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Add location dom"),
//         centerTitle: true,
//       ),
//     );
//   }
// }

// class AddLocationDom extends StatefulWidget {
//   const AddLocationDom({Key? key}) : super(key: key);

//   @override
//   State<AddLocationDom> createState() => _AddLocationDomState();
// }

// class _AddLocationDomState extends State<AddLocationDom> {
//   final TextEditingController _domNameController = TextEditingController();
//   final TextEditingController _latitudeController = TextEditingController();
//   final TextEditingController _longitudeController = TextEditingController();
//   final CollectionReference location =
//       FirebaseFirestore.instance.collection('location');

//   Future<void> _createOrUpdate([DocumentSnapshot? documentSnapshot]) async {
//     String action = 'create';
//     if (documentSnapshot != null) {
//       action = 'update';
//       _domNameController.text = documentSnapshot['Dom'];
//       _latitudeController.text = documentSnapshot['latitude'];
//       _longitudeController.text = documentSnapshot['longitude'];
//     }
//     await showModalBottomSheet(
//         isScrollControlled: true,
//         context: context,
//         builder: (BuildContext ctx) {
//           return Padding(
//             padding: EdgeInsets.only(
//                 top: 20,
//                 left: 20,
//                 right: 20,
//                 bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
//             child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   TextFormField(
//                     controller: _domNameController,
//                     keyboardType: TextInputType.text,
//                     decoration: InputDecoration(
//                       labelText: "Dom name",
//                       hintText: 'Enter dom name',
//                       border: OutlineInputBorder(),
//                       hintStyle: TextStyle(color: Colors.grey),
//                       labelStyle: TextStyle(color: Colors.black),
//                     ),
//                   ),
//                   SizedBox(
//                     height: 30,
//                   ),
//                   TextFormField(
//                     controller: _latitudeController,
//                     keyboardType: TextInputType.text,
//                     decoration: InputDecoration(
//                       labelText: "Latitude",
//                       hintText: 'Enter Latitude',
//                       border: OutlineInputBorder(),
//                       hintStyle: TextStyle(color: Colors.grey),
//                       labelStyle: TextStyle(color: Colors.black),
//                     ),
//                   ),
//                   SizedBox(
//                     height: 30,
//                   ),
//                   TextFormField(
//                     controller: _longitudeController,
//                     keyboardType: TextInputType.text,
//                     decoration: InputDecoration(
//                       labelText: "Longitude",
//                       hintText: 'Enter Longitude',
//                       border: OutlineInputBorder(),
//                       hintStyle: TextStyle(color: Colors.grey),
//                       labelStyle: TextStyle(color: Colors.black),
//                     ),
//                   ),
//                   SizedBox(
//                     height: 30,
//                   ),
//                   ElevatedButton(
//                       onPressed: () async {
//                         final String? Dom = _domNameController.text;
//                         final String? latitude = _latitudeController.text;
//                         final String? longitude = _longitudeController.text;

//                         if (Dom != null &&
//                             latitude != null &&
//                             longitude != null) {
//                           if (action == 'create') {
//                             await location.add({
//                               'Dom': Dom,
//                               "latitude": latitude,
//                               "longitude": longitude
//                             });
//                           }
//                           if (action == 'update') {
//                             await location.doc(documentSnapshot!.id).update({
//                               'Dom': Dom,
//                               "latitude": latitude,
//                               "longitude": longitude
//                             });
//                           }
//                           _domNameController.text = '';
//                           _latitudeController.text = '';
//                           _longitudeController.text = '';

//                           Navigator.of(context).pop();
//                         }
//                       },
//                       child: Text(action == 'create' ? 'Create' : 'Update'))
//                 ]),
//           );
//         });
//   }

//   // delete
//   Future<void> _deleteProduct(String productId) async {
//     await location.doc(productId).delete();

//     ScaffoldMessenger.of(context)
//         .showSnackBar(const SnackBar(content: Text("Delete complete")));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: StreamBuilder(
//         stream: location.snapshots(),
//         builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
//           if (streamSnapshot.hasData) {
//             return ListView.builder(
//               itemCount: streamSnapshot.data!.docs.length,
//               itemBuilder: (context, index) {
//                 final DocumentSnapshot documentSnapshot =
//                     streamSnapshot.data!.docs[index];
//                 return Card(
//                   margin: const EdgeInsets.all(10),
//                   child: ListTile(
//                     title: Text(documentSnapshot['Dom'].toString()),
//                     trailing: SizedBox(
//                       width: 100,
//                       child: Row(
//                         children: [
//                           IconButton(
//                               icon: const Icon(Icons.edit),
//                               onPressed: () =>
//                                   _createOrUpdate(documentSnapshot)),
//                           IconButton(
//                               onPressed: () =>
//                                   _deleteProduct(documentSnapshot.id),
//                               icon: const Icon(Icons.delete)),
//                         ],
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             );
//           }
//           return const Center(
//             child: CircularProgressIndicator(),
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () => _createOrUpdate(),
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
// }
