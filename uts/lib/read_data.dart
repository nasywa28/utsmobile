import 'package:flutter/material.dart';

class ReadData extends StatelessWidget {
  final String id;
  final String nama_produk;
  final String deskripsi_produk;

  const ReadData(
      {Key? key,
      required this.id,
      required this.nama_produk,
      required this.deskripsi_produk})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lihat Data"),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: [
            Text(
              'ID: $id',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'Nama Produk: $nama_produk',
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              'Deskripsi Produk: $deskripsi_produk',
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
