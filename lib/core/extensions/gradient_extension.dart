import 'package:flutter/material.dart';

/// Shared extensions for Ethio IQ app
/// 
/// Place common extensions here to avoid duplication
extension GradientExtension on LinearGradient {
  /// Convert LinearGradient to BoxDecoration
  BoxDecoration toBoxDecoration() {
    return BoxDecoration(
      gradient: this,
      borderRadius: BorderRadius.circular(12),
    );
  }
}