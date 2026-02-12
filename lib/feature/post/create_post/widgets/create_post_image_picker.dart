import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rightflair/core/extensions/context.dart';
import '../cubit/create_post_cubit.dart';

class CreatePostImageWidget extends StatelessWidget {
  const CreatePostImageWidget({super.key});

  void _showFullScreenImage(BuildContext context, String imagePath) {
    showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.zero,
        child: Stack(
          children: [
            Center(
              child: InteractiveViewer(
                minScale: 0.5,
                maxScale: 4.0,
                child: Image.file(File(imagePath), fit: BoxFit.contain),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).padding.top + 10,
              right: 10,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 30),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreatePostCubit, CreatePostState>(
      builder: (context, state) {
        return Center(
          child: GestureDetector(
            onTap: state.imagePath != null && !state.isProcessingImage
                ? () => _showFullScreenImage(context, state.imagePath!)
                : null,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: context.width * 0.35,
                  height: context.width * 0.35,
                  margin: EdgeInsets.symmetric(vertical: context.height * 0.02),
                  decoration: BoxDecoration(
                    color: context.colors.shadow,
                    borderRadius: BorderRadius.circular(context.width * 0.08),
                    image: state.imagePath != null
                        ? DecorationImage(
                            image: FileImage(File(state.imagePath!)),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: state.imagePath == null
                      ? Icon(
                          Icons.add_photo_alternate,
                          size: context.width * 0.1,
                          color: context.colors.tertiary,
                        )
                      : null,
                ),
                // Loading overlay
                if (state.isProcessingImage)
                  Container(
                    width: context.width * 0.35,
                    height: context.width * 0.35,
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(context.width * 0.08),
                    ),
                    child: const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
