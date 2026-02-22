import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:camera/camera.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../../../core/constants/color/color.dart';
import '../../../../core/constants/string.dart';
import 'edit_story_media_page.dart';
import 'gallery_picker_page.dart';

/// Story camera filter
class _StoryFilter {
  final String name;
  final List<double>? colorMatrix;

  const _StoryFilter({required this.name, this.colorMatrix});

  static const List<_StoryFilter> filters = [
    _StoryFilter(name: 'Original'),
    _StoryFilter(
      name: 'Warm',
      colorMatrix: [
        1.2, 0.1, 0.0, 0, 10,
        0.0, 1.0, 0.0, 0, 0,
        0.0, 0.0, 0.8, 0, 0,
        0.0, 0.0, 0.0, 1, 0,
      ],
    ),
    _StoryFilter(
      name: 'Cool',
      colorMatrix: [
        0.8, 0.0, 0.0, 0, 0,
        0.0, 1.0, 0.1, 0, 0,
        0.0, 0.0, 1.2, 0, 10,
        0.0, 0.0, 0.0, 1, 0,
      ],
    ),
    _StoryFilter(
      name: 'B&W',
      colorMatrix: [
        0.33, 0.59, 0.11, 0, 0,
        0.33, 0.59, 0.11, 0, 0,
        0.33, 0.59, 0.11, 0, 0,
        0.0,  0.0,  0.0,  1, 0,
      ],
    ),
    _StoryFilter(
      name: 'Sepia',
      colorMatrix: [
        0.39, 0.77, 0.19, 0, 0,
        0.35, 0.69, 0.17, 0, 0,
        0.27, 0.53, 0.13, 0, 0,
        0.0,  0.0,  0.0,  1, 0,
      ],
    ),
    _StoryFilter(
      name: 'Vivid',
      colorMatrix: [
        1.4,  -0.1, -0.1, 0, 0,
        -0.1, 1.4,  -0.1, 0, 0,
        -0.1, -0.1, 1.4,  0, 0,
        0.0,  0.0,  0.0,  1, 0,
      ],
    ),
    _StoryFilter(
      name: 'Vintage',
      colorMatrix: [
        0.9, 0.2, 0.1, 0, 15,
        0.1, 0.8, 0.1, 0, 10,
        0.1, 0.1, 0.6, 0, 5,
        0.0, 0.0, 0.0, 1, 0,
      ],
    ),
    _StoryFilter(
      name: 'Fade',
      colorMatrix: [
        1.0, 0.0, 0.0, 0, 30,
        0.0, 1.0, 0.0, 0, 30,
        0.0, 0.0, 1.0, 0, 30,
        0.0, 0.0, 0.0, 1, 0,
      ],
    ),
  ];
}

/// Story camera modes
enum _StoryCameraMode { photo, video }

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
  _StoryCameraMode _cameraMode = _StoryCameraMode.photo;
  Timer? _recordingTimer;
  int _recordingSeconds = 0;
  int _maxRecordingSeconds = 60;
  Uint8List? _lastGalleryThumb;
  bool _isInitializing = false;
  bool _isFlashOn = false;
  int _selectedFilterIndex = 0;
  bool _showFilters = false;

  bool get _isVideoMode => _cameraMode == _StoryCameraMode.video;

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

  // ======================== CAMERA SETUP ========================

  Future<void> _initializeCamera() async {
    if (_isInitializing) return;
    _isInitializing = true;
    try {
      _cameras = await availableCameras();
      if (_cameras == null || _cameras!.isEmpty) {
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
      await _cameraController!.setFlashMode(FlashMode.off);
      if (mounted) setState(() {});
    } catch (e) {
      debugPrint('Error setting up camera: $e');
    }
  }

  Future<void> _loadLastGalleryImage() async {
    try {
      final PermissionState ps = await PhotoManager.requestPermissionExtend();
      if (!ps.isAuth) return;
      final List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
        type: RequestType.image,
        onlyAll: true,
      );
      if (albums.isEmpty) return;
      final List<AssetEntity> recentAssets =
          await albums.first.getAssetListRange(start: 0, end: 1);
      if (recentAssets.isEmpty) return;
      final Uint8List? thumbData = await recentAssets.first
          .thumbnailDataWithSize(const ThumbnailSize(200, 200));
      if (thumbData != null && mounted) {
        setState(() => _lastGalleryThumb = thumbData);
      }
    } catch (e) {
      debugPrint('Error loading last gallery image: $e');
    }
  }

  // ======================== CAMERA ACTIONS ========================

  Future<void> _switchCamera() async {
    if (_cameras == null || _cameras!.length < 2) return;
    _selectedCameraIndex = (_selectedCameraIndex + 1) % _cameras!.length;
    await _setupCamera(_selectedCameraIndex);
  }

  Future<void> _toggleFlash() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }
    try {
      setState(() => _isFlashOn = !_isFlashOn);
      await _cameraController!.setFlashMode(
        _isFlashOn ? FlashMode.torch : FlashMode.off,
      );
    } catch (e) {
      debugPrint('Error toggling flash: $e');
    }
  }

  Future<void> _takePicture() async {
    if (_cameraController == null ||
        !_cameraController!.value.isInitialized ||
        _isRecording) {
      return;
    }
    try {
      final XFile photo = await _cameraController!.takePicture();
      final filteredPath = await _applyFilterToFile(photo.path);
      if (mounted) {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EditStoryMediaPage(
              mediaFile: File(filteredPath),
              isVideo: false,
              uid: widget.uid,
            ),
          ),
        );
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

    // Set max duration based on mode
    _maxRecordingSeconds = 60;

    setState(() {
      _isRecording = true;
      _recordingSeconds = 0;
    });
    try {
      await _cameraController!.startVideoRecording();
      _recordingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() => _recordingSeconds++);
        if (_recordingSeconds >= _maxRecordingSeconds) {
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
        final filter = _StoryFilter.filters[_selectedFilterIndex];
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EditStoryMediaPage(
              mediaFile: File(video.path),
              isVideo: true,
              uid: widget.uid,
              colorMatrix: filter.colorMatrix,
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
    _loadLastGalleryImage();
  }

  String _formatRecordingTime() {
    final minutes = _recordingSeconds ~/ 60;
    final seconds = _recordingSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  void _onCapturePressed() {
    if (_isVideoMode) {
      if (_isRecording) {
        _stopVideoRecording();
      } else {
        _startVideoRecording();
      }
    } else if (_cameraMode == _StoryCameraMode.photo) {
      _takePicture();
    }
  }

  // ======================== FILTER ========================

  void _toggleFilterVisibility() {
    setState(() {
      if (_showFilters) {
        _showFilters = false;
        _selectedFilterIndex = 0;
      } else {
        _showFilters = true;
      }
    });
  }

  Widget _applyFilter(Widget child) {
    final filter = _StoryFilter.filters[_selectedFilterIndex];
    if (filter.colorMatrix == null) return child;
    return ColorFiltered(
      colorFilter: ColorFilter.matrix(filter.colorMatrix!),
      child: child,
    );
  }

  Future<String> _applyFilterToFile(String imagePath) async {
    final filter = _StoryFilter.filters[_selectedFilterIndex];
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

  // ======================== BUILD ========================

  @override
  Widget build(BuildContext context) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Camera Preview — full screen
          Positioned.fill(
            child: _applyFilter(
              ClipRect(
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: _cameraController!.value.previewSize!.height,
                    height: _cameraController!.value.previewSize!.width,
                    child: CameraPreview(_cameraController!),
                  ),
                ),
              ),
            ),
          ),

          // Top Bar
          _buildTopBar(),

          // Right Side Toolbar
          _buildRightToolbar(),

          // Recording Timer
          if (_isRecording) _buildRecordingTimer(),

          // Bottom Section
          _buildBottom(),
        ],
      ),
    );
  }

  // ======================== TOP BAR ========================

  Widget _buildTopBar() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              // Close
              _circleIconButton(Icons.close, onTap: () => Navigator.pop(context)),
              const Spacer(),
              // Flip Camera
              _circleIconButton(Icons.cameraswitch_outlined,
                  onTap: _switchCamera),
            ],
          ),
        ),
      ),
    );
  }

  // ======================== RIGHT TOOLBAR ========================

  Widget _buildRightToolbar() {
    return Positioned(
      right: 14,
      top: 0,
      bottom: 0,
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Flash
            _sideToolbarIcon(
              _isFlashOn ? Icons.flash_on : Icons.flash_off,
              onTap: _toggleFlash,
            ),
            const SizedBox(height: 22),
            // Effects / Filters
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

  // ======================== RECORDING TIMER ========================

  Widget _buildRecordingTimer() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        child: Center(
          child: Container(
            margin: const EdgeInsets.only(top: 16),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.ORANGE,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  _formatRecordingTime(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ======================== BOTTOM SECTION ========================

  Widget _buildBottom() {
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
              const SizedBox(height: 8),
              // Capture button row
              _buildCaptureRow(),
              const SizedBox(height: 6),
              // Filter name
              if (_showFilters)
                Text(
                  _StoryFilter.filters[_selectedFilterIndex].name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              if (_showFilters) const SizedBox(height: 14),
              // Filter list
              if (_showFilters) _buildFilterList(),
              if (_showFilters) const SizedBox(height: 16),
              if (!_showFilters) const SizedBox(height: 16),
              // Bottom gallery row
              _buildBottomGalleryRow(),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  // Capture button centered
  Widget _buildCaptureRow() {
    return Center(
      child: GestureDetector(
        onTap: _onCapturePressed,
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
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _isRecording ? AppColors.ORANGE : Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Bottom row: Gallery thumb (left) + PHOTO / VIDEO tabs (center)
  Widget _buildBottomGalleryRow() {
    final isPhoto = _cameraMode == _StoryCameraMode.photo;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          // Gallery Thumbnail
          GestureDetector(
            onTap: _openGallery,
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
              child: _lastGalleryThumb != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child:
                          Image.memory(_lastGalleryThumb!, fit: BoxFit.cover),
                    )
                  : const Icon(Icons.photo_library,
                      color: Colors.white, size: 22),
            ),
          ),
          const Spacer(),
          // PHOTO tab
          GestureDetector(
            onTap: () =>
                setState(() => _cameraMode = _StoryCameraMode.photo),
            child: _bottomTabLabel(
              AppStrings.PROFILE_EDIT_STORY_PHOTO.tr(),
              isSelected: isPhoto,
            ),
          ),
          const SizedBox(width: 24),
          // VIDEO tab
          GestureDetector(
            onTap: () =>
                setState(() => _cameraMode = _StoryCameraMode.video),
            child: _bottomTabLabel(
              AppStrings.PROFILE_EDIT_STORY_VIDEO.tr(),
              isSelected: !isPhoto,
            ),
          ),
          const Spacer(),
          // Balance spacer
          const SizedBox(width: 44),
        ],
      ),
    );
  }

  Widget _bottomTabLabel(String label, {bool isSelected = false}) {
    return Text(
      label,
      style: TextStyle(
        color: isSelected ? Colors.white : Colors.white54,
        fontSize: 15,
        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
      ),
    );
  }

  // ======================== SHARED WIDGETS ========================

  Widget _buildFilterList() {
    final filters = _StoryFilter.filters;
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
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w400,
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
                  color: AppColors.ORANGE,
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
