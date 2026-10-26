import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../services/firebase_service.dart';
import 'admin_dashboard_page.dart';

class AdminLoginPage extends StatefulWidget {
  const AdminLoginPage({super.key});

  @override
  State<AdminLoginPage> createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends State<AdminLoginPage> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _loading = false;
  bool _obscure = true;
  String? _error;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_emailCtrl.text.isEmpty || _passCtrl.text.isEmpty) {
      setState(() => _error = 'Email dan password tidak boleh kosong');
      return;
    }
    setState(() { _loading = true; _error = null; });
    try {
      final errorMsg = await FirebaseService().loginAdmin(
        _emailCtrl.text.trim(),
        _passCtrl.text,
      );
      if (!mounted) return;
      if (errorMsg == null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const AdminDashboardPage()),
        );
      } else {
        setState(() {
          _error = errorMsg;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Terjadi kesalahan sistem: $e';
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Soft Aurora Aura
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 500,
              height: 500,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFFC7D2FE).withValues(alpha: 0.35),
                    const Color(0xFFDDD6FE).withValues(alpha: 0.15),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -100,
            left: -100,
            child: Container(
              width: 450,
              height: 450,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFFBAE6FD).withValues(alpha: 0.30),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Container(
                width: 440,
                padding: const EdgeInsets.all(40),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF0F172A).withValues(alpha: 0.06),
                      blurRadius: 32,
                      offset: const Offset(0, 10),
                    ),
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.05),
                      blurRadius: 24,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Brand Icon
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.30),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(Icons.admin_panel_settings_rounded, color: Colors.white, size: 32),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Admin Dashboard',
                      style: GoogleFonts.plusJakartaSans(
                        color: AppColors.textPrimary,
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Masuk untuk mengelola portofolio & data',
                      style: GoogleFonts.plusJakartaSans(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Email Input
                    _buildTextField(
                      controller: _emailCtrl,
                      label: 'Email Admin',
                      icon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 18),

                    // Password Input
                    _buildTextField(
                      controller: _passCtrl,
                      label: 'Password',
                      icon: Icons.lock_outline,
                      obscure: _obscure,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscure ? Icons.visibility_off : Icons.visibility,
                          color: AppColors.textMuted,
                          size: 20,
                        ),
                        onPressed: () => setState(() => _obscure = !_obscure),
                      ),
                      onSubmitted: (_) => _login(),
                    ),

                    if (_error != null) ...[
                      const SizedBox(height: 14),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEF2F2),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFFFECACA)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.error_outline_rounded, color: Color(0xFFDC2626), size: 18),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _error!,
                                style: GoogleFonts.plusJakartaSans(color: const Color(0xFFDC2626), fontSize: 13, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    const SizedBox(height: 28),

                    // Login Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _loading ? null : _login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          shadowColor: AppColors.primary.withValues(alpha: 0.35),
                        ),
                        child: _loading
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                              )
                            : Text(
                                'Masuk ke Dashboard',
                                style: GoogleFonts.plusJakartaSans(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Back to portfolio public link
                    TextButton.icon(
                      onPressed: () => Navigator.of(context).pushReplacementNamed('/'),
                      icon: const Icon(Icons.arrow_back_rounded, size: 16, color: AppColors.textSecondary),
                      label: Text(
                        'Kembali ke Halaman Utama',
                        style: GoogleFonts.plusJakartaSans(color: AppColors.textSecondary, fontSize: 13, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscure = false,
    Widget? suffixIcon,
    TextInputType? keyboardType,
    Function(String)? onSubmitted,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          obscureText: obscure,
          keyboardType: keyboardType,
          onSubmitted: onSubmitted,
          style: GoogleFonts.plusJakartaSans(color: AppColors.textPrimary, fontSize: 14),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: AppColors.textSecondary, size: 18),
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: AppColors.backgroundAlt,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
