import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rightflair/core/extensions/context.dart';
import '../cubit/create_post_cubit.dart';

class CreatePostImageWidget extends StatelessWidget {
  const CreatePostImageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreatePostCubit, CreatePostState>(
      builder: (context, state) {
        return Center(
          child: Container(
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
        );
      },
    );
  }
}
