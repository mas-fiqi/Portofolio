class MockData {
  static const List<Map<String, dynamic>> skills = [
    {'name': 'Flutter', 'progress': 0.95, 'category': 'Framework', 'icon': 'flutter'},
    {'name': 'Python', 'progress': 0.90, 'category': 'Language', 'icon': 'python'},
    {'name': 'Machine Learning', 'progress': 0.85, 'category': 'AI', 'icon': 'brain'},
    {'name': 'ESP32', 'progress': 0.88, 'category': 'IoT', 'icon': 'memory'},
    {'name': 'Dart', 'progress': 0.90, 'category': 'Language', 'icon': 'dart'},
    {'name': 'Firebase', 'progress': 0.85, 'category': 'Backend', 'icon': 'firebase'},
  ];

  static const List<Map<String, dynamic>> portfolio = [
    {
      'title': 'Smart Monitoring NH3',
      'category': 'IoT / AI',
      'technology': ['Flutter', 'ESP32', 'Machine Learning'],
      'description': 'Pemantauan gas NH3 real-time dengan model machine learning prediktif.',
      'image': 'dummy_image',
    },
    {
      'title': 'Aplikasi Hafalan Quran',
      'category': 'Mobile App',
      'technology': ['Flutter', 'Dart', 'Gamification'],
      'description': 'Aplikasi interaktif untuk membantu menghafal Al-Quran dengan sistem gamifikasi.',
      'image': 'dummy_image',
    },
    {
      'title': 'Flutter POS',
      'category': 'Mobile App',
      'technology': ['Flutter', 'Firebase'],
      'description': 'Aplikasi Point of Sale yang dibangun dengan Flutter dan Firebase real-time database.',
      'image': 'dummy_image',
    },
    {
      'title': 'AI Forecasting',
      'category': 'Machine Learning',
      'technology': ['Python', 'LSTM', 'Gradient Boosting'],
      'description': 'Dasbor analisis prediktif menggunakan algoritma LSTM dan Gradient Boosting.',
      'image': 'dummy_image',
    },
    {
      'title': 'IoT Dashboard',
      'category': 'Web',
      'technology': ['Flutter Web', 'ESP32'],
      'description': 'Dasbor web untuk manajemen perangkat IoT yang terpusat.',
      'image': 'dummy_image',
    },
  ];

  static const List<Map<String, dynamic>> research = [
    {
      'title': 'Prediksi NH3 menggunakan Machine Learning',
      'abstract': 'Memprediksi tingkat NH3 secara akurat dengan teknik Machine Learning tingkat lanjut.',
      'technology': ['Random Forest', 'Gradient Boosting', 'Python'],
      'year': '2024',
    },
    {
      'title': 'Sistem Pemantauan IoT',
      'abstract': 'Arsitektur IoT yang tangguh dan dapat diskalakan untuk pemantauan lingkungan.',
      'technology': ['ESP32', 'Sensors', 'Cloud'],
      'year': '2025',
    },
    {
      'title': 'Gamifikasi Hafalan Quran',
      'abstract': 'Mempelajari dampak gamifikasi terhadap retensi hafalan Al-Quran.',
      'technology': ['Mobile Computing', 'UX/UI'],
      'year': '2023',
    },
  ];

  static const List<Map<String, dynamic>> experience = [
    {
      'title': 'Mahasiswa IT',
      'company': 'Universitas',
      'period': '2022',
      'description': 'Mulai mempelajari Teknologi Informasi dan mengeksplorasi dasar-dasar rekayasa perangkat lunak.',
      'icon': 'school',
    },
    {
      'title': 'Pengembang Flutter',
      'company': 'Tech Solutions',
      'period': '2023',
      'description': 'Mengembangkan aplikasi seluler lintas platform menggunakan framework Flutter.',
      'icon': 'smartphone',
    },
    {
      'title': 'Peneliti AI',
      'company': 'Laboratorium AI Universitas',
      'period': '2024',
      'description': 'Meneliti dan mengimplementasikan model Machine Learning seperti LSTM dan Random Forest.',
      'icon': 'brain',
    },
    {
      'title': 'Proyek IoT',
      'company': 'Smart Systems',
      'period': '2025',
      'description': 'Mengintegrasikan perangkat ESP32 untuk sistem pemantauan jarak jauh real-time.',
      'icon': 'memory',
    },
    {
      'title': 'Freelancer',
      'company': 'Bekerja Sendiri',
      'period': '2026',
      'description': 'Mengerjakan berbagai proyek klien premium yang mencakup Flutter, AI, dan IoT.',
      'icon': 'work',
    }
  ];

  static const List<String> certificates = [
    'Flutter Certified Developer',
    'Machine Learning Specialist',
    'IoT Architecture Expert',
    'Google Cloud Professional Machine Learning Engineer',
    'TensorFlow Developer Certificate',
  ];
}
