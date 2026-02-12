import 'dart:io';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:rightflair/core/constants/route.dart';
import 'package:rightflair/core/constants/string.dart';
import 'package:rightflair/core/extensions/context.dart';
import '../cubit/create_post_cubit.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> with WidgetsBindingObserver {
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  bool _isInitialized = false;
  String? _capturedImagePath;
  bool _isFlashOn = false;
  Uint8List? _latestGalleryImage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeCamera();
    _loadLatestGalleryImage();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = _controller;

    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initializeCamera();
    }
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras == null || _cameras!.isEmpty) return;

      _controller = CameraController(
        _cameras![0],
        ResolutionPreset.high,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );

      await _controller!.initialize();
      await _controller!.setFlashMode(FlashMode.off);

      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
    } catch (e) {
      debugPrint('Camera initialization error: $e');
    }
  }

  Future<void> _loadLatestGalleryImage() async {
    try {
      final PermissionState ps = await PhotoManager.requestPermissionExtend();
      if (!ps.isAuth) return;

      final List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
        type: RequestType.image,
        onlyAll: true,
      );

      if (albums.isEmpty) return;

      final List<AssetEntity> recentAssets = await albums[0].getAssetListRange(
        start: 0,
        end: 1,
      );

      if (recentAssets.isEmpty) return;

      final Uint8List? thumbData = await recentAssets[0].thumbnailDataWithSize(
        const ThumbnailSize(200, 200),
      );

      if (mounted && thumbData != null) {
        setState(() {
          _latestGalleryImage = thumbData;
        });
      }
    } catch (e) {
      debugPrint('Error loading gallery image: $e');
    }
  }

  Future<void> _takePicture() async {
    if (_controller == null || !_controller!.value.isInitialized) return;

    try {
      final XFile image = await _controller!.takePicture();
      setState(() {
        _capturedImagePath = image.path;
      });
    } catch (e) {
      debugPrint('Error taking picture: $e');
    }
  }

  Future<void> _pickFromGallery() async {
    await context.read<CreatePostCubit>().pickImageFromGallery();
    if (mounted) {
      final state = context.read<CreatePostCubit>().state;
      if (state.imagePath != null) {
        context.go(RouteConstants.CREATE_POST);
      }
    }
  }

  Future<void> _toggleFlash() async {
    if (_controller == null || !_controller!.value.isInitialized) return;

    try {
      setState(() {
        _isFlashOn = !_isFlashOn;
      });
      await _controller!.setFlashMode(
        _isFlashOn ? FlashMode.torch : FlashMode.off,
      );
    } catch (e) {
      debugPrint('Error toggling flash: $e');
    }
  }

  void _retake() {
    setState(() {
      _capturedImagePath = null;
    });
  }

  Future<void> _continueToPost() async {
    if (_capturedImagePath != null) {
      // Show loading if anonymous mode is enabled
      final isAnonymous = context.read<CreatePostCubit>().state.isAnonymous;
      if (isAnonymous && mounted) {
        // Show a simple loading indicator
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const Center(
            child: CircularProgressIndicator(color: Colors.white),
          ),
        );
      }

      await context.read<CreatePostCubit>().setImagePath(_capturedImagePath!);

      if (isAnonymous && mounted) {
        Navigator.of(context).pop(); // Close loading dialog
      }

      if (mounted) {
        context.go(RouteConstants.CREATE_POST);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }

    if (_capturedImagePath != null) {
      return _buildPreview();
    }

    return _buildCamera();
  }

  Widget _buildCamera() {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Camera Preview
          if (_controller != null && _controller!.value.isInitialized)
            SizedBox.expand(child: CameraPreview(_controller!)),

          // Top Bar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.all(context.width * 0.04),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Close Button
                    IconButton(
                      onPressed: () => context.pop(),
                      icon: Icon(
                        Icons.close,
                        color: Colors.white,
                        size: context.width * 0.08,
                      ),
                    ),
                    // Flash Button
                    IconButton(
                      onPressed: _toggleFlash,
                      icon: Icon(
                        _isFlashOn ? Icons.flash_on : Icons.flash_off,
                        color: Colors.white,
                        size: context.width * 0.08,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Bottom Controls
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.all(context.width * 0.06),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Gallery Button
                    GestureDetector(
                      onTap: _pickFromGallery,
                      child: Container(
                        width: context.width * 0.15,
                        height: context.width * 0.15,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(
                            context.width * 0.03,
                          ),
                          border: Border.all(
                            color: Colors.white,
                            width: context.width * 0.005,
                          ),
                        ),
                        child: _latestGalleryImage != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(
                                  context.width * 0.025,
                                ),
                                child: Image.memory(
                                  _latestGalleryImage!,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                ),
                              )
                            : Icon(
                                Icons.photo_library,
                                color: Colors.white,
                                size: context.width * 0.07,
                              ),
                      ),
                    ),

                    // Capture Button
                    GestureDetector(
                      onTap: _takePicture,
                      child: Container(
                        width: context.width * 0.2,
                        height: context.width * 0.2,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            context.width * 0.04,
                          ),
                          border: Border.all(
                            color: Colors.white,
                            width: context.width * 0.01,
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(context.width * 0.01),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                context.width * 0.025,
                              ),
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(width: context.width * 0.15),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreview() {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Image Preview
          Center(
            child: Image.file(File(_capturedImagePath!), fit: BoxFit.contain),
          ),

          // Top Bar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.all(context.width * 0.04),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Retake Button
                    TextButton(
                      onPressed: _retake,
                      child: Text(
                        AppStrings.CREATE_POST_CAMERA_RETAKE.tr(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: context.width * 0.04,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Bottom Button
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.all(context.width * 0.06),
                child: ElevatedButton(
                  onPressed: _continueToPost,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    padding: EdgeInsets.symmetric(
                      vertical: context.height * 0.02,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(context.width * 0.03),
                    ),
                  ),
                  child: Text(
                    AppStrings.CREATE_POST_CAMERA_CONTINUE.tr(),
                    style: TextStyle(
                      fontSize: context.width * 0.045,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
