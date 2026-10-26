import 'package:flutter/material.dart';

/// ============================================================
/// PREMIUM MINIMALIST LIGHT MODE — Design Token System
/// Target: Professional, editorial, premium corporate feel
/// ============================================================
class AppColors {
  // ── Core Background ──────────────────────────────────────
  static const Color background      = Color(0xFFF8FAFC); // Main page bg
  static const Color backgroundLight = Color(0xFFF8FAFC); // Main page bg light
  static const Color backgroundAlt   = Color(0xFFF1F5F9); // Alternate section bg
  static const Color backgroundDark  = Color(0xFFF8FAFC); // Alias (keep compat)
  static const Color surface         = Color(0xFFFFFFFF); // Card surfaces
  static const Color surfaceElevated = Color(0xFFFAFAFF); // Slightly elevated card

  // ── Text ─────────────────────────────────────────────────
  static const Color textPrimary     = Color(0xFF111827); // Main heading
  static const Color textSecondary   = Color(0xFF64748B); // Subtext, labels
  static const Color textMuted       = Color(0xFF94A3B8); // Captions, metadata
  static const Color textInverse     = Color(0xFFFFFFFF); // On dark backgrounds

  // Legacy compat aliases
  static const Color textPrimaryLight   = textPrimary;
  static const Color textSecondaryLight = textSecondary;
  static const Color textPrimaryDark    = textInverse;
  static const Color textSecondaryDark  = textSecondary;

  // ── Accent / Brand ───────────────────────────────────────
  static const Color primary   = Color(0xFF4F46E5); // Indigo - primary CTA
  static const Color secondary = Color(0xFF6366F1); // Indigo light
  static const Color accent    = Color(0xFF8B5CF6); // Violet - highlight

  // ── Border & Divider ─────────────────────────────────────
  static const Color border      = Color(0xFFE2E8F0); // Subtle border
  static const Color borderLight = Color(0xFFF1F5F9); // Ultra-light border
  static const Color divider     = Color(0xFFE2E8F0);

  // ── Dark Footer / Navy ───────────────────────────────────
  static const Color navy        = Color(0xFF0F172A); // Deep navy footer
  static const Color navyLight   = Color(0xFF1E293B); // Slightly lighter navy
  static const Color cardDark    = Color(0xFF1E293B); // Dark card (for footer)
  static const Color cardLight   = surface;

  // ── Semantic / Status ────────────────────────────────────
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error   = Color(0xFFEF4444);
  static const Color info    = primary;

  // ── Gradient (used sparingly on hero headline + CTA only) ─
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, secondary, accent],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0.0, 0.5, 1.0],
  );

  // Alias
  static const LinearGradient glowGradient = primaryGradient;

  // ── Shadow ───────────────────────────────────────────────
  static const Color softBlueShadow = Color(0x1A4F46E5);

  static List<BoxShadow> get cardShadow => [
    BoxShadow(
      color: const Color(0xFF64748B).withValues(alpha: 0.08),
      blurRadius: 24,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> get cardShadowHover => [
    BoxShadow(
      color: primary.withValues(alpha: 0.12),
      blurRadius: 32,
      offset: const Offset(0, 8),
    ),
  ];

  static List<BoxShadow> get subtleShadow => [
    BoxShadow(
      color: const Color(0xFF64748B).withValues(alpha: 0.05),
      blurRadius: 12,
      offset: const Offset(0, 2),
    ),
  ];
}
