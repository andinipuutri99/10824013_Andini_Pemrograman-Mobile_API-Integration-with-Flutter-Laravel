class Mahasiswa {
  final int id;
  final String nama;
  final String nim;
  final String jurusan;

  Mahasiswa({
    required this.id,
    required this.nama,
    required this.nim,
    required this.jurusan,
  });

  factory Mahasiswa.fromJson(Map<String, dynamic> json) {
    return Mahasiswa(
      id: json['id'],
      nama: json['nama'],
      nim: json['nim'],
      jurusan: json['jurusan'],
    );
  }
}