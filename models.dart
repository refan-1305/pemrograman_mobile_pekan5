// -------  Nama Program : Login dan Register -------
//------- Author : Refan Rustoni Putra ------
//------- Versi : 10  ------
//------- Ownership : Pribadi------
//------- Deskripsi : Pembuatan halaman Login, Dashboard dan Profile ------

//------- Library ---------

// ─── USER MODEL ─────────────────────────────────────────

class User {
  final int? id;
  final String nim;
  final String nama;
  final String kelas;
  final String prodi;
  final int angkatan;
  final String foto;
  final String password;

  final String gpa;
  final int hadirCount;
  final int totalPertemuan;

  User({
    this.id,
    required this.nim,
    required this.nama,
    required this.kelas,
    required this.prodi,
    required this.angkatan,
    required this.foto,
    required this.password,
    this.gpa = '0.00',
    this.hadirCount = 0,
    this.totalPertemuan = 16,
  });

  String get tahunMasuk => angkatan.toString();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nim': nim,
      'nama': nama,
      'kelas': kelas,
      'prodi': prodi,
      'angkatan': angkatan,
      'foto': foto,
      'password': password,
      'gpa': gpa,
      'hadirCount': hadirCount,
      'totalPertemuan': totalPertemuan,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as int?,
      nim: map['nim'] ?? '',
      nama: map['nama'] ?? '',
      kelas: map['kelas'] ?? '',
      prodi: map['prodi'] ?? '',
      angkatan: map['angkatan'] ?? 0,
      foto: map['foto'] ?? '',
      password: map['password'] ?? '',
      gpa: map['gpa'] ?? '0.00',
      hadirCount: map['hadirCount'] ?? 0,
      totalPertemuan: map['totalPertemuan'] ?? 16,
    );
  }
}

////////////////////////////////////////////////////////////

// ─── ATTENDANCE STATUS ───────────────────────────────────

enum AttendanceStatus { hadir, tidakHadir, online }

extension AttendanceStatusX on AttendanceStatus {
  String get label {
    switch (this) {
      case AttendanceStatus.hadir:
        return 'Hadir';
      case AttendanceStatus.tidakHadir:
        return 'Tidak Hadir';
      case AttendanceStatus.online:
        return 'Online';
    }
  }
}

////////////////////////////////////////////////////////////

// ─── SCHEDULE MODEL ──────────────────────────────────────

class ScheduleItem {
  final String hari;
  final String jam;
  final String matakuliah;
  final String dosen;
  final AttendanceStatus status;

  const ScheduleItem({
    required this.hari,
    required this.jam,
    required this.matakuliah,
    required this.dosen,
    required this.status,
  });
}

////////////////////////////////////////////////////////////

// ─── NEWS MODEL ──────────────────────────────────────────

class NewsItem {
  final String judul;
  final String deskripsi;
  final String imageUrl;
  final String tag;

  const NewsItem({
    required this.judul,
    required this.deskripsi,
    required this.imageUrl,
    required this.tag,
  });
}

////////////////////////////////////////////////////////////

// ─── ACTIVITY MODEL ──────────────────────────────────────

class ActivityEntry {
  final String type;
  final String time;
  final String description;

  const ActivityEntry({
    required this.type,
    required this.time,
    required this.description,
  });
}
