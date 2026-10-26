/// Model data lengkap untuk portfolio
class PortfolioData {
  final ProfileData profile;
  final List<SkillData> skills;
  final List<ProjectData> portfolio;
  final List<ExperienceData> experience;
  final List<CertificateData> certificates;
  final List<String> gallery;
  final List<GalleryMediaData> galleryMedia;
  final List<ResearchData> research;

  const PortfolioData({
    required this.profile,
    required this.skills,
    required this.portfolio,
    required this.experience,
    required this.certificates,
    required this.gallery,
    this.galleryMedia = const [],
    required this.research,
  });

  static PortfolioData get defaultData => PortfolioData(
        profile: ProfileData.defaultData,
        skills: SkillData.defaultList,
        portfolio: ProjectData.defaultList,
        experience: ExperienceData.defaultList,
        certificates: CertificateData.defaultList,
        gallery: [],
        galleryMedia: GalleryMediaData.defaultList,
        research: ResearchData.defaultList,
      );
}

class ProfileData {
  final String name;
  final String title;
  final String bio;
  final String location;
  final String email;
  final String experience;
  final String photoUrl;
  final String phone;
  final String whatsapp;
  final String githubUrl;
  final String linkedinUrl;
  final String instagramUrl;
  final String tiktokUrl;
  final String twitterUrl;
  final bool isAvailable;

  // Dynamic About Page CMS Fields
  final String aboutBadge;
  final String aboutHeadline;
  final String aboutHeadlineGradient;
  final String aboutSubheadline;
  final String aboutCardTitle;
  final String aboutBioParagraph1;
  final String aboutBioParagraph2;
  final String aboutStatusText;
  final bool showAvailabilityBadge;
  final String miniRoleBadge;
  final List<String> profileSkillTags;
  final List<CommitmentItem> commitments;

  const ProfileData({
    required this.name,
    required this.title,
    required this.bio,
    required this.location,
    required this.email,
    required this.experience,
    required this.photoUrl,
    this.phone = '',
    required this.whatsapp,
    required this.githubUrl,
    required this.linkedinUrl,
    required this.instagramUrl,
    this.tiktokUrl = '',
    this.twitterUrl = '',
    required this.isAvailable,
    this.aboutBadge = 'TENTANG SAYA',
    this.aboutHeadline = 'Menciptakan Solusi Digital yang',
    this.aboutHeadlineGradient = 'Elegan dan Skalabel',
    this.aboutSubheadline = 'Saya membangun pengalaman digital yang indah, cerdas, dan berdampak dengan teknologi Flutter, Machine Learning, dan IoT.',
    this.aboutCardTitle = 'Tentang Saya',
    this.aboutBioParagraph1 = 'Saya adalah seorang Software Engineer yang berfokus pada pengembangan aplikasi berbasis Flutter, serta memiliki minat pada bidang Machine Learning dan Internet of Things (IoT). Saya senang membangun solusi digital yang tidak hanya fungsional, tetapi juga memiliki desain yang elegan, scalable, dan memberikan dampak nyata.',
    this.aboutBioParagraph2 = 'Dengan latar belakang pendidikan dan pengalaman di bidang teknologi, saya terus mengembangkan kemampuan untuk menciptakan aplikasi dan sistem yang dapat membantu memecahkan masalah nyata di berbagai bidang.',
    this.aboutStatusText = 'Tersedia untuk Pekerjaan / Kolaborasi',
    this.showAvailabilityBadge = true,
    this.miniRoleBadge = 'Flutter Developer',
    this.profileSkillTags = const ['Flutter', 'Machine Learning', 'IoT System', 'Cloud & Firebase'],
    this.commitments = const [
      CommitmentItem(
        iconName: 'rocket_launch_rounded',
        title: 'Inovatif',
        description: 'Menciptakan solusi yang berpusat pada pengguna dan bernilai nyata.',
      ),
      CommitmentItem(
        iconName: 'code_rounded',
        title: 'Disiplin & Terstruktur',
        description: 'Menulis kode yang bersih, terstruktur, dan mudah dikembangkan.',
      ),
      CommitmentItem(
        iconName: 'groups_rounded',
        title: 'Kolaboratif',
        description: 'Terbuka terhadap ide baru dan senang bekerja dalam tim lintas disiplin.',
      ),
    ],
  });

  factory ProfileData.fromMap(Map<String, dynamic> map) => ProfileData(
        name: map['name'] ?? '',
        title: map['title'] ?? '',
        bio: map['bio'] ?? '',
        location: map['location'] ?? '',
        email: map['email'] ?? '',
        experience: map['experience'] ?? '',
        photoUrl: map['photoUrl'] ?? '',
        phone: map['phone'] ?? '',
        whatsapp: map['whatsapp'] ?? '',
        githubUrl: map['githubUrl'] ?? '',
        linkedinUrl: map['linkedinUrl'] ?? '',
        instagramUrl: map['instagramUrl'] ?? '',
        tiktokUrl: map['tiktokUrl'] ?? '',
        twitterUrl: map['twitterUrl'] ?? '',
        isAvailable: map['isAvailable'] ?? true,
        aboutBadge: map['aboutBadge'] ?? 'TENTANG SAYA',
        aboutHeadline: map['aboutHeadline'] ?? 'Menciptakan Solusi Digital yang',
        aboutHeadlineGradient: map['aboutHeadlineGradient'] ?? 'Elegan dan Skalabel',
        aboutSubheadline: map['aboutSubheadline'] ?? 'Saya membangun pengalaman digital yang indah, cerdas, dan berdampak dengan teknologi Flutter, Machine Learning, dan IoT.',
        aboutCardTitle: map['aboutCardTitle'] ?? 'Tentang Saya',
        aboutBioParagraph1: map['aboutBioParagraph1'] ?? 'Saya adalah seorang Software Engineer yang berfokus pada pengembangan aplikasi berbasis Flutter, serta memiliki minat pada bidang Machine Learning dan Internet of Things (IoT). Saya senang membangun solusi digital yang tidak hanya fungsional, tetapi juga memiliki desain yang elegan, scalable, dan memberikan dampak nyata.',
        aboutBioParagraph2: map['aboutBioParagraph2'] ?? 'Dengan latar belakang pendidikan dan pengalaman di bidang teknologi, saya terus mengembangkan kemampuan untuk menciptakan aplikasi dan sistem yang dapat membantu memecahkan masalah nyata di berbagai bidang.',
        aboutStatusText: map['aboutStatusText'] ?? 'Tersedia untuk Pekerjaan / Kolaborasi',
        showAvailabilityBadge: map['showAvailabilityBadge'] ?? true,
        miniRoleBadge: map['miniRoleBadge'] ?? 'Flutter Developer',
        profileSkillTags: map['profileSkillTags'] != null
            ? List<String>.from(map['profileSkillTags'])
            : const ['Flutter', 'Machine Learning', 'IoT System', 'Cloud & Firebase'],
        commitments: map['commitments'] != null
            ? (map['commitments'] as List)
                .map((x) => CommitmentItem.fromMap(Map<String, dynamic>.from(x)))
                .toList()
            : const [
                CommitmentItem(
                  iconName: 'rocket_launch_rounded',
                  title: 'Inovatif',
                  description: 'Menciptakan solusi yang berpusat pada pengguna dan bernilai nyata.',
                ),
                CommitmentItem(
                  iconName: 'code_rounded',
                  title: 'Disiplin & Terstruktur',
                  description: 'Menulis kode yang bersih, terstruktur, dan mudah dikembangkan.',
                ),
                CommitmentItem(
                  iconName: 'groups_rounded',
                  title: 'Kolaboratif',
                  description: 'Terbuka terhadap ide baru dan senang bekerja dalam tim lintas disiplin.',
                ),
              ],
      );

  Map<String, dynamic> toMap() => {
        'name': name,
        'title': title,
        'bio': bio,
        'location': location,
        'email': email,
        'experience': experience,
        'photoUrl': photoUrl,
        'phone': phone,
        'whatsapp': whatsapp,
        'githubUrl': githubUrl,
        'linkedinUrl': linkedinUrl,
        'instagramUrl': instagramUrl,
        'tiktokUrl': tiktokUrl,
        'twitterUrl': twitterUrl,
        'isAvailable': isAvailable,
        'aboutBadge': aboutBadge,
        'aboutHeadline': aboutHeadline,
        'aboutHeadlineGradient': aboutHeadlineGradient,
        'aboutSubheadline': aboutSubheadline,
        'aboutCardTitle': aboutCardTitle,
        'aboutBioParagraph1': aboutBioParagraph1,
        'aboutBioParagraph2': aboutBioParagraph2,
        'aboutStatusText': aboutStatusText,
        'showAvailabilityBadge': showAvailabilityBadge,
        'miniRoleBadge': miniRoleBadge,
        'profileSkillTags': profileSkillTags,
        'commitments': commitments.map((x) => x.toMap()).toList(),
      };

  ProfileData copyWith({
    String? name, String? title, String? bio, String? location,
    String? email, String? experience, String? photoUrl,
    String? phone, String? whatsapp,
    String? githubUrl, String? linkedinUrl, String? instagramUrl,
    String? tiktokUrl, String? twitterUrl,
    bool? isAvailable,
    String? aboutBadge,
    String? aboutHeadline,
    String? aboutHeadlineGradient,
    String? aboutSubheadline,
    String? aboutCardTitle,
    String? aboutBioParagraph1,
    String? aboutBioParagraph2,
    String? aboutStatusText,
    bool? showAvailabilityBadge,
    String? miniRoleBadge,
    List<String>? profileSkillTags,
    List<CommitmentItem>? commitments,
  }) => ProfileData(
    name: name ?? this.name, title: title ?? this.title,
    bio: bio ?? this.bio, location: location ?? this.location,
    email: email ?? this.email, experience: experience ?? this.experience,
    photoUrl: photoUrl ?? this.photoUrl,
    phone: phone ?? this.phone,
    whatsapp: whatsapp ?? this.whatsapp,
    githubUrl: githubUrl ?? this.githubUrl,
    linkedinUrl: linkedinUrl ?? this.linkedinUrl,
    instagramUrl: instagramUrl ?? this.instagramUrl,
    tiktokUrl: tiktokUrl ?? this.tiktokUrl,
    twitterUrl: twitterUrl ?? this.twitterUrl,
    isAvailable: isAvailable ?? this.isAvailable,
    aboutBadge: aboutBadge ?? this.aboutBadge,
    aboutHeadline: aboutHeadline ?? this.aboutHeadline,
    aboutHeadlineGradient: aboutHeadlineGradient ?? this.aboutHeadlineGradient,
    aboutSubheadline: aboutSubheadline ?? this.aboutSubheadline,
    aboutCardTitle: aboutCardTitle ?? this.aboutCardTitle,
    aboutBioParagraph1: aboutBioParagraph1 ?? this.aboutBioParagraph1,
    aboutBioParagraph2: aboutBioParagraph2 ?? this.aboutBioParagraph2,
    aboutStatusText: aboutStatusText ?? this.aboutStatusText,
    showAvailabilityBadge: showAvailabilityBadge ?? this.showAvailabilityBadge,
    miniRoleBadge: miniRoleBadge ?? this.miniRoleBadge,
    profileSkillTags: profileSkillTags ?? this.profileSkillTags,
    commitments: commitments ?? this.commitments,
  );

  static ProfileData get defaultData => const ProfileData(
    name: 'Moh. Rafiqi Wahyudi',
    title: 'Software Engineer  •  AI & IoT Researcher  •  Mobile Specialist',
    bio: 'Saya membangun pengalaman digital yang indah, cerdas, dan berdampak dengan teknologi Flutter, Machine Learning, dan IoT.',
    location: 'Pamekasan, Madura, Indonesia',
    email: 'cakfiqi2@gmail.com',
    experience: '3+',
    photoUrl: 'assets/images/profile_suit_cutout.png',
    phone: '+6287761571291',
    whatsapp: '6287761571291',
    githubUrl: 'https://github.com/mas-fiqi',
    linkedinUrl: 'https://linkedin.com/in/mas-fiqi',
    instagramUrl: 'https://instagram.com/mas_fiqi',
    tiktokUrl: '',
    twitterUrl: '',
    isAvailable: true,
  );
}

class CommitmentItem {
  final String iconName;
  final String title;
  final String description;

  const CommitmentItem({
    required this.iconName,
    required this.title,
    required this.description,
  });

  factory CommitmentItem.fromMap(Map<String, dynamic> map) => CommitmentItem(
        iconName: map['iconName'] ?? 'rocket_launch_rounded',
        title: map['title'] ?? '',
        description: map['description'] ?? '',
      );

  Map<String, dynamic> toMap() => {
        'iconName': iconName,
        'title': title,
        'description': description,
      };
}

class SkillData {
  final String id;
  final String name;
  final double progress;
  final String category;
  final String icon;

  const SkillData({
    required this.id,
    required this.name,
    required this.progress,
    required this.category,
    required this.icon,
  });

  factory SkillData.fromMap(String id, Map<String, dynamic> map) => SkillData(
        id: id,
        name: map['name'] ?? '',
        progress: (map['progress'] ?? 0.5).toDouble(),
        category: map['category'] ?? '',
        icon: map['icon'] ?? '',
      );

  Map<String, dynamic> toMap() => {
        'name': name, 'progress': progress,
        'category': category, 'icon': icon,
      };

  static List<SkillData> get defaultList => [
    const SkillData(id: '1', name: 'Flutter', progress: 0.95, category: 'Framework', icon: 'flutter'),
    const SkillData(id: '2', name: 'Python', progress: 0.90, category: 'Language', icon: 'python'),
    const SkillData(id: '3', name: 'Machine Learning', progress: 0.85, category: 'AI', icon: 'brain'),
    const SkillData(id: '4', name: 'ESP32', progress: 0.88, category: 'IoT', icon: 'memory'),
    const SkillData(id: '5', name: 'Dart', progress: 0.90, category: 'Language', icon: 'dart'),
    const SkillData(id: '6', name: 'Firebase', progress: 0.85, category: 'Backend', icon: 'firebase'),
  ];
}

class ProjectData {
  final String id;
  final String title;
  final String category;
  final List<String> technology;
  final String description;
  final String imageUrl;
  final String projectUrl;

  const ProjectData({
    required this.id,
    required this.title,
    required this.category,
    required this.technology,
    required this.description,
    required this.imageUrl,
    required this.projectUrl,
  });

  factory ProjectData.fromMap(String id, Map<String, dynamic> map) => ProjectData(
        id: id,
        title: map['title'] ?? '',
        category: map['category'] ?? '',
        technology: List<String>.from(map['technology'] ?? []),
        description: map['description'] ?? '',
        imageUrl: map['imageUrl'] ?? '',
        projectUrl: map['projectUrl'] ?? '',
      );

  Map<String, dynamic> toMap() => {
        'title': title, 'category': category,
        'technology': technology, 'description': description,
        'imageUrl': imageUrl, 'projectUrl': projectUrl,
      };

  static List<ProjectData> get defaultList => [
    const ProjectData(id: '1', title: 'Smart Monitoring NH3', category: 'IoT / AI', technology: ['Flutter', 'ESP32', 'Machine Learning'], description: 'Pemantauan gas NH3 real-time dengan model machine learning prediktif.', imageUrl: '', projectUrl: ''),
    const ProjectData(id: '2', title: 'Aplikasi Hafalan Quran', category: 'Mobile App', technology: ['Flutter', 'Dart', 'Gamification'], description: 'Aplikasi interaktif untuk membantu menghafal Al-Quran dengan sistem gamifikasi.', imageUrl: '', projectUrl: ''),
    const ProjectData(id: '3', title: 'Flutter POS', category: 'Mobile App', technology: ['Flutter', 'Firebase'], description: 'Aplikasi Point of Sale yang dibangun dengan Flutter dan Firebase real-time database.', imageUrl: '', projectUrl: ''),
  ];
}

class ExperienceData {
  final String id;
  final String title;
  final String company;
  final String period;
  final String description;
  final String icon;
  final String imageUrl;

  const ExperienceData({
    required this.id,
    required this.title,
    required this.company,
    required this.period,
    required this.description,
    required this.icon,
    this.imageUrl = '',
  });

  factory ExperienceData.fromMap(String id, Map<String, dynamic> map) => ExperienceData(
        id: id,
        title: map['title'] ?? '',
        company: map['company'] ?? '',
        period: map['period'] ?? '',
        description: map['description'] ?? '',
        icon: map['icon'] ?? 'work',
        imageUrl: map['imageUrl'] ?? '',
      );

  Map<String, dynamic> toMap() => {
        'title': title, 'company': company,
        'period': period, 'description': description, 'icon': icon,
        'imageUrl': imageUrl,
      };

  static List<ExperienceData> get defaultList => [
    const ExperienceData(id: '1', title: 'Mahasiswa IT', company: 'Universitas', period: '2022', description: 'Mulai mempelajari Teknologi Informasi dan mengeksplorasi dasar-dasar rekayasa perangkat lunak.', icon: 'school', imageUrl: ''),
    const ExperienceData(id: '2', title: 'Pengembang Flutter', company: 'Tech Solutions', period: '2023', description: 'Mengembangkan aplikasi seluler lintas platform menggunakan framework Flutter.', icon: 'smartphone', imageUrl: ''),
    const ExperienceData(id: '3', title: 'Peneliti AI', company: 'Laboratorium AI Universitas', period: '2024', description: 'Meneliti dan mengimplementasikan model Machine Learning seperti LSTM dan Random Forest.', icon: 'brain', imageUrl: ''),
    const ExperienceData(id: '4', title: 'Freelancer', company: 'Bekerja Sendiri', period: '2026', description: 'Mengerjakan berbagai proyek klien premium yang mencakup Flutter, AI, dan IoT.', icon: 'work', imageUrl: ''),
  ];
}

class CertificateData {
  final String id;
  final String name;
  final String issuer;
  final String year;
  final String imageUrl;

  const CertificateData({
    required this.id,
    required this.name,
    required this.issuer,
    required this.year,
    required this.imageUrl,
  });

  factory CertificateData.fromMap(String id, Map<String, dynamic> map) => CertificateData(
        id: id,
        name: map['name'] ?? '',
        issuer: map['issuer'] ?? '',
        year: map['year'] ?? '',
        imageUrl: map['imageUrl'] ?? '',
      );

  Map<String, dynamic> toMap() => {
        'name': name, 'issuer': issuer,
        'year': year, 'imageUrl': imageUrl,
      };

  static List<CertificateData> get defaultList => [
    const CertificateData(id: '1', name: 'Flutter Certified Developer', issuer: 'Google', year: '2024', imageUrl: ''),
    const CertificateData(id: '2', name: 'Machine Learning Specialist', issuer: 'Coursera', year: '2024', imageUrl: ''),
    const CertificateData(id: '3', name: 'TensorFlow Developer Certificate', issuer: 'Google', year: '2025', imageUrl: ''),
  ];
}

class GalleryMediaData {
  final String id;
  final String title;
  final String description;
  final String mediaUrl;
  final String mediaType; // 'video' or 'photo'
  final String category;  // 'Liburan', 'Kuliah', 'Trip', 'Santai', dll
  final String thumbnailUrl;
  final DateTime createdAt;

  const GalleryMediaData({
    required this.id,
    required this.title,
    this.description = '',
    required this.mediaUrl,
    required this.mediaType,
    this.category = 'Liburan',
    this.thumbnailUrl = '',
    required this.createdAt,
  });

  bool get isVideo => mediaType.toLowerCase() == 'video';

  String get platform {
    final lower = mediaUrl.toLowerCase();
    if (lower.contains('threads.net')) return 'Threads';
    if (lower.contains('youtube.com') || lower.contains('youtu.be')) return 'YouTube';
    if (lower.contains('instagram.com')) return 'Instagram';
    if (lower.contains('tiktok.com')) return 'TikTok';
    if (lower.contains('drive.google.com')) return 'Google Drive';
    if (lower.endsWith('.mp4') || lower.endsWith('.webm') || lower.endsWith('.mov')) return 'Direct Video';
    return isVideo ? 'Video Link' : 'Foto';
  }

  factory GalleryMediaData.fromMap(String id, Map<String, dynamic> map) => GalleryMediaData(
        id: id,
        title: map['title'] ?? '',
        description: map['description'] ?? '',
        mediaUrl: map['mediaUrl'] ?? '',
        mediaType: map['mediaType'] ?? 'photo',
        category: map['category'] ?? 'Liburan',
        thumbnailUrl: map['thumbnailUrl'] ?? '',
        createdAt: map['createdAt'] != null
            ? DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int)
            : DateTime.now(),
      );

  Map<String, dynamic> toMap() => {
        'title': title,
        'description': description,
        'mediaUrl': mediaUrl,
        'mediaType': mediaType,
        'category': category,
        'thumbnailUrl': thumbnailUrl,
        'createdAt': createdAt.millisecondsSinceEpoch,
      };

  static List<GalleryMediaData> get defaultList => [
    GalleryMediaData(
      id: '1',
      title: 'Momen Liburan & Healing Bersama',
      description: 'Menikmati keindahan alam dan suasana santai melepas penat setelah rutinitas perkuliahan dan coding.',
      mediaUrl: 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1200&q=80',
      mediaType: 'photo',
      category: 'Liburan',
      thumbnailUrl: '',
      createdAt: DateTime(2025, 7, 10),
    ),
    GalleryMediaData(
      id: '2',
      title: 'Dokumentasi Video Trip & Jalan Santai',
      description: 'Rekaman video seru saat perjalanan healing dan hunting spot menarik.',
      mediaUrl: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
      mediaType: 'video',
      category: 'Trip',
      thumbnailUrl: 'https://images.unsplash.com/photo-1469854523086-cc02fe5d8800?auto=format&fit=crop&w=1200&q=80',
      createdAt: DateTime(2025, 8, 15),
    ),
    GalleryMediaData(
      id: '3',
      title: 'Kebersamaan Kampus & Teman Kuliah',
      description: 'Momen berharga bersama teman-teman kampus saat diskusi dan nongkrong asik.',
      mediaUrl: 'https://images.unsplash.com/photo-1523240795612-9a054b0db644?auto=format&fit=crop&w=1200&q=80',
      mediaType: 'photo',
      category: 'Kuliah',
      thumbnailUrl: '',
      createdAt: DateTime(2025, 9, 20),
    ),
  ];
}

class ResearchData {
  final String id;
  final String title;
  final String abstract;
  final List<String> technology;
  final String year;
  final String url;

  const ResearchData({
    required this.id,
    required this.title,
    required this.abstract,
    required this.technology,
    required this.year,
    required this.url,
  });

  factory ResearchData.fromMap(String id, Map<String, dynamic> map) => ResearchData(
        id: id,
        title: map['title'] ?? '',
        abstract: map['abstract'] ?? '',
        technology: List<String>.from(map['technology'] ?? []),
        year: map['year'] ?? '',
        url: map['url'] ?? '',
      );

  Map<String, dynamic> toMap() => {
        'title': title, 'abstract': abstract,
        'technology': technology, 'year': year, 'url': url,
      };

  static List<ResearchData> get defaultList => [
    const ResearchData(id: '1', title: 'Prediksi NH3 menggunakan Machine Learning', abstract: 'Memprediksi tingkat NH3 secara akurat dengan teknik Machine Learning tingkat lanjut.', technology: ['Random Forest', 'Gradient Boosting', 'Python'], year: '2024', url: ''),
    const ResearchData(id: '2', title: 'Sistem Pemantauan IoT', abstract: 'Arsitektur IoT yang tangguh dan dapat diskalakan untuk pemantauan lingkungan.', technology: ['ESP32', 'Sensors', 'Cloud'], year: '2025', url: ''),
  ];
}

// ─── Document File (CV, Surat Lamaran, dll) ───────────────────────────────────

class DocumentFileData {
  final String id;
  final String fileName;
  final String downloadUrl;
  final String storagePath;
  final String category; // 'cv', 'cover_letter', 'certificate', 'other'
  final String description;
  final DateTime uploadedAt;
  final bool isPublic;

  const DocumentFileData({
    required this.id,
    required this.fileName,
    required this.downloadUrl,
    required this.storagePath,
    required this.category,
    required this.description,
    required this.uploadedAt,
    required this.isPublic,
  });

  factory DocumentFileData.fromMap(String id, Map<String, dynamic> map) =>
      DocumentFileData(
        id: id,
        fileName: map['fileName'] ?? '',
        downloadUrl: map['downloadUrl'] ?? '',
        storagePath: map['storagePath'] ?? '',
        category: map['category'] ?? 'other',
        description: map['description'] ?? '',
        uploadedAt: map['uploadedAt'] != null
            ? DateTime.fromMillisecondsSinceEpoch(map['uploadedAt'] as int)
            : DateTime.now(),
        isPublic: map['isPublic'] ?? true,
      );

  Map<String, dynamic> toMap() => {
        'fileName': fileName,
        'downloadUrl': downloadUrl,
        'storagePath': storagePath,
        'category': category,
        'description': description,
        'uploadedAt': uploadedAt.millisecondsSinceEpoch,
        'isPublic': isPublic,
      };

  DocumentFileData copyWith({
    String? id,
    String? fileName,
    String? downloadUrl,
    String? storagePath,
    String? category,
    String? description,
    DateTime? uploadedAt,
    bool? isPublic,
  }) =>
      DocumentFileData(
        id: id ?? this.id,
        fileName: fileName ?? this.fileName,
        downloadUrl: downloadUrl ?? this.downloadUrl,
        storagePath: storagePath ?? this.storagePath,
        category: category ?? this.category,
        description: description ?? this.description,
        uploadedAt: uploadedAt ?? this.uploadedAt,
        isPublic: isPublic ?? this.isPublic,
      );

  /// Label tampilan kategori
  String get categoryLabel {
    switch (category) {
      case 'cv': return 'CV / Resume';
      case 'cover_letter': return 'Surat Lamaran';
      case 'certificate': return 'Sertifikat';
      default: return 'Dokumen Lain';
    }
  }
}

