import 'dart:convert';
import 'dart:io';
import 'package:uts/list_data.dart';

import 'package:uts/side_menu.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TambahData extends StatefulWidget {
  const TambahData({Key? key}) : super(key: key);

  @override
  _TambahDataState createState() => _TambahDataState();
}

class _TambahDataState extends State<TambahData> {
  final nama_produkController = TextEditingController();
  final deksripsi_produkController = TextEditingController();

  Future postData(String nama_produk, String deskripsi_produk) async {
    String url = 'http://192.168.21.71/dbuts/index.php';

    Map<String, String> headers = {'Content-Type': 'application/json'};
    String jsonBody =
        '{"nama_produk": "$nama_produk", "deskripsi_produk": "$deskripsi_produk"}';
    var response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonBody,
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to add data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Data Produk'),
      ),
      drawer: const SideMenu(),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextField(
              controller: nama_produkController,
              decoration: const InputDecoration(
                hintText: 'Nama Produk',
              ),
            ),
            TextField(
              controller: deksripsi_produkController,
              decoration: const InputDecoration(
                hintText: 'Deskripsi Produk',
              ),
            ),
            ElevatedButton(
              child: const Text('Tambah Produk'),
              onPressed: () {
                String nama_produk = nama_produkController.text;
                String deskripsi_produk = deksripsi_produkController.text;
                // print(nama);
                postData(nama_produk, deskripsi_produk).then((result) {
                  //print(result['pesan']);
                  if (result['pesan'] == 'berhasil') {
                    showDialog(
                        context: context,
                        builder: (context) {
                          //var namauser2 = namauser;
                          return AlertDialog(
                            title: const Text('Data berhasil di tambah'),
                            content: const Text('ok'),
                            actions: [
                              TextButton(
                                child: const Text('OK'),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const ListData(),
                                    ),
                                  );
                                },
                              ),
                            ],
                          );
                        });
                  }
                  setState(() {});
                });
              },
            ),
          ],
        ),

        //     ],
        //   ),
        // ),
      ),
    );
  }
}
