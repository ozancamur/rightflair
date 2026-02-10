import 'package:flutter/material.dart';
import 'package:rightflair/core/extensions/context.dart';

class PostDetailImageWidget extends StatelessWidget {
  final String imageUrl;

  const PostDetailImageWidget({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(context.width * 0.04),
      child: Image.network(
        imageUrl,
        width: context.width,
        height: context.height * 0.75,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            width: context.width,
            height: context.height * 0.75,
            color: Colors.black26,
            child: Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                    : null,
              ),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: context.width,
            height: context.height * 0.75,
            color: Colors.black26,
            child: Icon(
              Icons.error_outline,
              size: context.width * 0.15,
              color: Colors.white54,
            ),
          );
        },
      ),
    );
  }
}
