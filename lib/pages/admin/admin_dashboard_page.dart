import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../../services/firebase_service.dart';
import '../../core/models/portfolio_data.dart';
import 'admin_login_page.dart';


import 'cover_letter_generator_page.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  int _selectedTab = 0;
  final _tabs = ['Profil', 'Keahlian', 'Portofolio', 'Pengalaman', 'Sertifikat', 'Riset', 'Galeri', 'Dokumen', 'Surat Lamaran'];
  final _tabIcons = [
    Icons.person_outline, Icons.code, Icons.folder_outlined,
    Icons.work_outline, Icons.workspace_premium_outlined,
    Icons.menu_book_outlined, Icons.photo_library_outlined,
    Icons.description_outlined, Icons.auto_stories_outlined,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1026),
      body: Row(
        children: [
          // Sidebar
          _buildSidebar(),
          // Content
          Expanded(child: _buildContent()),
        ],
      ),
    );
  }

  Widget _buildSidebar() {
    return Container(
      width: 220,
      color: const Color(0xFF0F081C),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFF58DBFF)),
                  ),
                  child: const Icon(Icons.admin_panel_settings,
                      color: Color(0xFF58DBFF), size: 20),
                ),
                const SizedBox(width: 10),
                const Text('Admin Panel',
                    style: TextStyle(color: Colors.white,
                        fontWeight: FontWeight.bold, fontSize: 14)),
              ],
            ),
          ),
          const Divider(color: Colors.white12),
          const SizedBox(height: 8),
          // Menu items
          ...List.generate(_tabs.length, (i) => _buildSidebarItem(i)),
          const Spacer(),
          const Divider(color: Colors.white12),
          // Logout
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.redAccent, size: 20),
            title: const Text('Keluar', style: TextStyle(color: Colors.redAccent, fontSize: 14)),
            onTap: () async {
              await FirebaseService().logoutAdmin();
              if (!mounted) return;
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (_) => const AdminLoginPage()));
            },
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildSidebarItem(int index) {
    final isSelected = _selectedTab == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedTab = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF4C2B9A).withValues(alpha: 0.3)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: isSelected
              ? Border.all(color: const Color(0xFF58DBFF).withValues(alpha: 0.3))
              : null,
        ),
        child: Row(
          children: [
            Icon(_tabIcons[index],
                color: isSelected ? const Color(0xFF58DBFF) : Colors.white54,
                size: 18),
            const SizedBox(width: 10),
            Text(_tabs[index],
                style: TextStyle(
                    color: isSelected ? Colors.white : Colors.white60,
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal)),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      children: [
        // Top bar
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.white12)),
          ),
          child: Row(
            children: [
              Text(_tabs[_selectedTab],
                  style: const TextStyle(color: Colors.white,
                      fontSize: 20, fontWeight: FontWeight.bold)),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.circle, color: Colors.greenAccent, size: 8),
                    SizedBox(width: 6),
                    Text('Live', style: TextStyle(color: Colors.greenAccent, fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
        ),
        // Tab content
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: _buildTabContent(),
          ),
        ),
      ],
    );
  }

  Widget _buildTabContent() {
    switch (_selectedTab) {
      case 0: return const _ProfileEditor();
      case 1: return const _SkillsEditor();
      case 2: return const _ProjectsEditor();
      case 3: return const _ExperienceEditor();
      case 4: return const _CertificatesEditor();
      case 5: return const _ResearchEditor();
      case 6: return const _GalleryEditor();
      case 7: return const _DocumentsEditor();
      case 8: return const CoverLetterGeneratorWidget();
      default: return const SizedBox.shrink();
    }
  }
}

// ─── Profile Editor ───────────────────────────────────────────────────────────

class _ProfileEditor extends StatefulWidget {
  const _ProfileEditor();
  @override
  State<_ProfileEditor> createState() => _ProfileEditorState();
}

class _ProfileEditorState extends State<_ProfileEditor> {
  final _svc = FirebaseService();
  ProfileData? _data;
  bool _saving = false;

  // Controllers
  late final _nameCtrl = TextEditingController();
  late final _titleCtrl = TextEditingController();
  late final _bioCtrl = TextEditingController();
  late final _locationCtrl = TextEditingController();
  late final _emailCtrl = TextEditingController();
  late final _expCtrl = TextEditingController();
  late final _photoUrlCtrl = TextEditingController();
  late final _phoneCtrl = TextEditingController();
  late final _githubCtrl = TextEditingController();
  late final _linkedinCtrl = TextEditingController();
  late final _igCtrl = TextEditingController();
  late final _waCtrl = TextEditingController();
  late final _tiktokCtrl = TextEditingController();
  late final _twitterCtrl = TextEditingController();

  @override
  void dispose() {
    for (final c in [_nameCtrl, _titleCtrl, _bioCtrl, _locationCtrl,
        _emailCtrl, _expCtrl, _photoUrlCtrl, _phoneCtrl, _githubCtrl, _linkedinCtrl, _igCtrl, _waCtrl, _tiktokCtrl, _twitterCtrl]) {
      c.dispose();
    }
    super.dispose();
  }

  void _populate(ProfileData d) {
    _nameCtrl.text = d.name;
    _titleCtrl.text = d.title;
    _bioCtrl.text = d.bio;
    _locationCtrl.text = d.location;
    _emailCtrl.text = d.email;
    _expCtrl.text = d.experience;
    _photoUrlCtrl.text = d.photoUrl;
    _phoneCtrl.text = d.phone;
    _githubCtrl.text = d.githubUrl;
    _linkedinCtrl.text = d.linkedinUrl;
    _igCtrl.text = d.instagramUrl;
    _waCtrl.text = d.whatsapp;
    _tiktokCtrl.text = d.tiktokUrl;
    _twitterCtrl.text = d.twitterUrl;
  }

  Future<void> _uploadPhoto() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image, withData: true);
    if (result == null || result.files.isEmpty) return;
    final file = result.files.first;
    final bytes = file.bytes;
    if (bytes == null) {
      _showSnack('File foto tidak terbaca. Silakan coba lagi.', isError: true);
      return;
    }
    // Validasi ukuran: max 5 MB
    if (bytes.length > 5 * 1024 * 1024) {
      _showSnack('Ukuran file foto terlalu besar (${(bytes.length / (1024 * 1024)).toStringAsFixed(1)} MB). Maksimal 5 MB.', isError: true);
      return;
    }

    setState(() => _saving = true);
    try {
      final ext = file.extension?.toLowerCase() ?? 'jpg';
      final safeExt = (ext == 'png' || ext == 'webp' || ext == 'jpeg') ? ext : 'jpg';
      final path = 'profile/photo_${DateTime.now().millisecondsSinceEpoch}.$safeExt';
      
      final url = await _svc.uploadImage(bytes, path);
      final baseData = _data ?? ProfileData.defaultData;
      final updated = baseData.copyWith(photoUrl: url);
      await _svc.saveProfile(updated);
      setState(() {
        _data = updated;
        _photoUrlCtrl.text = url;
      });
      if (mounted) _showSnack('Foto profil berhasil diperbarui!');
    } catch (e) {
      if (mounted) {
        final errStr = e.toString();
        if (errStr.contains('retry-limit-exceeded') || errStr.contains('403') || errStr.contains('permission')) {
          _showSnack(
            'Gagal upload ke Firebase Storage ($e).\nTip: Anda juga dapat menempelkan URL Foto langsung pada kolom URL di bawah.',
            isError: true,
          );
        } else {
          _showSnack('Gagal upload foto: $e', isError: true);
        }
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      final baseData = _data ?? ProfileData.defaultData;
      final updated = baseData.copyWith(
        name: _nameCtrl.text.trim(),
        title: _titleCtrl.text.trim(),
        bio: _bioCtrl.text.trim(),
        location: _locationCtrl.text.trim(),
        email: _emailCtrl.text.trim(),
        experience: _expCtrl.text.trim(),
        photoUrl: _photoUrlCtrl.text.trim().isNotEmpty 
            ? _photoUrlCtrl.text.trim() 
            : baseData.photoUrl,
        phone: _phoneCtrl.text.trim(),
        githubUrl: _githubCtrl.text.trim(),
        linkedinUrl: _linkedinCtrl.text.trim(),
        instagramUrl: _igCtrl.text.trim(),
        whatsapp: _waCtrl.text.trim(),
        tiktokUrl: _tiktokCtrl.text.trim(),
        twitterUrl: _twitterCtrl.text.trim(),
      );
      await _svc.saveProfile(updated);
      setState(() {
        _data = updated;
      });
      if (mounted) _showSnack('Profil berhasil disimpan ke database!');
    } catch (e) {
      if (mounted) {
        _showSnack('Gagal menyimpan profil: $e\n(Pastikan Firestore Rules mengizinkan write untuk akun yang login)', isError: true);
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  void _showSnack(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: isError ? Colors.red : Colors.green,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ProfileData>(
      stream: _svc.profileStream(),
      builder: (ctx, snap) {
        if (snap.hasData && _data == null) {
          _data = snap.data;
          WidgetsBinding.instance.addPostFrameCallback((_) => _populate(_data!));
        }
        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Photo upload & URL input area
          _buildSection('Foto Profil & Avatar', [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Preview avatar
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFF6366F1), width: 2.5),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF6366F1).withValues(alpha: 0.2),
                        blurRadius: 16,
                      ),
                    ],
                    image: (_photoUrlCtrl.text.isNotEmpty || (_data?.photoUrl ?? '').isNotEmpty)
                        ? DecorationImage(
                            image: NetworkImage(
                              _photoUrlCtrl.text.isNotEmpty ? _photoUrlCtrl.text : _data!.photoUrl,
                            ),
                            fit: BoxFit.cover,
                            onError: (_, __) {},
                          )
                        : null,
                  ),
                  child: (_photoUrlCtrl.text.isEmpty && (_data?.photoUrl ?? '').isEmpty)
                      ? const Icon(Icons.person_rounded, size: 48, color: Colors.white24)
                      : null,
                ),
                const SizedBox(width: 24),
                // Actions & info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: 12,
                        runSpacing: 8,
                        children: [
                          ElevatedButton.icon(
                            onPressed: _saving ? null : _uploadPhoto,
                            icon: const Icon(Icons.upload_file_rounded, size: 18),
                            label: const Text('Pilih File dari Komputer'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF4F46E5),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                          if (_photoUrlCtrl.text.isNotEmpty)
                            OutlinedButton.icon(
                              onPressed: () {
                                setState(() {
                                  _photoUrlCtrl.clear();
                                });
                              },
                              icon: const Icon(Icons.clear_rounded, size: 16),
                              label: const Text('Reset URL'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.white60,
                                side: const BorderSide(color: Colors.white24),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _field(
                        'Atau Tempel URL Foto Langsung (Google Drive / Direct Link / Hosting)',
                        _photoUrlCtrl,
                        Icons.link_rounded,
                        onChanged: (_) => setState(() {}),
                      ),
                      const Text(
                        'Format didukung: JPG, PNG, WEBP (Maksimal 5MB). Jika Firebase Storage belum aktif, Anda dapat menggunakan URL langsung.',
                        style: TextStyle(color: Colors.white38, fontSize: 11),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ]),
          const SizedBox(height: 20),
          _buildSection('Informasi Dasar & Kontak', [
            _field('Nama Lengkap', _nameCtrl, Icons.person_outline),
            _field('Judul / Title', _titleCtrl, Icons.title),
            _field('Bio / Deskripsi Singkat', _bioCtrl, Icons.description_outlined, maxLines: 3),
            _field('Lokasi', _locationCtrl, Icons.location_on_outlined),
            _field('Email', _emailCtrl, Icons.email_outlined),
            _field('Nomor Telepon Seluler', _phoneCtrl, Icons.phone_android_rounded),
            _field('WhatsApp (cth: 6287761571291)', _waCtrl, Icons.phone_forwarded),
            _field('Pengalaman (cth: 3+)', _expCtrl, Icons.trending_up),
          ]),
          const SizedBox(height: 20),
          _buildSection('Sosial Media & Tautan', [
            _field('WhatsApp (Nomor atau Link Langsung)', _waCtrl, Icons.chat),
            _field('Instagram URL', _igCtrl, Icons.camera_alt_outlined),
            _field('TikTok URL', _tiktokCtrl, Icons.music_note_rounded),
            _field('Twitter / X URL', _twitterCtrl, Icons.tag_rounded),
            _field('GitHub URL', _githubCtrl, Icons.code),
            _field('LinkedIn URL', _linkedinCtrl, Icons.link),
          ]),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _saving ? null : _save,
              icon: _saving
                  ? const SizedBox(width: 16, height: 16,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : const Icon(Icons.save_outlined),
              label: Text(_saving ? 'Menyimpan...' : 'Simpan Profil'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4C2B9A),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ]);
      },
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF0F081C).withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: const TextStyle(
            color: Color(0xFF58DBFF), fontWeight: FontWeight.bold, fontSize: 14)),
        const SizedBox(height: 16),
        ...children,
      ]),
    );
  }

  Widget _field(String label, TextEditingController ctrl, IconData icon, {int maxLines = 1, ValueChanged<String>? onChanged}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: ctrl,
        maxLines: maxLines,
        onChanged: onChanged,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white54, fontSize: 13),
          prefixIcon: Icon(icon, color: Colors.white38, size: 18),
          filled: true,
          fillColor: Colors.white.withValues(alpha: 0.04),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.white12),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.white12),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFF58DBFF)),
          ),
        ),
      ),
    );
  }
}

// ─── Skills Editor ────────────────────────────────────────────────────────────

class _SkillsEditor extends StatelessWidget {
  const _SkillsEditor();

  @override
  Widget build(BuildContext context) {
    final svc = FirebaseService();
    return StreamBuilder<List<SkillData>>(
      stream: svc.skillsStream(),
      builder: (ctx, snap) {
        final skills = snap.data ?? SkillData.defaultList;
        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _AddButton(label: 'Tambah Keahlian', onTap: () => _showSkillDialog(ctx, svc, null, skills.length)),
          const SizedBox(height: 16),
          ...skills.asMap().entries.map((e) => _SkillCard(
            skill: e.value, order: e.key, svc: svc,
            onEdit: () => _showSkillDialog(ctx, svc, e.value, e.key),
          )),
        ]);
      },
    );
  }

  void _showSkillDialog(BuildContext ctx, FirebaseService svc, SkillData? existing, int order) {
    final nameCtrl = TextEditingController(text: existing?.name ?? '');
    final catCtrl = TextEditingController(text: existing?.category ?? '');
    double progress = existing?.progress ?? 0.8;

    showDialog(context: ctx, builder: (_) => StatefulBuilder(
      builder: (ctx2, setS) => AlertDialog(
        backgroundColor: const Color(0xFF0F081C),
        title: Text(existing == null ? 'Tambah Keahlian' : 'Edit Keahlian',
            style: const TextStyle(color: Colors.white)),
        content: SizedBox(
          width: 400,
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            _dialogField('Nama', nameCtrl),
            const SizedBox(height: 12),
            _dialogField('Kategori (cth: Language, Framework)', catCtrl),
            const SizedBox(height: 12),
            Row(children: [
              const Text('Level:', style: TextStyle(color: Colors.white70)),
              const SizedBox(width: 8),
              Expanded(child: Slider(
                value: progress, min: 0, max: 1,
                onChanged: (v) => setS(() => progress = v),
                activeColor: const Color(0xFF58DBFF),
              )),
              Text('${(progress * 100).toInt()}%',
                  style: const TextStyle(color: Colors.white)),
            ]),
          ]),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx2),
              child: const Text('Batal', style: TextStyle(color: Colors.white54))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4C2B9A)),
            onPressed: () async {
              await svc.saveSkill(SkillData(
                id: existing?.id ?? 'temp_${DateTime.now().millisecondsSinceEpoch}',
                name: nameCtrl.text, progress: progress,
                category: catCtrl.text, icon: '',
              ), order: order);
              if (ctx2.mounted) Navigator.pop(ctx2);
            },
            child: const Text('Simpan', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    ));
  }

  TextField _dialogField(String label, TextEditingController ctrl) {
    return TextField(
      controller: ctrl,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label, labelStyle: const TextStyle(color: Colors.white54),
        enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.white12)),
        focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Color(0xFF58DBFF))),
      ),
    );
  }
}

class _SkillCard extends StatelessWidget {
  final SkillData skill;
  final int order;
  final FirebaseService svc;
  final VoidCallback onEdit;
  const _SkillCard({required this.skill, required this.order, required this.svc, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0F081C).withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white12),
      ),
      child: Row(children: [
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(skill.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          Text(skill.category, style: const TextStyle(color: Colors.white54, fontSize: 12)),
          const SizedBox(height: 6),
          LinearProgressIndicator(
            value: skill.progress,
            backgroundColor: Colors.white12,
            color: const Color(0xFF58DBFF),
          ),
        ])),
        const SizedBox(width: 12),
        Text('${(skill.progress * 100).toInt()}%',
            style: const TextStyle(color: Color(0xFF58DBFF), fontWeight: FontWeight.bold)),
        const SizedBox(width: 8),
        IconButton(icon: const Icon(Icons.edit, color: Colors.white54, size: 18), onPressed: onEdit),
        IconButton(
          icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 18),
          onPressed: () async {
            final confirm = await showDialog<bool>(
              context: context,
              builder: (_) => AlertDialog(
                backgroundColor: const Color(0xFF0F081C),
                title: const Text('Hapus?', style: TextStyle(color: Colors.white)),
                content: Text('Hapus keahlian "${skill.name}"?',
                    style: const TextStyle(color: Colors.white70)),
                actions: [
                  TextButton(onPressed: () => Navigator.pop(context, false),
                      child: const Text('Batal')),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text('Hapus', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            );
            if (confirm == true) await svc.deleteSkill(skill.id);
          },
        ),
      ]),
    );
  }
}

// ─── Projects Editor ──────────────────────────────────────────────────────────

class _ProjectsEditor extends StatelessWidget {
  const _ProjectsEditor();

  @override
  Widget build(BuildContext context) {
    final svc = FirebaseService();
    return StreamBuilder<List<ProjectData>>(
      stream: svc.projectsStream(),
      builder: (ctx, snap) {
        final items = snap.data ?? ProjectData.defaultList;
        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _AddButton(label: 'Tambah Project', onTap: () => _showDialog(ctx, svc, null, items.length)),
          const SizedBox(height: 16),
          ...items.asMap().entries.map((e) => _ItemCard(
            title: e.value.title, subtitle: e.value.category,
            imageUrl: e.value.imageUrl,
            onEdit: () => _showDialog(ctx, svc, e.value, e.key),
            onDelete: () => svc.deleteProject(e.value.id),
          )),
        ]);
      },
    );
  }

  void _showDialog(BuildContext ctx, FirebaseService svc, ProjectData? existing, int order) {
    final titleCtrl = TextEditingController(text: existing?.title ?? '');
    final catCtrl = TextEditingController(text: existing?.category ?? '');
    final descCtrl = TextEditingController(text: existing?.description ?? '');
    final techCtrl = TextEditingController(text: existing?.technology.join(', ') ?? '');
    final urlCtrl = TextEditingController(text: existing?.projectUrl ?? '');
    final imageUrlCtrl = TextEditingController(text: existing?.imageUrl ?? '');
    String imageUrl = existing?.imageUrl ?? '';

    showDialog(context: ctx, builder: (_) => StatefulBuilder(
      builder: (ctx2, setS) => AlertDialog(
        backgroundColor: const Color(0xFF0F081C),
        title: Text(existing == null ? 'Tambah Project' : 'Edit Project',
            style: const TextStyle(color: Colors.white)),
        content: SizedBox(
          width: 500,
          child: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, children: [
            _tf('Judul Project', titleCtrl),
            const SizedBox(height: 12),
            _tf('Kategori', catCtrl),
            const SizedBox(height: 12),
            _tf('Deskripsi', descCtrl, maxLines: 3),
            const SizedBox(height: 12),
            _tf('Teknologi (pisah koma: Flutter, Firebase)', techCtrl),
            const SizedBox(height: 12),
            _tf('URL Project (opsional)', urlCtrl),
            const SizedBox(height: 12),
            // Image URL or upload
            _tf('URL Gambar / Foto Project (Google Drive / Direct URL)', imageUrlCtrl),
            const SizedBox(height: 8),
            Row(children: [
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.white12),
                icon: const Icon(Icons.upload, color: Colors.white, size: 16),
                label: const Text('Pilih File Gambar', style: TextStyle(color: Colors.white, fontSize: 13)),
                onPressed: () async {
                  final r = await FilePicker.platform.pickFiles(type: FileType.image, withData: true);
                  if (r == null || r.files.isEmpty) return;
                  final bytes = r.files.first.bytes;
                  if (bytes == null) return;
                  try {
                    final url = await svc.uploadImage(bytes,
                        'projects/${DateTime.now().millisecondsSinceEpoch}.jpg');
                    setS(() {
                      imageUrl = url;
                      imageUrlCtrl.text = url;
                    });
                  } catch (e) {
                    if (ctx2.mounted) {
                      ScaffoldMessenger.of(ctx2).showSnackBar(
                        SnackBar(content: Text('Upload Storage gagal: $e. Silakan paste URL gambar langsung pada kolom di atas.'), backgroundColor: Colors.red),
                      );
                    }
                  }
                },
              ),
            ]),
            if (imageUrl.isNotEmpty) ...[
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(imageUrl, height: 100, fit: BoxFit.cover),
              ),
            ],
          ])),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx2),
              child: const Text('Batal', style: TextStyle(color: Colors.white54))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4C2B9A)),
            onPressed: () async {
              await svc.saveProject(ProjectData(
                id: existing?.id ?? 'temp_${DateTime.now().millisecondsSinceEpoch}',
                title: titleCtrl.text, category: catCtrl.text,
                description: descCtrl.text,
                technology: techCtrl.text.split(',').map((e) => e.trim()).toList(),
                imageUrl: imageUrlCtrl.text.trim().isNotEmpty ? imageUrlCtrl.text.trim() : imageUrl,
                projectUrl: urlCtrl.text,
              ), order: order);
              if (ctx2.mounted) Navigator.pop(ctx2);
            },
            child: const Text('Simpan', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    ));
  }

  TextField _tf(String label, TextEditingController ctrl, {int maxLines = 1}) {
    return TextField(
      controller: ctrl, maxLines: maxLines,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label, labelStyle: const TextStyle(color: Colors.white54, fontSize: 13),
        enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.white12)),
        focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Color(0xFF58DBFF))),
      ),
    );
  }
}

// ─── Experience Editor ────────────────────────────────────────────────────────

class _ExperienceEditor extends StatelessWidget {
  const _ExperienceEditor();

  @override
  Widget build(BuildContext context) {
    final svc = FirebaseService();
    return StreamBuilder<List<ExperienceData>>(
      stream: svc.experienceStream(),
      builder: (ctx, snap) {
        final items = snap.data ?? ExperienceData.defaultList;
        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _AddButton(label: 'Tambah Pengalaman', onTap: () => _showDialog(ctx, svc, null, items.length)),
          const SizedBox(height: 16),
          ...items.asMap().entries.map((e) => _ItemCard(
            title: e.value.title, subtitle: '${e.value.company} • ${e.value.period}',
            onEdit: () => _showDialog(ctx, svc, e.value, e.key),
            onDelete: () => svc.deleteExperience(e.value.id),
          )),
        ]);
      },
    );
  }

  void _showDialog(BuildContext ctx, FirebaseService svc, ExperienceData? ex, int order) {
    final titleCtrl = TextEditingController(text: ex?.title ?? '');
    final companyCtrl = TextEditingController(text: ex?.company ?? '');
    final periodCtrl = TextEditingController(text: ex?.period ?? '');
    final descCtrl = TextEditingController(text: ex?.description ?? '');

    showDialog(context: ctx, builder: (_) => AlertDialog(
      backgroundColor: const Color(0xFF0F081C),
      title: Text(ex == null ? 'Tambah Pengalaman' : 'Edit Pengalaman',
          style: const TextStyle(color: Colors.white)),
      content: SizedBox(width: 400, child: Column(mainAxisSize: MainAxisSize.min, children: [
        _tf('Jabatan/Posisi', titleCtrl),
        const SizedBox(height: 12),
        _tf('Perusahaan/Institusi', companyCtrl),
        const SizedBox(height: 12),
        _tf('Tahun (cth: 2023 - 2024)', periodCtrl),
        const SizedBox(height: 12),
        _tf('Deskripsi', descCtrl, maxLines: 3),
      ])),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal', style: TextStyle(color: Colors.white54))),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4C2B9A)),
          onPressed: () async {
            await svc.saveExperience(ExperienceData(
              id: ex?.id ?? 'temp_${DateTime.now().millisecondsSinceEpoch}',
              title: titleCtrl.text, company: companyCtrl.text,
              period: periodCtrl.text, description: descCtrl.text, icon: 'work',
            ), order: order);
            if (ctx.mounted) Navigator.pop(ctx);
          },
          child: const Text('Simpan', style: TextStyle(color: Colors.white)),
        ),
      ],
    ));
  }

  TextField _tf(String label, TextEditingController ctrl, {int maxLines = 1}) {
    return TextField(
      controller: ctrl, maxLines: maxLines,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label, labelStyle: const TextStyle(color: Colors.white54, fontSize: 13),
        enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.white12)),
        focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Color(0xFF58DBFF))),
      ),
    );
  }
}

// ─── Certificates Editor ──────────────────────────────────────────────────────

class _CertificatesEditor extends StatelessWidget {
  const _CertificatesEditor();

  @override
  Widget build(BuildContext context) {
    final svc = FirebaseService();
    return StreamBuilder<List<CertificateData>>(
      stream: svc.certificatesStream(),
      builder: (ctx, snap) {
        final items = snap.data ?? CertificateData.defaultList;
        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _AddButton(label: 'Tambah Sertifikat', onTap: () => _showDialog(ctx, svc, null, items.length)),
          const SizedBox(height: 16),
          ...items.asMap().entries.map((e) => _ItemCard(
            title: e.value.name, subtitle: '${e.value.issuer} • ${e.value.year}',
            imageUrl: e.value.imageUrl,
            onEdit: () => _showDialog(ctx, svc, e.value, e.key),
            onDelete: () => svc.deleteCertificate(e.value.id),
          )),
        ]);
      },
    );
  }

  void _showDialog(BuildContext ctx, FirebaseService svc, CertificateData? ex, int order) {
    final nameCtrl = TextEditingController(text: ex?.name ?? '');
    final issuerCtrl = TextEditingController(text: ex?.issuer ?? '');
    final yearCtrl = TextEditingController(text: ex?.year ?? '');
    final certUrlCtrl = TextEditingController(text: ex?.imageUrl ?? '');
    String imageUrl = ex?.imageUrl ?? '';

    showDialog(context: ctx, builder: (_) => StatefulBuilder(
      builder: (ctx2, setS) => AlertDialog(
        backgroundColor: const Color(0xFF0F081C),
        title: Text(ex == null ? 'Tambah Sertifikat' : 'Edit Sertifikat',
            style: const TextStyle(color: Colors.white)),
        content: SizedBox(width: 400, child: Column(mainAxisSize: MainAxisSize.min, children: [
          _tf('Nama Sertifikat', nameCtrl),
          const SizedBox(height: 12),
          _tf('Penerbit (cth: Google, Coursera)', issuerCtrl),
          const SizedBox(height: 12),
          _tf('Tahun', yearCtrl),
          const SizedBox(height: 12),
          _tf('URL Foto Sertifikat (Google Drive / Direct URL)', certUrlCtrl),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.white12),
            icon: const Icon(Icons.upload, color: Colors.white, size: 16),
            label: const Text('Pilih File dari Komputer', style: TextStyle(color: Colors.white, fontSize: 13)),
            onPressed: () async {
              final r = await FilePicker.platform.pickFiles(type: FileType.image, withData: true);
              if (r == null || r.files.isEmpty) return;
              final bytes = r.files.first.bytes;
              if (bytes == null) return;
              try {
                final url = await svc.uploadImage(bytes,
                    'certificates/${DateTime.now().millisecondsSinceEpoch}.jpg');
                setS(() {
                  imageUrl = url;
                  certUrlCtrl.text = url;
                });
              } catch (e) {
                if (ctx2.mounted) {
                  ScaffoldMessenger.of(ctx2).showSnackBar(
                    SnackBar(content: Text('Upload Storage gagal: $e. Silakan gunakan URL foto langsung di atas.'), backgroundColor: Colors.red),
                  );
                }
              }
            },
          ),
          if (imageUrl.isNotEmpty || certUrlCtrl.text.isNotEmpty) ...[
            const SizedBox(height: 8),
            ClipRRect(borderRadius: BorderRadius.circular(8),
                child: Image.network(certUrlCtrl.text.isNotEmpty ? certUrlCtrl.text : imageUrl, height: 80, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const SizedBox.shrink())),
          ],
        ])),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx2),
              child: const Text('Batal', style: TextStyle(color: Colors.white54))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4C2B9A)),
            onPressed: () async {
              await svc.saveCertificate(CertificateData(
                id: ex?.id ?? 'temp_${DateTime.now().millisecondsSinceEpoch}',
                name: nameCtrl.text, issuer: issuerCtrl.text,
                year: yearCtrl.text,
                imageUrl: certUrlCtrl.text.trim().isNotEmpty ? certUrlCtrl.text.trim() : imageUrl,
              ), order: order);
              if (ctx2.mounted) Navigator.pop(ctx2);
            },
            child: const Text('Simpan', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    ));
  }

  TextField _tf(String label, TextEditingController ctrl, {int maxLines = 1}) {
    return TextField(
      controller: ctrl, maxLines: maxLines,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label, labelStyle: const TextStyle(color: Colors.white54, fontSize: 13),
        enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.white12)),
        focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Color(0xFF58DBFF))),
      ),
    );
  }
}

// ─── Research Editor ──────────────────────────────────────────────────────────

class _ResearchEditor extends StatelessWidget {
  const _ResearchEditor();

  @override
  Widget build(BuildContext context) {
    final svc = FirebaseService();
    return StreamBuilder<List<ResearchData>>(
      stream: svc.researchStream(),
      builder: (ctx, snap) {
        final items = snap.data ?? ResearchData.defaultList;
        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _AddButton(label: 'Tambah Riset', onTap: () => _showDialog(ctx, svc, null, items.length)),
          const SizedBox(height: 16),
          ...items.asMap().entries.map((e) => _ItemCard(
            title: e.value.title, subtitle: e.value.year,
            onEdit: () => _showDialog(ctx, svc, e.value, e.key),
            onDelete: () => svc.deleteResearch(e.value.id),
          )),
        ]);
      },
    );
  }

  void _showDialog(BuildContext ctx, FirebaseService svc, ResearchData? ex, int order) {
    final titleCtrl = TextEditingController(text: ex?.title ?? '');
    final absCtrl = TextEditingController(text: ex?.abstract ?? '');
    final techCtrl = TextEditingController(text: ex?.technology.join(', ') ?? '');
    final yearCtrl = TextEditingController(text: ex?.year ?? '');
    final urlCtrl = TextEditingController(text: ex?.url ?? '');

    showDialog(context: ctx, builder: (_) => AlertDialog(
      backgroundColor: const Color(0xFF0F081C),
      title: Text(ex == null ? 'Tambah Riset' : 'Edit Riset',
          style: const TextStyle(color: Colors.white)),
      content: SizedBox(width: 400, child: Column(mainAxisSize: MainAxisSize.min, children: [
        _tf('Judul Riset', titleCtrl),
        const SizedBox(height: 12),
        _tf('Abstrak', absCtrl, maxLines: 3),
        const SizedBox(height: 12),
        _tf('Teknologi (pisah koma)', techCtrl),
        const SizedBox(height: 12),
        _tf('Tahun', yearCtrl),
        const SizedBox(height: 12),
        _tf('URL Paper (opsional)', urlCtrl),
      ])),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal', style: TextStyle(color: Colors.white54))),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4C2B9A)),
          onPressed: () async {
            await svc.saveResearch(ResearchData(
              id: ex?.id ?? 'temp_${DateTime.now().millisecondsSinceEpoch}',
              title: titleCtrl.text, abstract: absCtrl.text,
              technology: techCtrl.text.split(',').map((e) => e.trim()).toList(),
              year: yearCtrl.text, url: urlCtrl.text,
            ), order: order);
            if (ctx.mounted) Navigator.pop(ctx);
          },
          child: const Text('Simpan', style: TextStyle(color: Colors.white)),
        ),
      ],
    ));
  }

  TextField _tf(String label, TextEditingController ctrl, {int maxLines = 1}) {
    return TextField(
      controller: ctrl, maxLines: maxLines,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label, labelStyle: const TextStyle(color: Colors.white54, fontSize: 13),
        enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.white12)),
        focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Color(0xFF58DBFF))),
      ),
    );
  }
}

// ─── Gallery Editor ───────────────────────────────────────────────────────────

class _GalleryEditor extends StatefulWidget {
  const _GalleryEditor();
  @override
  State<_GalleryEditor> createState() => _GalleryEditorState();
}

class _GalleryEditorState extends State<_GalleryEditor> {
  final _svc = FirebaseService();
  bool _uploading = false;

  Future<void> _uploadImages() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image, withData: true, allowMultiple: true);
    if (result == null || result.files.isEmpty) return;
    setState(() => _uploading = true);
    try {
      for (final file in result.files) {
        if (file.bytes == null) continue;
        final url = await _svc.uploadImage(file.bytes!,
            'gallery/${DateTime.now().millisecondsSinceEpoch}_${file.name}');
        await _svc.addGalleryImage(url);
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Foto berhasil diupload!'),
                backgroundColor: Colors.green));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red));
      }
    } finally {
      if (mounted) setState(() => _uploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<String>>(
      stream: _svc.galleryStream(),
      builder: (ctx, snap) {
        final images = snap.data ?? [];
        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _AddButton(
            label: _uploading ? 'Mengupload...' : 'Upload Foto (bisa multiple)',
            onTap: _uploading ? null : _uploadImages,
            icon: Icons.upload,
          ),
          const SizedBox(height: 16),
          if (images.isEmpty)
            Container(
              padding: const EdgeInsets.all(40),
              decoration: BoxDecoration(
                color: const Color(0xFF0F081C).withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white12),
              ),
              child: const Center(
                child: Column(children: [
                  Icon(Icons.photo_library_outlined, color: Colors.white24, size: 48),
                  SizedBox(height: 12),
                  Text('Belum ada foto di galeri',
                      style: TextStyle(color: Colors.white38)),
                ]),
              ),
            )
          else
            GridView.builder(
              shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4, crossAxisSpacing: 10, mainAxisSpacing: 10),
              itemCount: images.length,
              itemBuilder: (ctx, i) => Stack(children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(images[i], fit: BoxFit.cover,
                      width: double.infinity, height: double.infinity),
                ),
                Positioned(
                  top: 4, right: 4,
                  child: GestureDetector(
                    onTap: () async {
                      final ok = await showDialog<bool>(
                        context: ctx,
                        builder: (_) => AlertDialog(
                          backgroundColor: const Color(0xFF0F081C),
                          title: const Text('Hapus foto?', style: TextStyle(color: Colors.white)),
                          actions: [
                            TextButton(onPressed: () => Navigator.pop(ctx, false),
                                child: const Text('Batal')),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                              onPressed: () => Navigator.pop(ctx, true),
                              child: const Text('Hapus', style: TextStyle(color: Colors.white)),
                            ),
                          ],
                        ),
                      );
                      if (ok == true) {
                        await _svc.removeGalleryImage(images[i]);
                        await _svc.deleteImage(images[i]);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.red.withValues(alpha: 0.8),
                        shape: BoxShape.circle),
                      child: const Icon(Icons.close, color: Colors.white, size: 12),
                    ),
                  ),
                ),
              ]),
            ),
        ]);
      },
    );
  }
}

// ─── Shared Widgets ───────────────────────────────────────────────────────────

class _AddButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final IconData icon;
  const _AddButton({required this.label, required this.onTap, this.icon = Icons.add});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF4C2B9A),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

class _ItemCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? imageUrl;
  final VoidCallback onEdit;
  final Future<void> Function() onDelete;
  const _ItemCard({
    required this.title, required this.subtitle,
    this.imageUrl, required this.onEdit, required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0F081C).withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white12),
      ),
      child: Row(children: [
        if (imageUrl != null && imageUrl!.isNotEmpty) ...[
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(imageUrl!, width: 50, height: 50, fit: BoxFit.cover),
          ),
          const SizedBox(width: 12),
        ],
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          const SizedBox(height: 2),
          Text(subtitle, style: const TextStyle(color: Colors.white54, fontSize: 12)),
        ])),
        IconButton(icon: const Icon(Icons.edit, color: Colors.white54, size: 18), onPressed: onEdit),
        IconButton(
          icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 18),
          onPressed: () async {
            final ok = await showDialog<bool>(
              context: context,
              builder: (_) => AlertDialog(
                backgroundColor: const Color(0xFF0F081C),
                title: const Text('Hapus?', style: TextStyle(color: Colors.white)),
                content: Text('Hapus "$title"?', style: const TextStyle(color: Colors.white70)),
                actions: [
                  TextButton(onPressed: () => Navigator.pop(context, false),
                      child: const Text('Batal')),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text('Hapus', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            );
            if (ok == true) await onDelete();
          },
        ),
      ]),
    );
  }
}

// ─── Documents Editor ─────────────────────────────────────────────────────────

class _DocumentsEditor extends StatefulWidget {
  const _DocumentsEditor();
  @override
  State<_DocumentsEditor> createState() => _DocumentsEditorState();
}

class _DocumentsEditorState extends State<_DocumentsEditor> {
  final _svc = FirebaseService();
  bool _uploading = false;
  String _filterCategory = 'all';

  static const _categories = [
    {'value': 'all', 'label': 'Semua'},
    {'value': 'cv', 'label': 'CV / Resume'},
    {'value': 'cover_letter', 'label': 'Surat Lamaran'},
    {'value': 'certificate', 'label': 'Sertifikat'},
    {'value': 'other', 'label': 'Lainnya'},
  ];

  static const _uploadCategories = [
    {'value': 'cv', 'label': 'CV / Resume'},
    {'value': 'cover_letter', 'label': 'Surat Lamaran'},
    {'value': 'certificate', 'label': 'Sertifikat'},
    {'value': 'other', 'label': 'Dokumen Lain'},
  ];

  Color _categoryColor(String cat) {
    switch (cat) {
      case 'cv': return const Color(0xFF58DBFF);
      case 'cover_letter': return const Color(0xFFB388FF);
      case 'certificate': return const Color(0xFFFFD740);
      default: return Colors.white54;
    }
  }



  Future<void> _addLinkDialog() async {
    final titleCtrl = TextEditingController(text: 'CV - Mas Fiqi');
    final urlCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    String selectedCategory = 'cv';

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setS) => AlertDialog(
          backgroundColor: const Color(0xFF0F081C),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Row(
            children: [
              Icon(Icons.add_link_rounded, color: Color(0xFF58DBFF)),
              SizedBox(width: 8),
              Text('Tambah Link Dokumen (Google Drive)', style: TextStyle(color: Colors.white, fontSize: 16)),
            ],
          ),
          content: SingleChildScrollView(
            child: SizedBox(
              width: 440,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Judul Dokumen', style: TextStyle(color: Colors.white54, fontSize: 12)),
                  const SizedBox(height: 6),
                  TextField(
                    controller: titleCtrl,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Misal: CV Mas Fiqi 2026.pdf',
                      hintStyle: const TextStyle(color: Colors.white30, fontSize: 13),
                      filled: true,
                      fillColor: Colors.white.withValues(alpha: 0.05),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Colors.white12)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text('Link Google Drive / URL Dokumen', style: TextStyle(color: Color(0xFF58DBFF), fontSize: 12, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  TextField(
                    controller: urlCtrl,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'https://drive.google.com/file/d/...',
                      hintStyle: const TextStyle(color: Colors.white30, fontSize: 13),
                      filled: true,
                      fillColor: Colors.white.withValues(alpha: 0.05),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFF58DBFF))),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    '*Pastikan akses Google Drive diatur ke "Siapa saja yang memiliki link"',
                    style: TextStyle(color: Colors.white38, fontSize: 11, fontStyle: FontStyle.italic),
                  ),
                  const SizedBox(height: 14),
                  const Text('Kategori', style: TextStyle(color: Colors.white54, fontSize: 12)),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<String>(
                    initialValue: selectedCategory,
                    dropdownColor: const Color(0xFF1A0F30),
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white.withValues(alpha: 0.05),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Colors.white12)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                    items: _uploadCategories.map((c) => DropdownMenuItem(
                      value: c['value'],
                      child: Text(c['label']!),
                    )).toList(),
                    onChanged: (v) => setS(() => selectedCategory = v ?? 'cv'),
                  ),
                  const SizedBox(height: 14),
                  const Text('Deskripsi (Opsional)', style: TextStyle(color: Colors.white54, fontSize: 12)),
                  const SizedBox(height: 6),
                  TextField(
                    controller: descCtrl,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Catatan singkat atau versi dokumen...',
                      hintStyle: const TextStyle(color: Colors.white30, fontSize: 13),
                      filled: true,
                      fillColor: Colors.white.withValues(alpha: 0.05),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Colors.white12)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4C2B9A)),
              onPressed: () {
                if (urlCtrl.text.trim().isEmpty) return;
                Navigator.pop(ctx, true);
              },
              child: const Text('Simpan Link', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );

    if (confirmed != true) return;
    setState(() => _uploading = true);
    try {
      await _svc.addDocumentLink(
        title: titleCtrl.text.trim().isEmpty ? 'Dokumen Mas Fiqi' : titleCtrl.text.trim(),
        downloadUrl: urlCtrl.text.trim(),
        category: selectedCategory,
        description: descCtrl.text.trim(),
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Dokumen Google Drive berhasil ditambahkan!'), backgroundColor: Colors.green),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menyimpan: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _uploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header & Upload Button
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1A0F30), Color(0xFF0F081C)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white12),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4C2B9A).withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.description_outlined, color: Color(0xFF58DBFF), size: 22),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Kelola Dokumen', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                          Text('CV, Surat Lamaran, Sertifikat (Google Drive / Link)', style: TextStyle(color: Colors.white54, fontSize: 12)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton.icon(
              onPressed: _uploading ? null : _addLinkDialog,
              icon: const Icon(Icons.add_link_rounded, color: Colors.white, size: 18),
              label: const Text('Tambah Link Drive', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4C2B9A),
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Category Filter Chips
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: _categories.map((cat) {
              final isSelected = _filterCategory == cat['value'];
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: Text(cat['label']!),
                  selected: isSelected,
                  onSelected: (_) => setState(() => _filterCategory = cat['value']!),
                  backgroundColor: Colors.white10,
                  selectedColor: const Color(0xFF4C2B9A),
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Colors.white60,
                    fontSize: 12,
                  ),
                  side: BorderSide(
                    color: isSelected ? const Color(0xFF58DBFF) : Colors.white12,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 16),

        // Document List
        StreamBuilder<List<DocumentFileData>>(
          stream: _svc.documentsStream(),
          builder: (ctx, snap) {
            if (snap.hasError) {
              return Center(child: Text('Error: ${snap.error}',
                  style: const TextStyle(color: Colors.redAccent)));
            }
            if (!snap.hasData) {
              return const Center(child: CircularProgressIndicator(color: Color(0xFF58DBFF)));
            }
            final allDocs = snap.data!;
            final docs = _filterCategory == 'all'
                ? allDocs
                : allDocs.where((d) => d.category == _filterCategory).toList();

            if (docs.isEmpty) {
              return Container(
                padding: const EdgeInsets.all(40),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.03),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white12),
                ),
                child: Center(
                  child: Column(
                    children: [
                      Icon(Icons.folder_off_outlined, color: Colors.white24, size: 48),
                      const SizedBox(height: 12),
                      Text(
                        _filterCategory == 'all'
                            ? 'Belum ada dokumen. Upload PDF pertama kamu!'
                            : 'Belum ada dokumen di kategori ini.',
                        style: const TextStyle(color: Colors.white38, fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            }

            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: docs.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (ctx, i) => _buildDocumentTile(docs[i]),
            );
          },
        ),
      ],
    );
  }

  Widget _buildDocumentTile(DocumentFileData doc) {
    final catColor = _categoryColor(doc.category);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0F081C).withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white12),
      ),
      child: Row(
        children: [
          // PDF Icon
          Container(
            width: 48, height: 48,
            decoration: BoxDecoration(
              color: catColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: catColor.withValues(alpha: 0.3)),
            ),
            child: Icon(Icons.picture_as_pdf_outlined, color: catColor, size: 24),
          ),
          const SizedBox(width: 14),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(doc.fileName,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13),
                    overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: catColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(doc.categoryLabel,
                          style: TextStyle(color: catColor, fontSize: 10, fontWeight: FontWeight.w600)),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${doc.uploadedAt.day}/${doc.uploadedAt.month}/${doc.uploadedAt.year}',
                      style: const TextStyle(color: Colors.white38, fontSize: 11),
                    ),
                  ],
                ),
                if (doc.description.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(doc.description,
                      style: const TextStyle(color: Colors.white54, fontSize: 11),
                      overflow: TextOverflow.ellipsis),
                ],
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Visibility Toggle
          Column(
            children: [
              const Text('Publik', style: TextStyle(color: Colors.white38, fontSize: 10)),
              Switch(
                value: doc.isPublic,
                onChanged: (val) => _svc.updateDocument(doc.copyWith(isPublic: val)),
                activeThumbColor: const Color(0xFF58DBFF),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ],
          ),
          // Delete
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
            tooltip: 'Hapus dokumen',
            onPressed: () async {
              final ok = await showDialog<bool>(
                context: context,
                builder: (_) => AlertDialog(
                  backgroundColor: const Color(0xFF0F081C),
                  title: const Text('Hapus Dokumen?', style: TextStyle(color: Colors.white)),
                  content: Text('Hapus "${doc.fileName}"? File akan dihapus permanen.',
                      style: const TextStyle(color: Colors.white70)),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(context, false),
                        child: const Text('Batal')),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Hapus', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              );
              if (ok == true) {
                await _svc.deleteDocument(doc);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Dokumen dihapus'), backgroundColor: Colors.orange),
                  );
                }
              }
            },
          ),
        ],
      ),
    );
  }
}

