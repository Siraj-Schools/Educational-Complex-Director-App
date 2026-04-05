import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class GeoLoading extends StatelessWidget {
  const GeoLoading({super.key, required this.color});
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: LoadingAnimationWidget.waveDots(
        color: color.withAlpha(200),
        size: 60,
      ),
    );
  }
}
