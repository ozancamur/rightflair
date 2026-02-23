import 'dart:io';
import 'dart:ui' as ui;
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:rightflair/core/constants/color/color.dart';
import 'package:rightflair/core/constants/icons.dart';
import 'package:rightflair/core/constants/route.dart';
import 'package:rightflair/core/constants/string.dart';
import 'package:rightflair/core/extensions/context.dart';
import 'package:rightflair/feature/share/dialog/dialog_share.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:easy_localization/easy_localization.dart';
import 'dart:typed_data';

import '../cubit/create_post_cubit.dart';
import '../model/camera_filter.dart';
import '../widgets/camera/add_sound_pill.dart';
import '../widgets/camera/bottom_gallery_picker.dart';
import '../widgets/camera/camera_filter_list.dart';
import '../widgets/camera/capture_button.dart';
import '../widgets/camera/circle_icon_button.dart';
import '../widgets/camera/preview_action_buttons.dart';
import '../widgets/camera/side_toolbar_icon.dart';
import '../widgets/dialog_add_music.dart';

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
  int _currentCameraIndex = 0;
  int _selectedFilterIndex = 0;
  bool _showFilters = false;
  Uint8List? _latestGalleryImage;
  late final CreatePostCubit _createPostCubit;
  final GlobalKey _backButtonKey = GlobalKey();

  // ---------------------------------------------------------------------------
  // Lifecycle
  // ---------------------------------------------------------------------------

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
    _createPostCubit.stopMusic();
    _createPostCubit.setSelectedMusic(null);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final cameraController = _controller;
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }
    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initializeCamera();
    }
  }

  // ---------------------------------------------------------------------------
  // Camera helpers
  // ---------------------------------------------------------------------------

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

      if (mounted) setState(() => _isInitialized = true);
    } catch (e) {
      debugPrint('Camera initialization error: $e');
    }
  }

  Future<void> _loadGalleryImages() async {
    try {
      final ps = await PhotoManager.requestPermissionExtend();
      if (!ps.isAuth) return;

      final albums = await PhotoManager.getAssetPathList(
        type: RequestType.image,
        onlyAll: true,
      );
      if (albums.isEmpty) return;

      final assets = await albums[0].getAssetListRange(start: 0, end: 1);
      if (assets.isEmpty) return;

      final thumbData = await assets[0].thumbnailDataWithSize(
        const ThumbnailSize(200, 200),
      );

      if (mounted && thumbData != null) {
        setState(() => _latestGalleryImage = thumbData);
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
      final image = await _controller!.takePicture();
      setState(() => _capturedImagePath = image.path);
    } catch (e) {
      debugPrint('Error taking picture: $e');
    }
  }

  Future<void> _pickFromGallery() async {
    try {
      final picker = ImagePicker();
      final image = await picker.pickImage(
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

  void _retake() => setState(() => _capturedImagePath = null);

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

  // ---------------------------------------------------------------------------
  // Filter helpers
  // ---------------------------------------------------------------------------

  Widget _applyFilter(Widget child) {
    final filter = CameraFilter.filters[_selectedFilterIndex];
    if (filter.colorMatrix == null) return child;
    return ColorFiltered(
      colorFilter: ColorFilter.matrix(filter.colorMatrix!),
      child: child,
    );
  }

  Future<String> _applyFilterToFile(String imagePath) async {
    final filter = CameraFilter.filters[_selectedFilterIndex];
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

  // ---------------------------------------------------------------------------
  // Navigation / actions
  // ---------------------------------------------------------------------------

  Future<void> _continueToPost() async {
    if (_capturedImagePath == null) return;

    final isAnonymous = context.read<CreatePostCubit>().state.isAnonymous;
    if (isAnonymous && mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(
          child: CircularProgressIndicator(color: AppColors.WHITE),
        ),
      );
    }

    final filteredPath = await _applyFilterToFile(_capturedImagePath!);
    await context.read<CreatePostCubit>().setImagePath(filteredPath);

    if (isAnonymous && mounted) Navigator.of(context).pop();
    if (mounted) context.push(RouteConstants.CREATE_POST);
  }

  void _showAddMusicDialog() async {
    final music = await showModalBottomSheet<dynamic>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.TRANSPARENT,
      builder: (_) => const AddMusicBottomSheet(),
    );
    if (music != null && mounted) {
      context.read<CreatePostCubit>().setSelectedMusic(music);
      context.read<CreatePostCubit>().playMusic();
    }
  }

  void _removeMusic() {
    _createPostCubit.stopMusic();
    _createPostCubit.setSelectedMusic(null);
  }

  // ---------------------------------------------------------------------------
  // Preview back options
  // ---------------------------------------------------------------------------

  void _showPreviewBackOptions() {
    final renderBox =
        _backButtonKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final position = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    showMenu<String>(
      context: context,
      color: context.colors.primary,
      position: RelativeRect.fromLTRB(
        position.dx,
        position.dy + size.height + 8,
        position.dx + size.width,
        0,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      items: [
        PopupMenuItem<String>(
          value: 'discard',
          child: Row(
            children: [
              SvgPicture.asset(
                AppIcons.DELETE,
                color: context.colors.error,
                height: context.height * .03,
              ),
              const SizedBox(width: 12),
              Text(
                AppStrings.CREATE_POST_DISCARD.tr(),
                style: const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'draft',
          child: Row(
            children: [
              SvgPicture.asset(
                AppIcons.DRAFT,
                color: context.colors.secondary,
                height: context.height * .03,
              ),
              const SizedBox(width: 12),
              Text(
                AppStrings.CREATE_POST_SAVE_DRAFT.tr(),
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: context.colors.secondary,
                ),
              ),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'send',
          child: Row(
            children: [
              CircleAvatar(
                radius: 11,
                backgroundImage: FileImage(File(_capturedImagePath!)),
              ),
              const SizedBox(width: 12),
              Text(
                AppStrings.CREATE_POST_SEND_TO_FRIENDS.tr(),
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: context.colors.secondary,
                ),
              ),
            ],
          ),
        ),
      ],
    ).then((value) {
      if (value == null) return;
      switch (value) {
        case 'discard':
          _retake();
          break;
        case 'draft':
          _saveDraftFromPreview();
          break;
        case 'send':
          _sendToFriends();
          break;
      }
    });
  }

  Future<void> _saveDraftFromPreview() async {
    if (_capturedImagePath == null) return;

    final filteredPath = await _applyFilterToFile(_capturedImagePath!);
    await _createPostCubit.setImagePath(filteredPath);

    if (mounted) {
      _createPostCubit.createDraft(context);
    }
  }

  Future<void> _sendToFriends() async {
    if (_capturedImagePath == null) return;

    final String? uid = Supabase.instance.client.auth.currentUser?.id;
    if (uid == null || uid.isEmpty) return;

    // Show loading
    if (mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(
          child: CircularProgressIndicator(color: AppColors.WHITE),
        ),
      );
    }

    // Apply filter and upload image
    final filteredPath = await _applyFilterToFile(_capturedImagePath!);
    await _createPostCubit.setImagePath(filteredPath);
    final imageUrl = await _createPostCubit.uploadImage();

    // Dismiss loading
    if (mounted) Navigator.of(context).pop();

    if (imageUrl != null && imageUrl.isNotEmpty && mounted) {
      dialogShare(context, userId: uid, showReport: false, imageUrl: imageUrl);
    }
  }

  // ---------------------------------------------------------------------------
  // Build
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const Scaffold(
        backgroundColor: AppColors.BLACK,
        body: Center(child: CircularProgressIndicator(color: AppColors.WHITE)),
      );
    }

    return _capturedImagePath != null ? _buildPreview() : _buildCamera();
  }

  // ======================== CAMERA MODE ========================

  Widget _buildCamera() {
    return Scaffold(
      backgroundColor: AppColors.BLACK,
      body: Stack(
        fit: StackFit.expand,
        children: [
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
          _buildCameraTopBar(),
          _buildCameraRightToolbar(),
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
              CircleIconButton(
                icon: Icons.close,
                onTap: () {
                  _createPostCubit.stopMusic();
                  _createPostCubit.setSelectedMusic(null);
                  context.pop();
                },
              ),
              const Spacer(),
              AddSoundPill(onTap: _showAddMusicDialog, onRemove: _removeMusic),
              const Spacer(),
              CircleIconButton(
                icon: Icons.cameraswitch_outlined,
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
            SideToolbarIcon(
              icon: _isFlashOn ? Icons.flash_on : Icons.flash_off,
              onTap: _toggleFlash,
            ),
            const SizedBox(height: 22),
            SideToolbarIcon(
              icon: Icons.auto_awesome,
              onTap: _toggleFilterVisibility,
              hasBadge: _showFilters,
            ),
          ],
        ),
      ),
    );
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
            colors: [AppColors.BLACK_70, AppColors.TRANSPARENT],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              CaptureButton(onTap: _takePicture),
              const SizedBox(height: 6),
              if (_showFilters) ...[
                Text(
                  CameraFilter.filters[_selectedFilterIndex].name,
                  style: const TextStyle(
                    color: AppColors.WHITE,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 14),
                CameraFilterList(
                  selectedFilterIndex: _selectedFilterIndex,
                  onFilterSelected: (i) =>
                      setState(() => _selectedFilterIndex = i),
                ),
              ],
              const SizedBox(height: 16),
              BottomGalleryPicker(
                onPickFromGallery: _pickFromGallery,
                latestGalleryImage: _latestGalleryImage,
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  // ======================== PREVIEW MODE ========================

  Widget _buildPreview() {
    return Scaffold(
      backgroundColor: AppColors.BLACK,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Center(
            child: _applyFilter(
              Image.file(File(_capturedImagePath!), fit: BoxFit.contain),
            ),
          ),
          _buildPreviewTopBar(),
          _buildPreviewRightToolbar(),
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
              CircleIconButton(
                key: _backButtonKey,
                icon: Icons.arrow_back_ios_new,
                onTap: _showPreviewBackOptions,
              ),
              const Spacer(),
              AddSoundPill(onTap: _showAddMusicDialog, onRemove: _removeMusic),
              const Spacer(),
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
            const SideToolbarIcon(icon: Icons.text_fields),
            const SizedBox(height: 22),
            const SideToolbarIcon(icon: Icons.brush_outlined),
            const SizedBox(height: 22),
            SideToolbarIcon(
              icon: Icons.auto_awesome,
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
            colors: [AppColors.BLACK_80, AppColors.TRANSPARENT],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_showFilters) ...[
                  Text(
                    CameraFilter.filters[_selectedFilterIndex].name,
                    style: const TextStyle(
                      color: AppColors.WHITE,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  CameraFilterList(
                    selectedFilterIndex: _selectedFilterIndex,
                    onFilterSelected: (i) =>
                        setState(() => _selectedFilterIndex = i),
                  ),
                  const SizedBox(height: 16),
                ],
                PreviewActionButtons(
                  onRetake: _retake,
                  onContinue: _continueToPost,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
