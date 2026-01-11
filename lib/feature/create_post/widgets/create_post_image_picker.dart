import 'package:flutter/material.dart';
import 'package:rightflair/core/extensions/context.dart';
import 'package:rightflair/core/constants/dark_color.dart';

class CreatePostImagePickerWidget extends StatelessWidget {
  const CreatePostImagePickerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: context.width * 0.35,
        height: context.width * 0.35,
        margin: EdgeInsets.symmetric(vertical: context.height * 0.02),
        decoration: BoxDecoration(
          color: AppDarkColors.INACTIVE,
          borderRadius: BorderRadius.circular(context.width * 0.08),
          image: const DecorationImage(
            // Placeholder image or logic to show selected image
            image: NetworkImage(
              'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?q=80&w=1000&auto=format&fit=crop',
            ),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
