import 'package:flutter/material.dart';
import '../services/firebase_service.dart';
import '../core/models/portfolio_data.dart';

/// Provider yang meng-aggregate semua stream Firebase menjadi satu state terpusat.
/// Digunakan oleh semua section untuk mendapatkan data real-time.
class PortfolioProvider extends ChangeNotifier {
  final FirebaseService _svc = FirebaseService();

  ProfileData _profile = ProfileData.defaultData;
  List<SkillData> _skills = SkillData.defaultList;
  List<ProjectData> _projects = ProjectData.defaultList;
  List<ExperienceData> _experience = ExperienceData.defaultList;
  List<CertificateData> _certificates = CertificateData.defaultList;
  List<ResearchData> _research = ResearchData.defaultList;
  List<String> _gallery = [];
  List<GalleryMediaData> _galleryMedia = GalleryMediaData.defaultList;
  List<DocumentFileData> _documents = [];

  ProfileData get profile => _profile;
  List<SkillData> get skills => _skills;
  List<ProjectData> get projects => _projects;
  List<ExperienceData> get experience => _experience;
  List<CertificateData> get certificates => _certificates;
  List<ResearchData> get research => _research;
  List<String> get gallery => _gallery;
  List<GalleryMediaData> get galleryMedia => _galleryMedia;
  List<DocumentFileData> get documents => _documents;

  /// Dokumen publik yang dapat diunduh oleh pengunjung
  List<DocumentFileData> get publicDocuments =>
      _documents.where((d) => d.isPublic).toList();

  /// CV publik terbaru (kategori 'cv')
  DocumentFileData? get latestCv {
    try {
      return _documents.firstWhere((d) => d.isPublic && d.category == 'cv');
    } catch (_) {
      return null;
    }
  }

  PortfolioProvider() {
    _listenAll();
  }

  void _listenAll() {
    _svc.profileStream().listen(
      (data) {
        debugPrint('[PortfolioProvider] Profile updated: ${data.name}');
        _profile = data;
        notifyListeners();
      },
      onError: (err, stack) {
        debugPrint('[PortfolioProvider] Error loading profile from Firestore: $err');
        // Tetap gunakan fallback _profile defaultData
      },
    );

    _svc.skillsStream().listen(
      (data) {
        debugPrint('[PortfolioProvider] Skills received: ${data.length} items');
        if (data.isNotEmpty) {
          _skills = data;
          notifyListeners();
        }
      },
      onError: (err, stack) {
        debugPrint('[PortfolioProvider] Error loading skills from Firestore: $err');
      },
    );

    _svc.projectsStream().listen(
      (data) {
        debugPrint('[PortfolioProvider] Projects received: ${data.length} items');
        if (data.isNotEmpty) {
          _projects = data;
          notifyListeners();
        }
      },
      onError: (err, stack) {
        debugPrint('[PortfolioProvider] Error loading projects from Firestore: $err');
      },
    );

    _svc.experienceStream().listen(
      (data) {
        debugPrint('[PortfolioProvider] Experience received: ${data.length} items');
        if (data.isNotEmpty) {
          _experience = data;
          notifyListeners();
        }
      },
      onError: (err, stack) {
        debugPrint('[PortfolioProvider] Error loading experience from Firestore: $err');
      },
    );

    _svc.certificatesStream().listen(
      (data) {
        debugPrint('[PortfolioProvider] Certificates received: ${data.length} items');
        if (data.isNotEmpty) {
          _certificates = data;
          notifyListeners();
        }
      },
      onError: (err, stack) {
        debugPrint('[PortfolioProvider] Error loading certificates from Firestore: $err');
      },
    );

    _svc.researchStream().listen(
      (data) {
        debugPrint('[PortfolioProvider] Research received: ${data.length} items');
        if (data.isNotEmpty) {
          _research = data;
          notifyListeners();
        }
      },
      onError: (err, stack) {
        debugPrint('[PortfolioProvider] Error loading research from Firestore: $err');
      },
    );

    _svc.galleryStream().listen(
      (data) {
        debugPrint('[PortfolioProvider] Gallery received: ${data.length} images');
        _gallery = data;
        notifyListeners();
      },
      onError: (err, stack) {
        debugPrint('[PortfolioProvider] Error loading gallery from Firestore: $err');
      },
    );

    _svc.galleryMediaStream().listen(
      (data) {
        debugPrint('[PortfolioProvider] GalleryMedia received: ${data.length} items');
        if (data.isNotEmpty) {
          _galleryMedia = data;
          notifyListeners();
        }
      },
      onError: (err, stack) {
        debugPrint('[PortfolioProvider] Error loading galleryMedia from Firestore: $err');
      },
    );

    _svc.documentsStream().listen(
      (data) {
        debugPrint('[PortfolioProvider] Documents received: ${data.length} items');
        _documents = data;
        notifyListeners();
      },
      onError: (err, stack) {
        debugPrint('[PortfolioProvider] Error loading documents from Firestore: $err');
      },
    );
  }
}

