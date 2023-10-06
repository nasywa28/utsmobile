import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:uts/edit_data.dart';
import 'package:uts/read_data.dart';
import 'package:uts/side_menu.dart';
import 'package:uts/tambah_data.dart';
import 'package:flutter/material.dart';
// import 'package:read_edit/side_menu.dart';
// import 'package:read_edit/tambah_data.dart';
import 'package:http/http.dart' as http;
//import 'package:universal_platform/universal_platform.dart';

class ListData extends StatefulWidget {
  const ListData({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ListDataState createState() => _ListDataState();
}

class _ListDataState extends State<ListData> {
  List<Map<String, String>> dataProduk = [];
  // String url = Platform.isAndroid
  //     ? 'http://10.101.3.95/tugaspemmob/index.php'
  //     : 'http://localhost/api_flutter/index.php';
  String url = 'http://192.168.21.71/dbuts/index.php';
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        dataProduk = List<Map<String, String>>.from(data.map((item) {
          return {
            'nama_produk': item['nama_produk'] as String,
            'deskripsi_produk': item['deskripsi_produk'] as String,
            'id': item['id'] as String,
          };
        }));
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future deleteData(int id) async {
    final response = await http.delete(Uri.parse('$url?id=$id'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to delete data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List Data Produk'),
      ),
      drawer: const SideMenu(),
      body: Column(children: <Widget>[
        ElevatedButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const TambahData(),
              ),
            );
          },
          child: const Text('Tambah Data Produk'),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: dataProduk.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(dataProduk[index]['nama_produk']!),
                subtitle: Text(
                    'deskripsi_produk: ${dataProduk[index]['deskripsi_produk']}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    IconButton(
                      icon: const Icon(Icons.visibility),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ReadData(
                                id: dataProduk[index]['id'].toString(),
                                nama_produk:
                                    dataProduk[index]['nama_produk'] as String,
                                deskripsi_produk: dataProduk[index]
                                    ['deskripsi_produk'] as String),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => EditData(
                                id: dataProduk[index]['id'].toString(),
                                nama_produk:
                                    dataProduk[index]['nama_produk'] as String,
                                deskripsi_produk: dataProduk[index]
                                    ['deskripsi_produk'] as String),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        deleteData(int.parse(dataProduk[index]['id']!))
                            .then((result) {
                          if (result['pesan'] == 'berhasil') {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text('Data berhasil di hapus'),
                                    content: const Text('ok'),
                                    actions: [
                                      TextButton(
                                        child: const Text('OK'),
                                        onPressed: () {
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const ListData(),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  );
                                });
                          }
                        });
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        )
      ]),
    );
  }
}
