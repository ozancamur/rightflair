import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../../../core/base/page/base_scaffold.dart';
import '../../../../core/components/text/text.dart';
import '../../../../core/constants/color/color.dart';
import '../../../../core/extensions/context.dart';
import '../model/story_filter.dart';
import '../widgets/story_bottom_gallery_row.dart';
import '../widgets/story_capture_button.dart';
import '../widgets/story_circle_icon_button.dart';
import '../widgets/story_filter_list.dart';
import '../widgets/story_recording_timer.dart';
import '../widgets/story_side_toolbar_icon.dart';
import 'edit_story_media_page.dart';

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
      await _cameraController!.lockCaptureOrientation(
        DeviceOrientation.portraitUp,
      );
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
      final List<AssetEntity> recentAssets = await albums.first
          .getAssetListRange(start: 0, end: 1);
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
        final filter = StoryFilter.filters[_selectedFilterIndex];
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
    try {
      final picker = ImagePicker();
      if (_isVideoMode) {
        final video = await picker.pickVideo(source: ImageSource.gallery);
        if (video != null && mounted) {
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
          _loadLastGalleryImage();
        }
      } else {
        final image = await picker.pickImage(
          source: ImageSource.gallery,
          imageQuality: 85,
        );
        if (image != null && mounted) {
          final filteredPath = await _applyFilterToFile(image.path);
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
      }
    } catch (e) {
      debugPrint('Error picking from gallery: $e');
    }
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
    final filter = StoryFilter.filters[_selectedFilterIndex];
    if (filter.colorMatrix == null) return child;
    return ColorFiltered(
      colorFilter: ColorFilter.matrix(filter.colorMatrix!),
      child: child,
    );
  }

  Future<String> _applyFilterToFile(String imagePath) async {
    final filter = StoryFilter.filters[_selectedFilterIndex];
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
      return BaseScaffold(
        body: Center(
          child: CircularProgressIndicator(color: context.colors.onSurface),
        ),
      );
    }

    return BaseScaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: GestureDetector(
              onDoubleTap: _switchCamera,
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
          ),
          _buildTopBar(),
          _buildRightToolbar(),
          if (_isRecording) _buildRecordingTimer(),
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
          padding: EdgeInsets.symmetric(
            horizontal: context.width * .04,
            vertical: context.height * .01,
          ),
          child: Row(
            children: [
              StoryCircleIconButton(
                icon: Icons.close,
                onTap: () => Navigator.pop(context),
              ),
              const Spacer(),
              StoryCircleIconButton(
                icon: Icons.cameraswitch_outlined,
                onTap: _switchCamera,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ======================== RIGHT TOOLBAR ========================

  Widget _buildRightToolbar() {
    return Positioned(
      right: context.width * .035,
      top: 0,
      bottom: 0,
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            StorySideToolbarIcon(
              icon: _isFlashOn ? Icons.flash_on : Icons.flash_off,
              onTap: _toggleFlash,
            ),
            SizedBox(height: context.height * .026),
            StorySideToolbarIcon(
              icon: Icons.auto_awesome,
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
          child: StoryRecordingTimer(formattedTime: _formatRecordingTime()),
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
            colors: [AppColors.BLACK_70, AppColors.TRANSPARENT],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: context.height * .01),
              StoryCaptureButton(
                onTap: _onCapturePressed,
                isRecording: _isRecording,
              ),
              SizedBox(height: context.height * .007),
              if (_showFilters) ...[
                TextComponent(
                  text: StoryFilter.filters[_selectedFilterIndex].name,
                  tr: false,
                  size: const [12],
                  color: AppColors.WHITE,
                  weight: FontWeight.w600,
                ),
                SizedBox(height: context.height * .017),
                StoryFilterList(
                  selectedFilterIndex: _selectedFilterIndex,
                  onFilterSelected: (i) =>
                      setState(() => _selectedFilterIndex = i),
                ),
              ],
              SizedBox(height: context.height * .019),
              StoryBottomGalleryRow(
                onGalleryTap: _openGallery,
                galleryThumb: _lastGalleryThumb,
                isPhotoMode: _cameraMode == _StoryCameraMode.photo,
                onPhotoTap: () =>
                    setState(() => _cameraMode = _StoryCameraMode.photo),
                onVideoTap: () =>
                    setState(() => _cameraMode = _StoryCameraMode.video),
              ),
              SizedBox(height: context.height * .014),
            ],
          ),
        ),
      ),
    );
  }
}
