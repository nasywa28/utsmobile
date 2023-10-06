import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:uts/list_data.dart';

class EditData extends StatefulWidget {
  final String id;
  final String nama_produk;
  final String deskripsi_produk;

  const EditData(
      {Key? key,
      required this.id,
      required this.nama_produk,
      required this.deskripsi_produk})
      : super(key: key);

  @override
  _EditDataState createState() => _EditDataState();
}

class _EditDataState extends State<EditData> {
  final nama_produkController = TextEditingController();
  final deskripsi_produkController = TextEditingController();

  Future<bool> editData(String id) async {
    String url = 'http://192.168.21.71/dbuts/index.php';
    Map<String, String> headers = {'Content-Type': 'application/json'};
    String jsonBody =
        '{"id": "${widget.id}", "nama_produk": "${nama_produkController.text}", "deskripsi_produk": "${deskripsi_produkController.text}"}';
    var response =
        await http.put(Uri.parse(url), body: jsonBody, headers: headers);
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    nama_produkController.value = TextEditingValue(text: widget.nama_produk);
    deskripsi_produkController.value =
        TextEditingValue(text: widget.deskripsi_produk);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Data'),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: nama_produkController,
              decoration: const InputDecoration(
                hintText: 'Nama Produk',
              ),
            ),
            TextField(
              controller: deskripsi_produkController,
              decoration: const InputDecoration(
                hintText: 'Deskripsi Produk',
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                await editData(widget.id)
                    ? showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Success"),
                            content: const Text("Data berhasil di edit."),
                            actions: <Widget>[
                              TextButton(
                                child: const Text("OK"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => const ListData()));
                                },
                              ),
                            ],
                          );
                        },
                      )
                    : false;
              },
              child: const Text("Edit"),
            ),
          ],
        ),
      ),
    );
  }
}
