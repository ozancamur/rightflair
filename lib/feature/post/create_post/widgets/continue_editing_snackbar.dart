import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rightflair/core/components/text/text.dart';
import 'package:rightflair/core/constants/font/font_size.dart';
import 'package:rightflair/core/constants/route.dart';
import 'package:rightflair/core/constants/string.dart';
import 'package:rightflair/core/extensions/context.dart';

import '../cubit/create_post_cubit.dart';

class ContinueEditingSnackbar {
  static OverlayEntry? _currentOverlay;

  /// Shows the "Continue editing this post" snackbar at the top
  static void show(
    BuildContext context, {
    required Map<String, dynamic> pendingPostData,
  }) {
    debugPrint(
      '[ContinueEditing] Snackbar.show() called, imagePath=${pendingPostData['imagePath']}',
    );

    // Remove existing overlay if any
    _currentOverlay?.remove();
    _currentOverlay = null;

    final imagePath = pendingPostData['imagePath'] as String?;
    debugPrint('[ContinueEditing] Snackbar.show(): imagePath=$imagePath');

    _currentOverlay = OverlayEntry(
      builder: (overlayContext) => _ContinueEditingOverlay(
        imagePath: imagePath,
        onDismiss: () {
          debugPrint('[ContinueEditing] Snackbar: dismissed');
          _currentOverlay?.remove();
          _currentOverlay = null;
        },
        onSaveDraft: () {
          debugPrint('[ContinueEditing] Snackbar: saveDraft pressed');
          _currentOverlay?.remove();
          _currentOverlay = null;
          // State already restored in NavigationPage, just create draft
          context.read<CreatePostCubit>().createDraft(context);
        },
        onEdit: () {
          debugPrint('[ContinueEditing] Snackbar: edit pressed');
          _currentOverlay?.remove();
          _currentOverlay = null;
          // State already restored in NavigationPage, just navigate
          final cubit = context.read<CreatePostCubit>();
          debugPrint(
            '[ContinueEditing] Snackbar: navigating with imagePath=${cubit.state.imagePath}',
          );
          context.push(RouteConstants.CREATE_POST);
        },
      ),
    );

    try {
      Overlay.of(context).insert(_currentOverlay!);
      debugPrint(
        '[ContinueEditing] Snackbar.show(): overlay inserted successfully',
      );
    } catch (e, stackTrace) {
      debugPrint(
        '[ContinueEditing] Snackbar.show(): ERROR inserting overlay: $e',
      );
      debugPrint('[ContinueEditing] StackTrace: $stackTrace');
    }
  }
}

class _ContinueEditingOverlay extends StatefulWidget {
  final String? imagePath;
  final VoidCallback onDismiss;
  final VoidCallback onSaveDraft;
  final VoidCallback onEdit;

  const _ContinueEditingOverlay({
    required this.imagePath,
    required this.onDismiss,
    required this.onSaveDraft,
    required this.onEdit,
  });

  @override
  State<_ContinueEditingOverlay> createState() =>
      _ContinueEditingOverlayState();
}

class _ContinueEditingOverlayState extends State<_ContinueEditingOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _slideAnimation;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.forward();

    // Auto-dismiss after 10 seconds
    Future.delayed(const Duration(seconds: 10), () {
      if (mounted) _dismiss();
    });
  }

  Future<void> _dismiss() async {
    await _controller.reverse();
    widget.onDismiss();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: GestureDetector(
            onVerticalDragEnd: (details) {
              if (details.primaryVelocity != null &&
                  details.primaryVelocity! < -200) {
                _dismiss();
              }
            },
            child: Material(
              color: Colors.transparent,
              child: Container(
                height: context.height * 0.12,
                width: context.width,
                margin: EdgeInsets.only(
                  top: context.height * 0.065,
                  left: context.width * 0.04,
                  right: context.width * 0.04,
                ),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: context.colors.secondary,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.25),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  spacing: context.width * 0.04,
                  children: [
                    if (widget.imagePath != null)
                      SizedBox(
                        height: double.infinity,
                        width: context.width * .2,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.file(
                            File(widget.imagePath!),
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) =>
                                _imagePlaceholder(context),
                          ),
                        ),
                      )
                    else
                      _imagePlaceholder(context),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        spacing: context.height * 0.015,
                        children: [
                          // Title
                          Expanded(
                            child: TextComponent(
                              text: AppStrings.CONTINUE_EDITING_TITLE,
                              weight: FontWeight.w600,
                              size: FontSizeConstants.LARGE,
                              color: context.colors.onPrimary,
                            ),
                          ),

                          // Buttons row — full width
                          Row(
                            spacing: context.width * 0.03,
                            children: [
                              // Save Draft
                              Expanded(
                                child: SizedBox(
                                  height: context.height * .045,
                                  child: ElevatedButton(
                                    onPressed: widget.onSaveDraft,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: context.colors.tertiary
                                          .withOpacity(.15),
                                      foregroundColor:
                                          context.colors.onTertiary,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      textStyle: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    child: TextComponent(
                                      text: AppStrings.CREATE_POST_DRAFT,
                                      color: context.colors.primary,
                                      size: FontSizeConstants.NORMAL,
                                    ),
                                  ),
                                ),
                              ),
                              // Edit
                              Expanded(
                                child: SizedBox(
                                  height: context.height * .045,
                                  child: ElevatedButton(
                                    onPressed: widget.onEdit,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: context.colors.scrim,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      textStyle: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    child: TextComponent(
                                      text: AppStrings.CONTINUE_EDITING_EDIT,
                                      color: context.colors.primary,
                                      size: FontSizeConstants.NORMAL,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _imagePlaceholder(BuildContext context) {
    return Container(
      width: context.width * 0.12,
      height: context.width * 0.12,
      decoration: BoxDecoration(
        color: context.colors.onPrimary.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(
        Icons.image,
        color: context.colors.onPrimary.withValues(alpha: 0.6),
      ),
    );
  }
}
