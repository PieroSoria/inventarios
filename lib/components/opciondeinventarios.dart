// import 'package:flutter/material.dart';

// import '../database/createdb/database.dart';
// SQLdb sqLdb = SQLdb();
// Future<dynamic> opcionde(
//     BuildContext context, List<Map<dynamic, dynamic>> listproducts, int index,TextEditingController nameexcel) {
//   return showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text("SELECCION UNA OPCION"),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               TextButton(
//                 onPressed: () async {
//                   showDialog(
//                     context: context,
//                     builder: (BuildContext context) {
//                       return AlertDialog(
//                         title: Text(
//                           'GUARDAR',
//                           style: TextStyle(color: Colors.blue.shade900),
//                         ),
//                         content: SingleChildScrollView(
//                           child: ListBody(
//                             children: [
//                               const SizedBox(height: 20),
//                               TextField(
//                                 controller: nameexcel,
//                                 style: TextStyle(
//                                     fontSize: 20, color: Colors.blue.shade900),
//                                 decoration: InputDecoration(
//                                   labelText: 'Digitar el nombre',
//                                   border: OutlineInputBorder(
//                                       borderRadius: BorderRadius.circular(20)),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         actions: [
//                           ElevatedButton(
//                             onPressed: () {
//                               String name =
//                                   nameexcel.text.trim().replaceAll(' ', '_');
//                               String nombretabla =
//                                   "${listproducts[index]['nombre']}";
//                               if (name != '') {
//                                 convertTableToExcel(name, nombretabla);
//                                 Navigator.of(context).pop();
//                               } else {
//                                 showDialog(
//                                   context: context,
//                                   builder: (context) => AlertDialog(
//                                     title: Text(
//                                       'ADVERTIENCIA!',
//                                       style: TextStyle(
//                                           color: Colors.blue.shade900),
//                                     ),
//                                     content: Text(
//                                       'RELLENE EL CAMPO NOMBRE',
//                                       style: TextStyle(
//                                           color: Colors.blue.shade900),
//                                     ),
//                                     actions: [
//                                       ElevatedButton(
//                                         onPressed: () {
//                                           Navigator.of(context).pop();
//                                         },
//                                         style: ElevatedButton.styleFrom(
//                                           foregroundColor: Colors.white,
//                                           backgroundColor: Colors.blue.shade900,
//                                           shape: const StadiumBorder(),
//                                           padding: const EdgeInsets.all(16.0),
//                                         ),
//                                         child: const Text(
//                                           'ACEPTAR',
//                                           style: TextStyle(color: Colors.white),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 );
//                               }
//                             },
//                             style: ElevatedButton.styleFrom(
//                               foregroundColor: Colors.white,
//                               backgroundColor: Colors.blue.shade900,
//                               shape: const StadiumBorder(),
//                               padding: const EdgeInsets.all(16.0),
//                             ),
//                             child: const Text(
//                               'ACEPTAR',
//                               style: TextStyle(color: Colors.white),
//                             ),
//                           ),
//                           ElevatedButton(
//                             onPressed: () => Navigator.of(context).pop(),
//                             style: ElevatedButton.styleFrom(
//                               foregroundColor: Colors.white,
//                               backgroundColor: Colors.blue.shade900,
//                               shape: const StadiumBorder(),
//                               padding: const EdgeInsets.all(16.0),
//                             ),
//                             child: const Text(
//                               'CANCELAR',
//                               style: TextStyle(color: Colors.white),
//                             ),
//                           ),
//                         ],
//                       );
//                     },
//                   );
//                 },
//                 child: Column(
//                   children: [
//                     Icon(
//                       Icons.explicit_outlined,
//                       color: Colors.blue.shade900,
//                       size: 25,
//                     ),
//                     const SizedBox(height: 5),
//                     Text(
//                       'Exportar a Excel',
//                       style: TextStyle(
//                         color: Colors.blue.shade900,
//                         fontSize: 18,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               TextButton(
//                   onPressed: () async {
//                     showDialog(
//                         context: context,
//                         builder: (context) => AlertDialog(
//                               title: Text(
//                                 "Desea abrir el inventario \"${listproducts[index]['nombre']}\"?",
//                                 textAlign: TextAlign.center,
//                                 style: TextStyle(color: Colors.blue.shade900),
//                               ),
//                               actions: [
//                                 ElevatedButton(
//                                   onPressed: () async {
//                                     bool rep4 = await sqLdb.updatedata(
//                                         "UPDATE inventarios SET activo = 'CERRADO'");
//                                     bool rep3 = await sqLdb.updatedata(
//                                         "UPDATE inventarios SET activo = 'ABIERTO' WHERE nombre = '${listproducts[index]['nombre']}'");
//                                     if (rep4 && rep3) {
//                                       // ignore: use_build_context_synchronously
//                                       Navigator.of(context).pop();
//                                       setState(() {});
//                                     }
//                                   },
//                                   child: const Text('Aceptar'),
//                                 ),
//                                 ElevatedButton(
//                                   onPressed: () async {
//                                     Navigator.of(context).pop();
//                                   },
//                                   child: const Text('Cancelar'),
//                                 ),
//                               ],
//                             ));
//                   },
//                   child: Column(
//                     children: [
//                       Icon(
//                         Icons.file_open_outlined,
//                         color: Colors.blue.shade900,
//                         size: 25,
//                       ),
//                       const SizedBox(height: 5),
//                       Text(
//                         'Abrir inventario',
//                         style: TextStyle(
//                           color: Colors.blue.shade900,
//                           fontSize: 18,
//                         ),
//                       ),
//                     ],
//                   )),
//               TextButton(
//                   onPressed: () {
//                     showDialog(
//                         context: context,
//                         builder: (context) => AlertDialog(
//                               title: Text(
//                                 "Esta seguro que desea eliminar el inventario \"${listproducts[index]['nombre']}\"",
//                                 textAlign: TextAlign.center,
//                                 style: TextStyle(color: Colors.blue.shade900),
//                               ),
//                               actions: [
//                                 ElevatedButton(
//                                   onPressed: () async {
//                                     bool rep = await sqLdb.deletedata(
//                                         "DELETE FROM inventarios WHERE id = ${listproducts[index]['id']}");
//                                     bool rep2 = await sqLdb.deletedata(
//                                         "DROP TABLE ${listproducts[index]['basedatos']}");
//                                     if (rep && rep2) {
//                                       // ignore: use_build_context_synchronously
//                                       Navigator.of(context).pop();
//                                       // ignore: use_build_context_synchronously
//                                       showDialog(
//                                         context: context,
//                                         builder: (context) => AlertDialog(
//                                           title: const Text('MENSAJE'),
//                                           content: SingleChildScrollView(
//                                             child: ListBody(
//                                               children: [
//                                                 Text(
//                                                   "El inventario \"${listproducts[index]['nombre']}\" fue eliminado",
//                                                   style: const TextStyle(
//                                                     fontSize: 18,
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                           actions: [
//                                             ElevatedButton(
//                                               onPressed: () async {
//                                                 Navigator.of(context).pop();
//                                                 setState(() {});
//                                               },
//                                               child: const Text('ACEPTAR'),
//                                             ),
//                                           ],
//                                         ),
//                                       );
//                                       setState(() {});
//                                     }
//                                   },
//                                   child: const Text('Aceptar'),
//                                 ),
//                                 ElevatedButton(
//                                   onPressed: () async {
//                                     Navigator.of(context).pop();
//                                   },
//                                   child: const Text('Cancelar'),
//                                 ),
//                               ],
//                             ));
//                   },
//                   child: Column(
//                     children: [
//                       Icon(
//                         Icons.delete,
//                         color: Colors.blue.shade900,
//                         size: 25,
//                       ),
//                       const SizedBox(height: 5),
//                       Text(
//                         'Eliminar inventario',
//                         style: TextStyle(
//                           color: Colors.blue.shade900,
//                           fontSize: 18,
//                         ),
//                       ),
//                     ],
//                   ))
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: const Text("VOLVER"),
//             ),
//           ],
//         );
//       });
// }
