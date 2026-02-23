import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rightflair/core/constants/route.dart';
import 'package:rightflair/core/extensions/context.dart';
import '../cubit/post_update_cubit.dart';

class PostUpdateImageWidget extends StatelessWidget {
  const PostUpdateImageWidget({super.key});

  void _showFullScreenImage(BuildContext context, ImageProvider imageProvider) {
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
                child: Image(image: imageProvider, fit: BoxFit.contain),
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
    return BlocBuilder<PostUpdateCubit, PostUpdateState>(
      builder: (context, state) {
        // Determine image provider: new local image > existing network image
        final ImageProvider? imageProvider;
        if (state.imagePath != null) {
          imageProvider = FileImage(File(state.imagePath!));
        } else if (state.postImageUrl != null &&
            state.postImageUrl!.isNotEmpty) {
          imageProvider = NetworkImage(state.postImageUrl!);
        } else {
          imageProvider = null;
        }

        return Center(
          child: GestureDetector(
            onTap: state.isProcessingImage
                ? null
                : imageProvider != null
                ? () => _showFullScreenImage(context, imageProvider!)
                : () => context.push(RouteConstants.CAMERA),
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
                    image: imageProvider != null
                        ? DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: imageProvider == null
                      ? Icon(
                          Icons.add_photo_alternate,
                          size: context.width * 0.1,
                          color: context.colors.tertiary,
                        )
                      : null,
                ),
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
