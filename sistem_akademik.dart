import 'dart:io';

// --- CLASS DOSEN ---
class Dosen {
  String nidn;
  String nama;
  String bidangKeahlian;

  Dosen(this.nidn, this.nama, this.bidangKeahlian);

  @override
  String toString() {
    return 'NIDN: $nidn | Nama: $nama | Keahlian: $bidangKeahlian';
  }
}

// --- CLASS MAHASISWA ---
class Mahasiswa {
  String npm;
  String nama;
  String prodi;
  int angkatan;
  Dosen? pa; // Pembimbing Akademik (PA)

  Mahasiswa(this.npm, this.nama, this.prodi, this.angkatan, {this.pa});

  void tampilkanDetail() {
    print('-----------------------------------------');
    print('NPM       : $npm');
    print('Nama      : $nama');
    print('Program Studi: $prodi');
    print('Angkatan  : $angkatan');
    print(
      'Pembimbing Akademik (PA): ${pa?.nama ?? 'Belum Ditentukan'} (NIDN: ${pa?.nidn ?? '-'})',
    );
    print('-----------------------------------------');
  }

  // Metode untuk mencocokkan data pencarian
  bool cocokDengan(String kriteria) {
    String kriteriaLower = kriteria.toLowerCase();
    return nama.toLowerCase().contains(kriteriaLower) ||
        npm.toLowerCase().contains(kriteriaLower) ||
        prodi.toLowerCase().contains(kriteriaLower);
  }
}

// --- VARIABEL GLOBAL UNTUK PENYIMPANAN DATA ---
List<Dosen> daftarDosen = [];
List<Mahasiswa> daftarMahasiswa = [];

// --- FUNGSI UTAMA (MAIN) ---
void main() {
  // Inisialisasi data dosen (minimal 5 data)
  daftarDosen.add(
    Dosen(
      '1001',
      'Saiful Do Abdullah, S.T., M.T',
      'Sistem Operasi Berbasis Jaringan',
    ),
  );
  daftarDosen.add(
    Dosen(
      '1002',
      'Ir. Abdul Mubarak, S.kom., M.T.IPM',
      'Keamanan Jaringan Komputer',
    ),
  );
  daftarDosen.add(
    Dosen('1003', ' Hairil Kurniadi, S.Kom,. M.Kom', 'Metode Penulisan Ilmiah'),
  );
  daftarDosen.add(
    Dosen(
      '1004',
      'Arifandy Maryo Mamonto, S.Kom, M.Kom',
      'Tata Kelola TeknologI Informasi',
    ),
  );
  daftarDosen.add(
    Dosen('1005', 'Ir. Salkin Lutfi, S.Kom., M.T', 'Pemograman Web'),
  );

  // Main Menu Loop
  bool running = true;
  while (running) {
    tampilkanMenu();
    stdout.write('Pilihan Anda (1-5): ');
    String? pilihan = stdin.readLineSync();

    switch (pilihan) {
      case '1':
        inputDataMahasiswa();
        break;
      case '2':
        tampilkanDataDosen();
        break;
      case '3':
        cariDataMahasiswa();
        break;
      case '4':
        tampilkanSemuaMahasiswa();
        break;
      case '5':
        running = false;
        print('\nTerima kasih! Program selesai.');
        break;
      default:
        print('Pilihan tidak valid. Silakan coba lagi.');
    }
    if (running) {
      print('\nTekan ENTER untuk melanjutkan...');
      stdin.readLineSync();
    }
  }
}

// --- FUNGSI-FUNGSI PROGRAM ---

void tampilkanMenu() {
  print('\n===== SISTEM MANAJEMEN AKADEMIK SEDERHANA =====');
  print('1. Input Data Mahasiswa');
  print('2. Tampilkan Data Dosen');
  print('3. Cari Data Mahasiswa');
  print('4. Tampilkan Semua Data Mahasiswa');
  print('5. Keluar');
  print('===============================================');
}

void tampilkanDataDosen() {
  print('\n===== DAFTAR DOSEN =====');
  if (daftarDosen.isEmpty) {
    print('Tidak ada data dosen.');
    return;
  }
  for (var i = 0; i < daftarDosen.length; i++) {
    print('${i + 1}. ${daftarDosen[i]}');
  }
}

void inputDataMahasiswa() {
  print('\n===== INPUT DATA MAHASISWA =====');

  stdout.write('NPM: ');
  String? npm = stdin.readLineSync()?.trim();
  if (npm == null || npm.isEmpty) {
    print('NPM tidak boleh kosong.');
    return;
  }

  stdout.write('Nama: ');
  String? nama = stdin.readLineSync()?.trim();
  if (nama == null || nama.isEmpty) {
    print('Nama tidak boleh kosong.');
    return;
  }

  stdout.write('Program Studi: ');
  String? prodi = stdin.readLineSync()?.trim();
  if (prodi == null || prodi.isEmpty) {
    print('Program Studi tidak boleh kosong.');
    return;
  }

  stdout.write('Angkatan: ');
  int? angkatan;
  try {
    angkatan = int.parse(stdin.readLineSync()!.trim());
  } catch (e) {
    print('Input Angkatan tidak valid (harus angka).');
    return;
  }

  // Pemilihan Dosen PA
  tampilkanDataDosen();
  stdout.write(
    'Pilih nomor Dosen PA (1-${daftarDosen.length}) atau tekan ENTER untuk lewati: ',
  );
  String? pilihanDosen = stdin.readLineSync()?.trim();
  Dosen? dosenPA;
  if (pilihanDosen != null && pilihanDosen.isNotEmpty) {
    try {
      int indexDosen = int.parse(pilihanDosen) - 1;
      if (indexDosen >= 0 && indexDosen < daftarDosen.length) {
        dosenPA = daftarDosen[indexDosen];
        print('Dosen PA dipilih: ${dosenPA.nama}');
      } else {
        print('Nomor dosen tidak valid. Dosen PA dikosongkan.');
      }
    } catch (e) {
      print('Input tidak valid. Dosen PA dikosongkan.');
    }
  }

  // Buat objek Mahasiswa dan tambahkan ke list
  Mahasiswa mhsBaru = Mahasiswa(npm, nama, prodi, angkatan, pa: dosenPA);
  daftarMahasiswa.add(mhsBaru);

  print('\nData Mahasiswa ${nama} berhasil ditambahkan!');
  mhsBaru.tampilkanDetail();
}

void cariDataMahasiswa() {
  print('\n===== CARI DATA MAHASISWA =====');
  if (daftarMahasiswa.isEmpty) {
    print('Tidak ada data mahasiswa untuk dicari.');
    return;
  }

  stdout.write('Masukkan kriteria pencarian (Nama/NPM/Prodi): ');
  String? kriteria = stdin.readLineSync()?.trim();
  if (kriteria == null || kriteria.isEmpty) {
    print('Kriteria pencarian tidak boleh kosong.');
    return;
  }

  List<Mahasiswa> hasilPencarian = daftarMahasiswa
      .where((mhs) => mhs.cocokDengan(kriteria))
      .toList();

  if (hasilPencarian.isEmpty) {
    print('Tidak ditemukan data mahasiswa dengan kriteria "$kriteria".');
    return;
  }

  print('\n${hasilPencarian.length} Data Mahasiswa Ditemukan:');
  for (var i = 0; i < hasilPencarian.length; i++) {
    print(
      '${i + 1}. [${hasilPencarian[i].prodi}] ${hasilPencarian[i].nama} (${hasilPencarian[i].npm})',
    );
  }

  // Cari salah satu dari 5 data (atau yang ditemukan)
  if (hasilPencarian.isNotEmpty) {
    stdout.write(
      '\nPilih nomor data (1-${hasilPencarian.length}) untuk melihat detail: ',
    );
    String? pilihanDetail = stdin.readLineSync()?.trim();
    try {
      int indexDetail = int.parse(pilihanDetail!) - 1;
      if (indexDetail >= 0 && indexDetail < hasilPencarian.length) {
        print('\n--- DETAIL MAHASISWA ---');
        hasilPencarian[indexDetail].tampilkanDetail();
      } else {
        print('Nomor pilihan tidak valid.');
      }
    } catch (e) {
      print('Input tidak valid.');
    }
  }
}

void tampilkanSemuaMahasiswa() {
  print('\n===== SEMUA DATA MAHASISWA (${daftarMahasiswa.length} DATA) =====');
  if (daftarMahasiswa.isEmpty) {
    print('Tidak ada data mahasiswa.');
    return;
  }

  for (var i = 0; i < daftarMahasiswa.length; i++) {
    print(
      '${i + 1}. NPM: ${daftarMahasiswa[i].npm} | Nama: ${daftarMahasiswa[i].nama} | Prodi: ${daftarMahasiswa[i].prodi} | PA: ${daftarMahasiswa[i].pa?.nama ?? '-'}',
    );
  }
}
