import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:camera/camera.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:rightflair/core/constants/route.dart';
import 'package:rightflair/core/constants/string.dart';
import 'package:rightflair/core/constants/color/color.dart';
import '../cubit/create_post_cubit.dart';
import '../widgets/dialog_add_music.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraFilter {
  final String name;
  final List<double>? colorMatrix;

  const _CameraFilter({required this.name, this.colorMatrix});

  static const List<_CameraFilter> filters = [
    _CameraFilter(name: 'Original'),
    _CameraFilter(
      name: 'Warm',
      colorMatrix: [
        1.2,
        0.1,
        0.0,
        0,
        10,
        0.0,
        1.0,
        0.0,
        0,
        0,
        0.0,
        0.0,
        0.8,
        0,
        0,
        0.0,
        0.0,
        0.0,
        1,
        0,
      ],
    ),
    _CameraFilter(
      name: 'Cool',
      colorMatrix: [
        0.8,
        0.0,
        0.0,
        0,
        0,
        0.0,
        1.0,
        0.1,
        0,
        0,
        0.0,
        0.0,
        1.2,
        0,
        10,
        0.0,
        0.0,
        0.0,
        1,
        0,
      ],
    ),
    _CameraFilter(
      name: 'B&W',
      colorMatrix: [
        0.33,
        0.59,
        0.11,
        0,
        0,
        0.33,
        0.59,
        0.11,
        0,
        0,
        0.33,
        0.59,
        0.11,
        0,
        0,
        0.0,
        0.0,
        0.0,
        1,
        0,
      ],
    ),
    _CameraFilter(
      name: 'Sepia',
      colorMatrix: [
        0.39,
        0.77,
        0.19,
        0,
        0,
        0.35,
        0.69,
        0.17,
        0,
        0,
        0.27,
        0.53,
        0.13,
        0,
        0,
        0.0,
        0.0,
        0.0,
        1,
        0,
      ],
    ),
    _CameraFilter(
      name: 'Vivid',
      colorMatrix: [
        1.4,
        -0.1,
        -0.1,
        0,
        0,
        -0.1,
        1.4,
        -0.1,
        0,
        0,
        -0.1,
        -0.1,
        1.4,
        0,
        0,
        0.0,
        0.0,
        0.0,
        1,
        0,
      ],
    ),
    _CameraFilter(
      name: 'Vintage',
      colorMatrix: [
        0.9,
        0.2,
        0.1,
        0,
        15,
        0.1,
        0.8,
        0.1,
        0,
        10,
        0.1,
        0.1,
        0.6,
        0,
        5,
        0.0,
        0.0,
        0.0,
        1,
        0,
      ],
    ),
    _CameraFilter(
      name: 'Fade',
      colorMatrix: [
        1.0,
        0.0,
        0.0,
        0,
        30,
        0.0,
        1.0,
        0.0,
        0,
        30,
        0.0,
        0.0,
        1.0,
        0,
        30,
        0.0,
        0.0,
        0.0,
        1,
        0,
      ],
    ),
  ];
}

class _CameraPageState extends State<CameraPage> with WidgetsBindingObserver {
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  bool _isInitialized = false;
  String? _capturedImagePath;
  bool _isFlashOn = false;
  int _currentCameraIndex = 0;
  int _selectedFilterIndex = 0;
  bool _showFilters = false;
  Uint8List? _latestGalleryImage;
  late final CreatePostCubit _createPostCubit;

  @override
  void initState() {
    super.initState();
    _createPostCubit = context.read<CreatePostCubit>();
    WidgetsBinding.instance.addObserver(this);
    _initializeCamera();
    _loadGalleryImages();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    // Stop music when leaving camera page
    _createPostCubit.stopMusic();
    _createPostCubit.setSelectedMusic(null);
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
        _cameras![_currentCameraIndex],
        ResolutionPreset.high,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );

      await _controller!.initialize();
      await _controller!.setFlashMode(FlashMode.off);

      if (mounted) {
        setState(() => _isInitialized = true);
      }
    } catch (e) {
      debugPrint('Camera initialization error: $e');
    }
  }

  Future<void> _loadGalleryImages() async {
    try {
      final PermissionState ps = await PhotoManager.requestPermissionExtend();
      if (!ps.isAuth) return;

      final List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
        type: RequestType.image,
        onlyAll: true,
      );
      if (albums.isEmpty) return;

      final List<AssetEntity> assets = await albums[0].getAssetListRange(
        start: 0,
        end: 1,
      );
      if (assets.isEmpty) return;

      final Uint8List? thumbData = await assets[0].thumbnailDataWithSize(
        const ThumbnailSize(200, 200),
      );

      if (mounted && thumbData != null) {
        setState(() {
          _latestGalleryImage = thumbData;
        });
      }
    } catch (e) {
      debugPrint('Error loading gallery images: $e');
    }
  }

  Future<void> _flipCamera() async {
    if (_cameras == null || _cameras!.length < 2) return;
    _currentCameraIndex = (_currentCameraIndex + 1) % _cameras!.length;
    await _controller?.dispose();
    setState(() => _isInitialized = false);
    await _initializeCamera();
  }

  Future<void> _takePicture() async {
    if (_controller == null || !_controller!.value.isInitialized) return;

    try {
      final XFile image = await _controller!.takePicture();
      setState(() => _capturedImagePath = image.path);
    } catch (e) {
      debugPrint('Error taking picture: $e');
    }
  }

  Future<void> _pickFromGallery() async {
    try {
      final picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      if (image != null && mounted) {
        setState(() => _capturedImagePath = image.path);
      }
    } catch (e) {
      debugPrint('Error picking from gallery: $e');
    }
  }

  Future<void> _toggleFlash() async {
    if (_controller == null || !_controller!.value.isInitialized) return;

    try {
      setState(() => _isFlashOn = !_isFlashOn);
      await _controller!.setFlashMode(
        _isFlashOn ? FlashMode.torch : FlashMode.off,
      );
    } catch (e) {
      debugPrint('Error toggling flash: $e');
    }
  }

  void _retake() {
    setState(() => _capturedImagePath = null);
  }

  Future<String> _applyFilterToFile(String imagePath) async {
    final filter = _CameraFilter.filters[_selectedFilterIndex];
    if (filter.colorMatrix == null) return imagePath;

    final file = File(imagePath);
    final bytes = await file.readAsBytes();
    final codec = await ui.instantiateImageCodec(bytes);
    final frame = await codec.getNextFrame();
    final originalImage = frame.image;

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final paint = Paint()
      ..colorFilter = ColorFilter.matrix(filter.colorMatrix!);

    canvas.drawImage(originalImage, Offset.zero, paint);

    final picture = recorder.endRecording();
    final rendered = await picture.toImage(
      originalImage.width,
      originalImage.height,
    );
    final pngBytes = await rendered.toByteData(format: ui.ImageByteFormat.png);

    originalImage.dispose();
    rendered.dispose();

    if (pngBytes == null) return imagePath;

    final dir = File(imagePath).parent;
    final filteredFile = File(
      '${dir.path}/filtered_${DateTime.now().millisecondsSinceEpoch}.png',
    );
    await filteredFile.writeAsBytes(pngBytes.buffer.asUint8List());
    return filteredFile.path;
  }

  Future<void> _continueToPost() async {
    if (_capturedImagePath != null) {
      final isAnonymous = context.read<CreatePostCubit>().state.isAnonymous;
      if (isAnonymous && mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const Center(
            child: CircularProgressIndicator(color: Colors.white),
          ),
        );
      }

      // Apply filter to the actual image file
      final filteredPath = await _applyFilterToFile(_capturedImagePath!);
      await context.read<CreatePostCubit>().setImagePath(filteredPath);

      if (isAnonymous && mounted) {
        Navigator.of(context).pop();
      }

      if (mounted) {
        context.go(RouteConstants.CREATE_POST);
      }
    }
  }

  void _showAddMusicDialog() async {
    final music = await showModalBottomSheet<dynamic>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AddMusicBottomSheet(),
    );
    if (music != null && mounted) {
      context.read<CreatePostCubit>().setSelectedMusic(music);
      context.read<CreatePostCubit>().playMusic();
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

  // ======================== CAMERA MODE ========================

  Widget _buildCamera() {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Camera Preview
          if (_controller != null && _controller!.value.isInitialized)
            Positioned.fill(
              child: _applyFilter(
                ClipRect(
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: _controller!.value.previewSize!.height,
                      height: _controller!.value.previewSize!.width,
                      child: CameraPreview(_controller!),
                    ),
                  ),
                ),
              ),
            ),

          // Top Bar
          _buildCameraTopBar(),

          // Right Side Toolbar
          _buildCameraRightToolbar(),

          // Bottom Section
          _buildCameraBottom(),
        ],
      ),
    );
  }

  Widget _buildCameraTopBar() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              // Close Button
              _circleIconButton(
                Icons.close,
                onTap: () {
                  _createPostCubit.stopMusic();
                  _createPostCubit.setSelectedMusic(null);
                  context.pop();
                },
              ),
              const Spacer(),
              // Add Sound Pill
              _addSoundPill(),
              const Spacer(),
              // Flip Camera
              _circleIconButton(
                Icons.cameraswitch_outlined,
                onTap: _flipCamera,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCameraRightToolbar() {
    return Positioned(
      right: 14,
      top: 0,
      bottom: 0,
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _sideToolbarIcon(
              _isFlashOn ? Icons.flash_on : Icons.flash_off,
              onTap: _toggleFlash,
            ),
            const SizedBox(height: 22),
            _sideToolbarIcon(
              Icons.auto_awesome,
              onTap: _toggleFilterVisibility,
              hasBadge: _showFilters,
            ),
          ],
        ),
      ),
    );
  }

  void _toggleFilterVisibility() {
    setState(() {
      if (_showFilters) {
        // Closing filters -> reset to Original
        _showFilters = false;
        _selectedFilterIndex = 0;
      } else {
        _showFilters = true;
      }
    });
  }

  Widget _buildCameraBottom() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [Colors.black.withOpacity(0.7), Colors.transparent],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              // Capture Button
              _buildCaptureButton(),
              const SizedBox(height: 6),
              // Selected filter name (only when filters visible)
              if (_showFilters)
                Text(
                  _CameraFilter.filters[_selectedFilterIndex].name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              if (_showFilters) const SizedBox(height: 14),
              // Filter List (only when filters visible)
              if (_showFilters) _buildFilterList(),
              if (_showFilters) const SizedBox(height: 16),
              if (!_showFilters) const SizedBox(height: 16),
              // Gallery picker
              _buildBottomGalleryPicker(),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterList() {
    final filters = _CameraFilter.filters;
    return SizedBox(
      height: 64,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = index == _selectedFilterIndex;
          return GestureDetector(
            onTap: () => setState(() => _selectedFilterIndex = index),
            child: Container(
              width: 52,
              margin: const EdgeInsets.symmetric(horizontal: 6),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected ? Colors.white : Colors.white30,
                        width: isSelected ? 2.5 : 1.5,
                      ),
                    ),
                    child: ClipOval(
                      child: ColorFiltered(
                        colorFilter: filter.colorMatrix != null
                            ? ColorFilter.matrix(filter.colorMatrix!)
                            : const ColorFilter.mode(
                                Colors.transparent,
                                BlendMode.multiply,
                              ),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.pink.shade200,
                                Colors.orange.shade200,
                                Colors.blue.shade200,
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    filter.name,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.white54,
                      fontSize: 9,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w400,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCaptureButton() {
    return GestureDetector(
      onTap: _takePicture,
      child: Container(
        width: 78,
        height: 78,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 4),
        ),
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomGalleryPicker() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          // Gallery Thumbnail (left corner)
          GestureDetector(
            onTap: _pickFromGallery,
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.white.withOpacity(0.5),
                  width: 1.5,
                ),
              ),
              child: _latestGalleryImage != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.memory(
                        _latestGalleryImage!,
                        fit: BoxFit.cover,
                      ),
                    )
                  : const Icon(
                      Icons.photo_library,
                      color: Colors.white,
                      size: 22,
                    ),
            ),
          ),
          const Spacer(),
          // PHOTO label
          Text(
            AppStrings.PROFILE_EDIT_STORY_PHOTO.tr(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const Spacer(),
          // Balance spacer
          const SizedBox(width: 44),
        ],
      ),
    );
  }

  // ======================== PREVIEW MODE ========================

  Widget _buildPreview() {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Image Preview
          Center(
            child: _applyFilter(
              Image.file(File(_capturedImagePath!), fit: BoxFit.contain),
            ),
          ),

          // Top Bar
          _buildPreviewTopBar(),

          // Right Side Toolbar
          _buildPreviewRightToolbar(),

          // Bottom Section
          _buildPreviewBottom(),
        ],
      ),
    );
  }

  Widget _buildPreviewTopBar() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              // Back Button
              _circleIconButton(Icons.arrow_back_ios_new, onTap: _retake),
              const Spacer(),
              // Add Sound Pill
              _addSoundPill(),
              const Spacer(),
              // Settings placeholder
              const SizedBox(width: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPreviewRightToolbar() {
    return Positioned(
      right: 14,
      top: 0,
      bottom: 0,
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _sideToolbarIcon(Icons.text_fields),
            const SizedBox(height: 22),
            _sideToolbarIcon(Icons.brush_outlined),
            const SizedBox(height: 22),
            _sideToolbarIcon(
              Icons.auto_awesome,
              onTap: _toggleFilterVisibility,
              hasBadge: _showFilters,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreviewBottom() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [Colors.black.withOpacity(0.8), Colors.transparent],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Filter section (when visible)
                if (_showFilters) ...[
                  Text(
                    _CameraFilter.filters[_selectedFilterIndex].name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildFilterList(),
                  const SizedBox(height: 16),
                ],
                Row(
                  children: [
                    // Retake Button
                    Expanded(
                      child: GestureDetector(
                        onTap: _retake,
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(color: Colors.white, width: 1.5),
                          ),
                          child: Center(
                            child: Text(
                              AppStrings.CREATE_POST_CAMERA_RETAKE.tr(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Continue / Next Button
                    Expanded(
                      child: GestureDetector(
                        onTap: _continueToPost,
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            gradient: LinearGradient(
                              colors: [AppColors.ORANGE, AppColors.YELLOW],
                            ),
                          ),
                          child: Center(
                            child: Text(
                              AppStrings.CREATE_POST_CAMERA_CONTINUE.tr(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ======================== SHARED WIDGETS ========================

  Widget _applyFilter(Widget child) {
    final filter = _CameraFilter.filters[_selectedFilterIndex];
    if (filter.colorMatrix == null) return child;
    return ColorFiltered(
      colorFilter: ColorFilter.matrix(filter.colorMatrix!),
      child: child,
    );
  }

  void _removeMusic() {
    _createPostCubit.stopMusic();
    _createPostCubit.setSelectedMusic(null);
  }

  Widget _addSoundPill() {
    return BlocBuilder<CreatePostCubit, CreatePostState>(
      buildWhen: (prev, curr) => prev.selectedMusic != curr.selectedMusic,
      builder: (context, state) {
        final music = state.selectedMusic;
        final hasMusic = music != null && music.title != null;
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: _showAddMusicDialog,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                constraints: const BoxConstraints(maxWidth: 200),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.music_note, color: Colors.white, size: 16),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        hasMusic
                            ? '${music.artist ?? ''} - ${music.title ?? ''}'
                            : AppStrings.CREATE_POST_ADD_MUSIC.tr(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (hasMusic) ...[
              const SizedBox(width: 6),
              GestureDetector(
                onTap: _removeMusic,
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.2),
                  ),
                  child: const Icon(Icons.close, color: Colors.white, size: 16),
                ),
              ),
            ],
          ],
        );
      },
    );
  }

  Widget _circleIconButton(IconData icon, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black.withOpacity(0.3),
        ),
        child: Icon(icon, color: Colors.white, size: 24),
      ),
    );
  }

  Widget _sideToolbarIcon(
    IconData icon, {
    VoidCallback? onTap,
    bool hasBadge = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Icon(icon, color: Colors.white, size: 28),
          if (hasBadge)
            Positioned(
              right: -4,
              bottom: -4,
              child: Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: Colors.redAccent,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.black, width: 1),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
