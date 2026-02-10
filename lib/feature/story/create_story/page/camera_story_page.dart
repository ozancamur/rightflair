import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:rightflair/core/extensions/context.dart';

import '../../../../core/components/text/text.dart';
import '../../../../core/constants/font/font_size.dart';
import '../../../../core/constants/string.dart';
import 'edit_story_media_page.dart';
import 'gallery_picker_page.dart';

class CameraStoryPage extends StatefulWidget {
  final String uid;

  const CameraStoryPage({super.key, required this.uid});

  @override
  State<CameraStoryPage> createState() => _CameraStoryPageState();
}

class _CameraStoryPageState extends State<CameraStoryPage>
    with WidgetsBindingObserver {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  int _selectedCameraIndex = 0;
  bool _isRecording = false;
  bool _isVideoMode = false;
  Timer? _recordingTimer;
  int _recordingSeconds = 0;
  File? _lastGalleryImage;
  bool _isInitializing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeCamera();
    _loadLastGalleryImage();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cameraController?.dispose();
    _recordingTimer?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = _cameraController;

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
    if (_isInitializing) return;
    _isInitializing = true;

    try {
      _cameras = await availableCameras();
      if (_cameras == null || _cameras!.isEmpty) {
        debugPrint('No cameras available');
        _isInitializing = false;
        return;
      }

      await _setupCamera(_selectedCameraIndex);
    } catch (e) {
      debugPrint('Error initializing camera: $e');
    }
    _isInitializing = false;
  }

  Future<void> _setupCamera(int cameraIndex) async {
    if (_cameras == null || _cameras!.isEmpty) return;

    await _cameraController?.dispose();

    final camera = _cameras![cameraIndex];
    _cameraController = CameraController(
      camera,
      ResolutionPreset.high,
      enableAudio: true,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    try {
      await _cameraController!.initialize();
      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      debugPrint('Error setting up camera: $e');
    }
  }

  Future<void> _loadLastGalleryImage() async {
    try {
      final PermissionState ps = await PhotoManager.requestPermissionExtend();
      if (!ps.isAuth) {
        debugPrint('Permission denied for gallery access');
        return;
      }

      final List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
        type: RequestType.image,
        onlyAll: true,
      );

      if (albums.isEmpty) return;

      final List<AssetEntity> recentAssets = await albums.first
          .getAssetListRange(start: 0, end: 1);

      if (recentAssets.isEmpty) return;

      final File? file = await recentAssets.first.file;
      if (file != null && mounted) {
        setState(() {
          _lastGalleryImage = file;
        });
      }
    } catch (e) {
      debugPrint('Error loading last gallery image: $e');
    }
  }

  Future<void> _switchCamera() async {
    if (_cameras == null || _cameras!.length < 2) return;

    _selectedCameraIndex = (_selectedCameraIndex + 1) % _cameras!.length;
    await _setupCamera(_selectedCameraIndex);
  }

  Future<void> _takePicture() async {
    if (_cameraController == null ||
        !_cameraController!.value.isInitialized ||
        _isRecording) {
      return;
    }

    try {
      final XFile photo = await _cameraController!.takePicture();
      if (mounted) {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EditStoryMediaPage(
              mediaFile: File(photo.path),
              isVideo: false,
              uid: widget.uid,
            ),
          ),
        );
        // Kamera sayfasına döndüğümüzde refresh
        _loadLastGalleryImage();
      }
    } catch (e) {
      debugPrint('Error taking picture: $e');
    }
  }

  Future<void> _startVideoRecording() async {
    if (_cameraController == null ||
        !_cameraController!.value.isInitialized ||
        _isRecording) {
      return;
    }

    setState(() {
      _isRecording = true;
      _recordingSeconds = 0;
    });

    try {
      await _cameraController!.startVideoRecording();

      _recordingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          _recordingSeconds++;
        });

        // 60 saniye limiti
        if (_recordingSeconds >= 60) {
          _stopVideoRecording();
        }
      });
    } catch (e) {
      debugPrint('Error starting video recording: $e');
      setState(() {
        _isRecording = false;
        _recordingSeconds = 0;
      });
    }
  }

  Future<void> _stopVideoRecording() async {
    if (_cameraController == null || !_isRecording) return;

    try {
      final XFile video = await _cameraController!.stopVideoRecording();
      _recordingTimer?.cancel();
      setState(() {
        _isRecording = false;
        _recordingSeconds = 0;
      });

      if (mounted) {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EditStoryMediaPage(
              mediaFile: File(video.path),
              isVideo: true,
              uid: widget.uid,
            ),
          ),
        );
      }
    } catch (e) {
      debugPrint('Error stopping video recording: $e');
    }
  }

  Future<void> _openGallery() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GalleryPickerPage(uid: widget.uid),
      ),
    );
    // Galeriden döndüğümüzde son resmi refresh et
    _loadLastGalleryImage();
  }

  String _formatRecordingTime() {
    final minutes = _recordingSeconds ~/ 60;
    final seconds = _recordingSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return Scaffold(
        backgroundColor: context.colors.surface,
        body: Center(
          child: CircularProgressIndicator(color: context.colors.primary),
        ),
      );
    }

    return Scaffold(
      backgroundColor: context.colors.surface,
      body: Stack(
        children: [
          // Kamera Preview
          SizedBox.expand(child: CameraPreview(_cameraController!)),

          // Üst Bar
          SafeArea(
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: context.width * 0.04,
                vertical: context.height * 0.02,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Close Button
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      Icons.close,
                      color: Colors.white,
                      size: context.width * 0.075,
                    ),
                  ),

                  // Flash Button
                  IconButton(
                    onPressed: () async {
                      if (_cameraController != null) {
                        final flashMode = _cameraController!.value.flashMode;
                        await _cameraController!.setFlashMode(
                          flashMode == FlashMode.off
                              ? FlashMode.torch
                              : FlashMode.off,
                        );
                        setState(() {});
                      }
                    },
                    icon: Icon(
                      _cameraController?.value.flashMode == FlashMode.torch
                          ? Icons.flash_on
                          : Icons.flash_off,
                      color: Colors.white,
                      size: context.width * 0.075,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Recording Timer
          if (_isRecording)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SafeArea(
                child: Center(
                  child: Container(
                    margin: EdgeInsets.only(top: context.height * 0.02),
                    padding: EdgeInsets.symmetric(
                      horizontal: context.width * 0.04,
                      vertical: context.height * 0.01,
                    ),
                    decoration: BoxDecoration(
                      color: context.colors.error,
                      borderRadius: BorderRadius.circular(context.width * 0.05),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: context.width * 0.02,
                          height: context.width * 0.02,
                          decoration: BoxDecoration(
                            color: context.colors.onError,
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: context.width * 0.02),
                        TextComponent(
                          text: _formatRecordingTime(),
                          color: context.colors.onError,
                          size: FontSizeConstants.NORMAL,
                          weight: FontWeight.bold,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

          // Alt Kontroller
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.only(
                bottom: context.height * 0.05,
                top: context.height * 0.02,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    context.colors.surface.withOpacity(0.7),
                    Colors.transparent,
                  ],
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Mod Seçici (Photo/Video)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () => setState(() => _isVideoMode = false),
                        child: TextComponent(
                          text: AppStrings.PROFILE_EDIT_STORY_PHOTO.tr(),
                          color: !_isVideoMode
                              ? context.colors.surface
                              : Colors.white.withOpacity(0.5),
                          size: FontSizeConstants.NORMAL,
                          weight: !_isVideoMode
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                      SizedBox(width: context.width * 0.1),
                      GestureDetector(
                        onTap: () => setState(() => _isVideoMode = true),
                        child: TextComponent(
                          text: AppStrings.PROFILE_EDIT_STORY_VIDEO.tr(),
                          color: _isVideoMode
                              ? context.colors.surface
                              : Colors.white.withOpacity(0.5),
                          size: FontSizeConstants.NORMAL,
                          weight: _isVideoMode
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: context.height * 0.03),

                  // Kontrol Butonları
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Galeri Butonu
                      GestureDetector(
                        onTap: _openGallery,
                        child: Container(
                          width: context.width * 0.125,
                          height: context.width * 0.125,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(
                              context.width * 0.02,
                            ),
                            border: Border.all(
                              color: Colors.white,
                              width: context.width * 0.005,
                            ),
                          ),
                          child: _lastGalleryImage != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                    context.width * 0.015,
                                  ),
                                  child: Image.file(
                                    _lastGalleryImage!,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : Icon(
                                  Icons.photo_library,
                                  color: Colors.white,
                                  size: context.width * 0.06,
                                ),
                        ),
                      ),

                      // Çekim Butonu
                      GestureDetector(
                        onTap: () {
                          if (_isVideoMode) {
                            if (_isRecording) {
                              _stopVideoRecording();
                            } else {
                              _startVideoRecording();
                            }
                          } else {
                            _takePicture();
                          }
                        },
                        child: Container(
                          width: context.width * 0.175,
                          height: context.width * 0.175,
                          decoration: BoxDecoration(
                            shape: _isVideoMode
                                ? BoxShape.circle
                                : BoxShape.rectangle,
                            borderRadius: !_isVideoMode
                                ? BorderRadius.circular(context.width * 0.03)
                                : null,
                            border: Border.all(
                              color: Colors.white,
                              width: context.width * 0.01,
                            ),
                          ),
                          child: Center(
                            child: Container(
                              width: context.width * 0.14,
                              height: context.width * 0.14,
                              decoration: BoxDecoration(
                                color: _isRecording
                                    ? context.colors.error
                                    : Colors.white,
                                shape: _isVideoMode
                                    ? BoxShape.circle
                                    : BoxShape.rectangle,
                                borderRadius: !_isVideoMode
                                    ? BorderRadius.circular(
                                        context.width * 0.02,
                                      )
                                    : null,
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Kamera Değiştirme Butonu
                      IconButton(
                        onPressed: _switchCamera,
                        icon: Icon(
                          Icons.flip_camera_ios,
                          color: Colors.white,
                          size: context.width * 0.09,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
