import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../core/models/portfolio_data.dart';

/// Service untuk semua operasi Firebase (Auth, Firestore, Storage)
class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();
  factory FirebaseService() => _instance;
  FirebaseService._internal();

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // ─── Auth ───────────────────────────────────────────────

  Future<String?> loginAdmin(String email, String password) async {
    try {
      await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .timeout(const Duration(seconds: 12));
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'Email admin tidak terdaftar di Firebase.';
      } else if (e.code == 'wrong-password' || e.code == 'invalid-credential') {
        return 'Password salah. Silakan coba lagi.';
      } else if (e.code == 'invalid-email') {
        return 'Format email tidak valid.';
      } else if (e.code == 'user-disabled') {
        return 'Akun admin ini dinonaktifkan.';
      } else if (e.code == 'too-many-requests') {
        return 'Terlalu banyak percobaan. Silakan coba beberapa saat lagi.';
      }
      return e.message ?? 'Gagal login: ${e.code}';
    } catch (e) {
      if (e.toString().contains('TimeoutException')) {
        return 'Koneksi ke Firebase timeout. Cek internet Anda atau pastikan Firebase Auth aktif.';
      }
      return 'Gagal login: $e';
    }
  }

  Future<void> logoutAdmin() => _auth.signOut();

  bool get isLoggedIn => _auth.currentUser != null;
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // ─── Profile ─────────────────────────────────────────────

  Stream<ProfileData> profileStream() {
    return _db.collection('portfolio').doc('profile').snapshots().map((doc) {
      if (!doc.exists || doc.data() == null) return ProfileData.defaultData;
      return ProfileData.fromMap(doc.data()!);
    });
  }

  Future<void> saveProfile(ProfileData data) async {
    try {
      debugPrint('[FirebaseService] Saving profile to Firestore...');
      await _db
          .collection('portfolio')
          .doc('profile')
          .set(data.toMap())
          .timeout(const Duration(seconds: 15));
      debugPrint('[FirebaseService] Profile saved successfully!');
    } catch (e) {
      debugPrint('[FirebaseService] Error saving profile: $e');
      rethrow;
    }
  }

  // ─── Skills ──────────────────────────────────────────────

  Stream<List<SkillData>> skillsStream() {
    return _db.collection('portfolio').doc('skills')
        .collection('items').orderBy('order').snapshots().map((snap) =>
            snap.docs.map((d) => SkillData.fromMap(d.id, d.data())).toList());
  }

  Future<void> saveSkill(SkillData skill, {int order = 0}) async {
    final data = skill.toMap()..['order'] = order;
    if (skill.id.isEmpty || skill.id.startsWith('temp_')) {
      await _db.collection('portfolio').doc('skills')
          .collection('items').add(data);
    } else {
      await _db.collection('portfolio').doc('skills')
          .collection('items').doc(skill.id).set(data);
    }
  }

  Future<void> deleteSkill(String id) async {
    await _db.collection('portfolio').doc('skills')
        .collection('items').doc(id).delete();
  }

  // ─── Portfolio Projects ───────────────────────────────────

  Stream<List<ProjectData>> projectsStream() {
    return _db.collection('portfolio').doc('projects')
        .collection('items').orderBy('order').snapshots().map((snap) =>
            snap.docs.map((d) => ProjectData.fromMap(d.id, d.data())).toList());
  }

  Future<void> saveProject(ProjectData project, {int order = 0}) async {
    final data = project.toMap()..['order'] = order;
    if (project.id.isEmpty || project.id.startsWith('temp_')) {
      await _db.collection('portfolio').doc('projects')
          .collection('items').add(data);
    } else {
      await _db.collection('portfolio').doc('projects')
          .collection('items').doc(project.id).set(data);
    }
  }

  Future<void> deleteProject(String id) async {
    await _db.collection('portfolio').doc('projects')
        .collection('items').doc(id).delete();
  }

  // ─── Experience ───────────────────────────────────────────

  Stream<List<ExperienceData>> experienceStream() {
    return _db.collection('portfolio').doc('experience')
        .collection('items').orderBy('order').snapshots().map((snap) =>
            snap.docs.map((d) => ExperienceData.fromMap(d.id, d.data())).toList());
  }

  Future<void> saveExperience(ExperienceData exp, {int order = 0}) async {
    final data = exp.toMap()..['order'] = order;
    if (exp.id.isEmpty || exp.id.startsWith('temp_')) {
      await _db.collection('portfolio').doc('experience')
          .collection('items').add(data);
    } else {
      await _db.collection('portfolio').doc('experience')
          .collection('items').doc(exp.id).set(data);
    }
  }

  Future<void> deleteExperience(String id) async {
    await _db.collection('portfolio').doc('experience')
        .collection('items').doc(id).delete();
  }

  // ─── Certificates ─────────────────────────────────────────

  Stream<List<CertificateData>> certificatesStream() {
    return _db.collection('portfolio').doc('certificates')
        .collection('items').orderBy('order').snapshots().map((snap) =>
            snap.docs.map((d) => CertificateData.fromMap(d.id, d.data())).toList());
  }

  Future<void> saveCertificate(CertificateData cert, {int order = 0}) async {
    final data = cert.toMap()..['order'] = order;
    if (cert.id.isEmpty || cert.id.startsWith('temp_')) {
      await _db.collection('portfolio').doc('certificates')
          .collection('items').add(data);
    } else {
      await _db.collection('portfolio').doc('certificates')
          .collection('items').doc(cert.id).set(data);
    }
  }

  Future<void> deleteCertificate(String id) async {
    await _db.collection('portfolio').doc('certificates')
        .collection('items').doc(id).delete();
  }

  // ─── Research ─────────────────────────────────────────────

  Stream<List<ResearchData>> researchStream() {
    return _db.collection('portfolio').doc('research')
        .collection('items').orderBy('order').snapshots().map((snap) =>
            snap.docs.map((d) => ResearchData.fromMap(d.id, d.data())).toList());
  }

  Future<void> saveResearch(ResearchData r, {int order = 0}) async {
    final data = r.toMap()..['order'] = order;
    if (r.id.isEmpty || r.id.startsWith('temp_')) {
      await _db.collection('portfolio').doc('research')
          .collection('items').add(data);
    } else {
      await _db.collection('portfolio').doc('research')
          .collection('items').doc(r.id).set(data);
    }
  }

  Future<void> deleteResearch(String id) async {
    await _db.collection('portfolio').doc('research')
        .collection('items').doc(id).delete();
  }

  // ─── Gallery & Moments (Foto & Video) ───────────────────

  Stream<List<GalleryMediaData>> galleryMediaStream() {
    return _db
        .collection('portfolio')
        .doc('gallery')
        .collection('media_items')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs
            .map((d) => GalleryMediaData.fromMap(d.id, d.data()))
            .toList());
  }

  Future<void> saveGalleryMedia(GalleryMediaData item) async {
    final data = item.toMap();
    if (item.id.isEmpty || item.id.startsWith('temp_')) {
      await _db
          .collection('portfolio')
          .doc('gallery')
          .collection('media_items')
          .add(data);
    } else {
      await _db
          .collection('portfolio')
          .doc('gallery')
          .collection('media_items')
          .doc(item.id)
          .set(data);
    }
  }

  Future<void> deleteGalleryMedia(String id) async {
    await _db
        .collection('portfolio')
        .doc('gallery')
        .collection('media_items')
        .doc(id)
        .delete();
  }

  Stream<List<String>> galleryStream() {
    return _db.collection('portfolio').doc('gallery').snapshots().map((doc) {
      if (!doc.exists) return <String>[];
      return List<String>.from(doc.data()?['images'] ?? []);
    });
  }

  Future<void> addGalleryImage(String url) async {
    await _db.collection('portfolio').doc('gallery').set({
      'images': FieldValue.arrayUnion([url])
    }, SetOptions(merge: true));
  }

  Future<void> removeGalleryImage(String url) async {
    await _db.collection('portfolio').doc('gallery').set({
      'images': FieldValue.arrayRemove([url])
    }, SetOptions(merge: true));
  }

  // ─── Storage (Upload Gambar) ───────────────────────────────

  Future<String> uploadImage(Uint8List bytes, String path) async {
    try {
      debugPrint('[FirebaseService] Uploading image ($path, ${bytes.length} bytes)...');
      final ref = _storage.ref(path);
      final task = await ref
          .putData(bytes, SettableMetadata(contentType: 'image/jpeg'))
          .timeout(const Duration(seconds: 25));
      final downloadUrl = await task.ref.getDownloadURL().timeout(const Duration(seconds: 15));
      debugPrint('[FirebaseService] Image upload success: $downloadUrl');
      return downloadUrl;
    } catch (e) {
      debugPrint('[FirebaseService] Error uploading image to Storage: $e');
      rethrow;
    }
  }

  Future<void> deleteImage(String url) async {
    try {
      await _storage.refFromURL(url).delete();
    } catch (_) {}
  }

  // ─── Dokumen (CV, Surat Lamaran, dll) ─────────────────────

  /// Stream semua dokumen yang tersimpan di Firestore
  Stream<List<DocumentFileData>> documentsStream() {
    return _db
        .collection('portfolio')
        .doc('documents')
        .collection('items')
        .orderBy('uploadedAt', descending: true)
        .snapshots()
        .map((snap) =>
            snap.docs.map((d) => DocumentFileData.fromMap(d.id, d.data())).toList());
  }

  /// Upload file PDF ke Firebase Storage dan simpan metadata ke Firestore
  Future<DocumentFileData> uploadDocument({
    required Uint8List bytes,
    required String fileName,
    required String category, // 'cv', 'cover_letter', 'certificate', 'other'
    String? description,
  }) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final safeName = fileName.replaceAll(RegExp(r'[^\w\.-]'), '_');
    final storagePath = 'documents/$category/${timestamp}_$safeName';
    final ref = _storage.ref(storagePath);
    await ref.putData(bytes, SettableMetadata(contentType: 'application/pdf'));
    final downloadUrl = await ref.getDownloadURL();

    final doc = DocumentFileData(
      id: '',
      fileName: fileName,
      downloadUrl: downloadUrl,
      storagePath: storagePath,
      category: category,
      description: description ?? '',
      uploadedAt: DateTime.now(),
      isPublic: true,
    );

    final docRef = await _db
        .collection('portfolio')
        .doc('documents')
        .collection('items')
        .add(doc.toMap());

    return doc.copyWith(id: docRef.id);
  }

  /// Tambah dokumen via Link (Google Drive, Dropbox, URL PDF eksternal) - 100% Gratis tanpa Storage
  Future<DocumentFileData> addDocumentLink({
    required String title,
    required String downloadUrl,
    required String category,
    String? description,
  }) async {
    // Pastikan link Google Drive diubah otomatis agar langsung bisa dibuka/didownload
    String finalUrl = downloadUrl.trim();

    final doc = DocumentFileData(
      id: '',
      fileName: title.trim(),
      downloadUrl: finalUrl,
      storagePath: 'external_link',
      category: category,
      description: description ?? '',
      uploadedAt: DateTime.now(),
      isPublic: true,
    );

    final docRef = await _db
        .collection('portfolio')
        .doc('documents')
        .collection('items')
        .add(doc.toMap());

    return doc.copyWith(id: docRef.id);
  }

  /// Hapus dokumen dari Storage dan Firestore
  Future<void> deleteDocument(DocumentFileData doc) async {
    if (doc.storagePath != 'external_link') {
      try {
        await _storage.ref(doc.storagePath).delete();
      } catch (_) {}
    }
    await _db
        .collection('portfolio')
        .doc('documents')
        .collection('items')
        .doc(doc.id)
        .delete();
  }

  /// Update visibilitas / deskripsi dokumen
  Future<void> updateDocument(DocumentFileData doc) async {
    await _db
        .collection('portfolio')
        .doc('documents')
        .collection('items')
        .doc(doc.id)
        .update(doc.toMap());
  }
}
