import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/mahasiswa.dart';

class ApiService {
  static const String baseUrl =
      'http://127.0.0.1:8000/api/mahasiswa';

  static Future<List<Mahasiswa>> getMahasiswa() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);

      return data.map((e) => Mahasiswa.fromJson(e)).toList();
    } else {
      throw Exception('Gagal mengambil data');
    }
  }

  static Future<void> tambahMahasiswa(
    String nama,
    String nim,
    String jurusan,
  ) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'nama': nama,
        'nim': nim,
        'jurusan': jurusan,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Gagal menambah data');
    }
  }

  static Future<void> updateMahasiswa(
    int id,
    String nama,
    String nim,
    String jurusan,
  ) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'nama': nama,
        'nim': nim,
        'jurusan': jurusan,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Gagal update data');
    }
  }

  static Future<void> deleteMahasiswa(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/$id'),
    );

    if (response.statusCode != 200) {
      throw Exception('Gagal menghapus data');
    }
  }
}
