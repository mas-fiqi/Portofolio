import 'package:flutter/material.dart';

/// ============================================================
/// PREMIUM MODERN DEVELOPER PORTFOLIO — Design Token System
/// Concept: Aurora Glass, Soft Lavender-Indigo Gradients, Interactive Tech.
/// Clean, accessible, ultra-light yet deep and layered.
/// ============================================================
class AppColors {
  // ── Core Background ──────────────────────────────────────
  static const Color background      = Color(0xFFF8FAFC); // Main canvas
  static const Color backgroundLight = Color(0xFFFAFBFF); // Warm tinted light
  static const Color backgroundAlt   = Color(0xFFF1F5F9); // Section alternate
  static const Color backgroundDark  = Color(0xFFF8FAFC); // Keep compat
  static const Color surface         = Color(0xFFFFFFFF); // Card & surface base
  static const Color surfaceElevated = Color(0xFFFDFDFE); // Slightly elevated surface
  static const Color surfaceSubtle   = Color(0xFFF8F9FD); // Soft tinted card

  // ── Aurora Glass & Ambient Tint Tones ────────────────────
  static const Color auroraPurple    = Color(0xFF8B5CF6); // Soft violet
  static const Color auroraIndigo    = Color(0xFF6366F1); // Radiant indigo
  static const Color auroraBlue      = Color(0xFF38BDF8); // Pale sky blue
  static const Color auroraLavender  = Color(0xFFDDD6FE); // Soft pastel lavender
  static const Color auroraPink      = Color(0xFFF472B6); // Soft pink accent

  // ── Admin Panel Light Theme Tones ────────────────────────
  static const Color adminBg         = Color(0xFFF8FAFC); // Clean admin canvas
  static const Color adminSidebar    = Color(0xFFFFFFFF); // Crisp clean white sidebar
  static const Color adminCard       = Color(0xFFFFFFFF); // Clean white card
  static const Color adminCardBorder = Color(0xFFE2E8F0); // Subtle card border
  static const Color adminHeader     = Color(0xFFFFFFFF); // Header bar

  // ── Text (WCAG AAA/AA Compliant) ─────────────────────────
  static const Color textPrimary     = Color(0xFF0F172A); // High contrast slate-900
  static const Color textSecondary   = Color(0xFF475569); // Slate-600 readable subtext
  static const Color textMuted       = Color(0xFF64748B); // Slate-500 captions
  static const Color textLight       = Color(0xFF94A3B8); // Slate-400 placeholder
  static const Color textInverse     = Color(0xFFFFFFFF); // Pure white

  // Legacy compat aliases
  static const Color textPrimaryLight   = textPrimary;
  static const Color textSecondaryLight = textSecondary;
  static const Color textPrimaryDark    = textInverse;
  static const Color textSecondaryDark  = textSecondary;

  // ── Brand / Primary Interactive ──────────────────────────
  static const Color primary       = Color(0xFF4F46E5); // Indigo 600 - Main CTA
  static const Color primaryHover  = Color(0xFF4338CA); // Indigo 700 - Hover
  static const Color secondary     = Color(0xFF6366F1); // Indigo 500 - Light
  static const Color accent        = Color(0xFF8B5CF6); // Violet 500 - Focus/Aura

  // ── Borders & Dividers ───────────────────────────────────
  static const Color border      = Color(0xFFE2E8F0); // Slate-200 standard
  static const Color borderLight = Color(0xFFF1F5F9); // Slate-100 delicate
  static const Color borderFocus = Color(0xFF6366F1); // Focus ring
  static const Color divider     = Color(0xFFE2E8F0);

  // ── Dark Footer / Contrast Section ───────────────────────
  static const Color navy        = Color(0xFF0F172A); // Deep Slate 900
  static const Color navyLight   = Color(0xFF1E293B); // Slate 800
  static const Color cardDark    = Color(0xFF1E293B);
  static const Color cardLight   = surface;

  // ── Semantic / Status ────────────────────────────────────
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error   = Color(0xFFEF4444);
  static const Color info    = primary;

  // ── Soft Aurora Gradients ────────────────────────────────
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF4F46E5), Color(0xFF6366F1), Color(0xFF8B5CF6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient auroraGradient = LinearGradient(
    colors: [
      Color(0x33C7D2FE), // Very soft indigo tint
      Color(0x22E0E7FF), // Pale blue tint
      Color(0x33DDD6FE), // Lavender tint
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient glassGradient = LinearGradient(
    colors: [
      Color(0xF2FFFFFF), // 95% opacity white
      Color(0xE6FFFFFF), // 90% opacity white
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient glowGradient = primaryGradient;

  // ── Elevation & Shadows ──────────────────────────────────
  static const Color softBlueShadow = Color(0x1A4F46E5);

  static List<BoxShadow> get cardShadow => [
    BoxShadow(
      color: const Color(0xFF0F172A).withValues(alpha: 0.04),
      blurRadius: 16,
      offset: const Offset(0, 4),
    ),
    BoxShadow(
      color: const Color(0xFF6366F1).withValues(alpha: 0.03),
      blurRadius: 32,
      offset: const Offset(0, 8),
    ),
  ];

  static List<BoxShadow> get cardShadowHover => [
    BoxShadow(
      color: primary.withValues(alpha: 0.12),
      blurRadius: 28,
      offset: const Offset(0, 10),
    ),
    BoxShadow(
      color: const Color(0xFF0F172A).withValues(alpha: 0.06),
      blurRadius: 16,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> get subtleShadow => [
    BoxShadow(
      color: const Color(0xFF0F172A).withValues(alpha: 0.03),
      blurRadius: 10,
      offset: const Offset(0, 2),
    ),
  ];

  static List<BoxShadow> get auroraGlow => [
    BoxShadow(
      color: const Color(0xFF8B5CF6).withValues(alpha: 0.15),
      blurRadius: 40,
      spreadRadius: 4,
    ),
  ];
}
