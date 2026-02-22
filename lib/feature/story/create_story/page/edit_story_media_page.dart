import 'dart:io';
import 'dart:ui' as ui;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';

import '../../../../core/constants/color/color.dart';
import '../../../../core/constants/string.dart';
import '../../../../core/extensions/context.dart';
import '../cubit/create_story_cubit.dart';

/// Filters (same as create_post camera_page)
class _StoryEditFilter {
  final String name;
  final List<double>? colorMatrix;

  const _StoryEditFilter({required this.name, this.colorMatrix});

  static const List<_StoryEditFilter> filters = [
    _StoryEditFilter(name: 'Original'),
    _StoryEditFilter(
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
    _StoryEditFilter(
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
    _StoryEditFilter(
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
    _StoryEditFilter(
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
    _StoryEditFilter(
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
    _StoryEditFilter(
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
    _StoryEditFilter(
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

class EditStoryMediaPage extends StatefulWidget {
  final File mediaFile;
  final bool isVideo;
  final String uid;
  final List<double>? colorMatrix;

  const EditStoryMediaPage({
    super.key,
    required this.mediaFile,
    required this.isVideo,
    required this.uid,
    this.colorMatrix,
  });

  @override
  State<EditStoryMediaPage> createState() => _EditStoryMediaPageState();
}

class _EditStoryMediaPageState extends State<EditStoryMediaPage> {
  VideoPlayerController? _videoController;
  final List<TextOverlay> _textOverlays = [];
  final List<DrawingPoint> _drawingPoints = [];
  bool _isDrawing = false;
  Color _selectedColor = Colors.white;
  final double _strokeWidth = 5.0;
  final GlobalKey _repaintKey = GlobalKey();
  int _selectedFilterIndex = 0;
  bool _showFilters = false;
  bool _isDraggingText = false;
  bool _isOverTrash = false;
  final GlobalKey _trashKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    // If a filter was passed from camera, find matching index
    if (widget.colorMatrix != null) {
      for (int i = 0; i < _StoryEditFilter.filters.length; i++) {
        if (_StoryEditFilter.filters[i].colorMatrix != null &&
            _listsEqual(
              _StoryEditFilter.filters[i].colorMatrix!,
              widget.colorMatrix!,
            )) {
          _selectedFilterIndex = i;
          break;
        }
      }
    }
    if (widget.isVideo) {
      _initializeVideo();
    }
  }

  bool _listsEqual(List<double> a, List<double> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  Future<void> _initializeVideo() async {
    _videoController = VideoPlayerController.file(widget.mediaFile);
    await _videoController!.initialize();
    await _videoController!.setLooping(true);
    await _videoController!.play();
    if (mounted) setState(() {});
  }

  // ======================== ACTIONS ========================

  bool _checkIfOverTrash(Offset overlayPosition) {
    final trashContext = _trashKey.currentContext;
    if (trashContext == null) return false;
    final RenderBox trashBox = trashContext.findRenderObject() as RenderBox;
    final trashPos = trashBox.localToGlobal(Offset.zero);
    final trashSize = trashBox.size;
    // Expand hit area for easier targeting
    const expandedPadding = 30.0;
    final trashRect = Rect.fromLTWH(
      trashPos.dx - expandedPadding,
      trashPos.dy - expandedPadding,
      trashSize.width + expandedPadding * 2,
      trashSize.height + expandedPadding * 2,
    );
    return trashRect.contains(overlayPosition);
  }

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
    final filter = _StoryEditFilter.filters[_selectedFilterIndex];
    if (filter.colorMatrix == null) return child;
    return ColorFiltered(
      colorFilter: ColorFilter.matrix(filter.colorMatrix!),
      child: child,
    );
  }

  Future<File?> _applyFilterToFile(File file) async {
    final filter = _StoryEditFilter.filters[_selectedFilterIndex];
    if (filter.colorMatrix == null) return file;

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

    if (pngBytes == null) return file;

    final dir = file.parent;
    final filteredFile = File(
      '${dir.path}/filtered_${DateTime.now().millisecondsSinceEpoch}.png',
    );
    await filteredFile.writeAsBytes(pngBytes.buffer.asUint8List());
    return filteredFile;
  }

  void _addText() {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        String text = '';
        Color textColor = Colors.white;

        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            return Dialog(
              backgroundColor: Colors.grey.shade900,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.PROFILE_EDIT_STORY_ADD_TEXT.tr(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      autofocus: true,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: AppStrings
                            .PROFILE_EDIT_STORY_WRITE_TEXT_PLACEHOLDER
                            .tr(),
                        hintStyle: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                        ),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white54),
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                      onChanged: (value) => text = value,
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children:
                          [
                            Colors.white,
                            Colors.black,
                            Colors.red,
                            Colors.blue,
                            Colors.green,
                            Colors.yellow,
                            Colors.purple,
                            Colors.orange,
                          ].map((color) {
                            return GestureDetector(
                              onTap: () =>
                                  setDialogState(() => textColor = color),
                              child: Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: color,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: textColor == color
                                        ? Colors.white
                                        : Colors.transparent,
                                    width: 2.5,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(dialogContext),
                          child: Text(
                            AppStrings.DIALOG_CANCEL.tr(),
                            style: const TextStyle(color: Colors.white70),
                          ),
                        ),
                        const SizedBox(width: 8),
                        TextButton(
                          onPressed: () {
                            if (text.isNotEmpty) {
                              setState(() {
                                _textOverlays.add(
                                  TextOverlay(
                                    text: text,
                                    color: textColor,
                                    position: Offset(
                                      context.width / 2,
                                      context.height / 2,
                                    ),
                                  ),
                                );
                              });
                            }
                            Navigator.pop(dialogContext);
                          },
                          child: Text(
                            AppStrings.PROFILE_EDIT_ADD_NEW.tr(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showColorPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey.shade900,
      builder: (BuildContext ctx) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppStrings.PROFILE_EDIT_STORY_SELECT_COLOR.tr(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children:
                    [
                      Colors.white,
                      Colors.black,
                      Colors.red,
                      Colors.blue,
                      Colors.green,
                      Colors.yellow,
                      Colors.purple,
                      Colors.orange,
                      Colors.pink,
                      Colors.teal,
                    ].map((color) {
                      return GestureDetector(
                        onTap: () {
                          setState(() => _selectedColor = color);
                          Navigator.pop(ctx);
                        },
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: _selectedColor == color
                                  ? Colors.white
                                  : Colors.transparent,
                              width: 2.5,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Future<File?> _createCompositeImage() async {
    try {
      final boundary =
          _repaintKey.currentContext!.findRenderObject()
              as RenderRepaintBoundary;
      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final pngBytes = byteData!.buffer.asUint8List();

      final tempDir = await getTemporaryDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final file = File('${tempDir.path}/story_$timestamp.png');
      await file.writeAsBytes(pngBytes);
      return file;
    } catch (e) {
      debugPrint('Error creating composite image: $e');
      return null;
    }
  }

  Future<void> _uploadStory() async {
    if (!mounted) return;

    File fileToUpload = widget.mediaFile;

    // Apply filter to image file if needed
    if (!widget.isVideo) {
      final filtered = await _applyFilterToFile(fileToUpload);
      if (filtered != null) fileToUpload = filtered;
    }

    // Composite image if overlays/drawings exist
    if (!widget.isVideo &&
        (_textOverlays.isNotEmpty || _drawingPoints.isNotEmpty)) {
      final compositeFile = await _createCompositeImage();
      if (compositeFile != null) fileToUpload = compositeFile;
    }

    context.read<CreateStoryCubit>().uploadStoryMedia(
      context: context,
      uid: widget.uid,
      mediaFile: fileToUpload,
      isVideo: widget.isVideo,
    );
  }

  // ======================== BUILD ========================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: BlocListener<CreateStoryCubit, CreateStoryState>(
        listener: (context, state) {
          if (state.isLoading == false && state.uploadSuccess == true) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  AppStrings.PROFILE_EDIT_STORY_CREATED_SUCCESS.tr(),
                ),
                backgroundColor: Colors.green,
              ),
            );
            Future.delayed(const Duration(milliseconds: 500), () {
              if (context.mounted) {
                Navigator.pop(context); // Edit page
                Navigator.pop(context); // Camera page
              }
            });
          } else if (state.error != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error!),
                backgroundColor: Colors.redAccent,
              ),
            );
          }
        },
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Media Preview
            RepaintBoundary(
              key: _repaintKey,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Main media
                  if (widget.isVideo && _videoController != null)
                    Center(
                      child: _applyFilter(
                        AspectRatio(
                          aspectRatio: _videoController!.value.aspectRatio,
                          child: VideoPlayer(_videoController!),
                        ),
                      ),
                    )
                  else
                    Center(
                      child: _applyFilter(
                        Image.file(widget.mediaFile, fit: BoxFit.contain),
                      ),
                    ),

                  // Drawing layer
                  if (!widget.isVideo)
                    Positioned.fill(
                      child: CustomPaint(
                        painter: DrawingPainter(_drawingPoints),
                      ),
                    ),

                  // Text overlays (inside repaint boundary)
                  ..._textOverlays.map((overlay) {
                    return Positioned(
                      left: overlay.position.dx,
                      top: overlay.position.dy,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          overlay.text,
                          style: TextStyle(
                            color: overlay.color,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),

            // Drawing input layer
            if (_isDrawing)
              GestureDetector(
                onPanStart: (d) {
                  setState(() {
                    _drawingPoints.add(
                      DrawingPoint(
                        offset: d.localPosition,
                        paint: Paint()
                          ..color = _selectedColor
                          ..strokeWidth = _strokeWidth
                          ..strokeCap = StrokeCap.round,
                      ),
                    );
                  });
                },
                onPanUpdate: (d) {
                  setState(() {
                    _drawingPoints.add(
                      DrawingPoint(
                        offset: d.localPosition,
                        paint: Paint()
                          ..color = _selectedColor
                          ..strokeWidth = _strokeWidth
                          ..strokeCap = StrokeCap.round,
                      ),
                    );
                  });
                },
                onPanEnd: (_) {
                  _drawingPoints.add(DrawingPoint(offset: null, paint: null));
                },
                child: Container(color: Colors.transparent),
              ),

            // Draggable text overlays (outside repaint boundary)
            ..._textOverlays.asMap().entries.map((entry) {
              final index = entry.key;
              final overlay = entry.value;
              return Positioned(
                left: overlay.position.dx,
                top: overlay.position.dy,
                child: GestureDetector(
                  onLongPressStart: (_) {
                    setState(() => _isDraggingText = true);
                  },
                  onPanStart: (_) {
                    setState(() => _isDraggingText = true);
                  },
                  onPanUpdate: (d) {
                    setState(() {
                      overlay.position = Offset(
                        overlay.position.dx + d.delta.dx,
                        overlay.position.dy + d.delta.dy,
                      );
                      // Check if over trash
                      _isOverTrash = _checkIfOverTrash(overlay.position);
                    });
                  },
                  onPanEnd: (_) {
                    if (_isOverTrash) {
                      setState(() {
                        _textOverlays.removeAt(index);
                        _isDraggingText = false;
                        _isOverTrash = false;
                      });
                    } else {
                      setState(() {
                        _isDraggingText = false;
                        _isOverTrash = false;
                      });
                    }
                  },
                  child: AnimatedScale(
                    scale: _isDraggingText && _isOverTrash ? 0.8 : 1.0,
                    duration: const Duration(milliseconds: 150),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.25),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.4),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        overlay.text,
                        style: TextStyle(
                          color: overlay.color,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),

            // Trash bin (appears when dragging text)
            if (_isDraggingText)
              Positioned(
                bottom: 100,
                left: 0,
                right: 0,
                child: Center(
                  child: AnimatedScale(
                    scale: _isOverTrash ? 1.3 : 1.0,
                    duration: const Duration(milliseconds: 150),
                    child: Container(
                      key: _trashKey,
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: _isOverTrash
                            ? Colors.red
                            : Colors.black.withOpacity(0.6),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: _isOverTrash
                              ? Colors.red.shade300
                              : Colors.white54,
                          width: 2,
                        ),
                      ),
                      child: Icon(
                        Icons.delete,
                        color: Colors.white,
                        size: _isOverTrash ? 30 : 26,
                      ),
                    ),
                  ),
                ),
              ),

            // Top Bar
            _buildTopBar(),

            // Right Side Toolbar
            _buildRightToolbar(),

            // Bottom Section
            _buildBottom(),
          ],
        ),
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
              _circleIconButton(
                Icons.arrow_back_ios_new,
                onTap: () => Navigator.pop(context),
              ),
              const Spacer(),
              const SizedBox(width: 40),
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
            // Text
            _sideToolbarIcon(Icons.text_fields, onTap: _addText),
            const SizedBox(height: 22),
            // Draw
            _sideToolbarIcon(
              Icons.brush_outlined,
              onTap: () => setState(() => _isDrawing = !_isDrawing),
              hasBadge: _isDrawing,
            ),
            const SizedBox(height: 22),
            // Color picker (when drawing)
            if (_isDrawing) ...[
              GestureDetector(
                onTap: _showColorPicker,
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: _selectedColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 22),
            ],
            // Clear drawings
            if (_drawingPoints.isNotEmpty) ...[
              _sideToolbarIcon(
                Icons.delete_outline,
                onTap: () => setState(() => _drawingPoints.clear()),
              ),
              const SizedBox(height: 22),
            ],
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

  // ======================== BOTTOM ========================

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
            colors: [Colors.black.withOpacity(0.8), Colors.transparent],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Filter section
                if (_showFilters) ...[
                  Text(
                    _StoryEditFilter.filters[_selectedFilterIndex].name,
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
                // Buttons row
                BlocBuilder<CreateStoryCubit, CreateStoryState>(
                  builder: (context, state) {
                    final isLoading = state.isLoading == true;
                    return Row(
                      children: [
                        // Retake button
                        Expanded(
                          child: GestureDetector(
                            onTap: isLoading
                                ? null
                                : () => Navigator.pop(context),
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                border: Border.all(
                                  color: Colors.white,
                                  width: 1.5,
                                ),
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
                        // Share / Continue button
                        Expanded(
                          child: GestureDetector(
                            onTap: isLoading ? null : _uploadStory,
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                gradient: LinearGradient(
                                  colors: [AppColors.ORANGE, AppColors.YELLOW],
                                ),
                              ),
                              child: Center(
                                child: isLoading
                                    ? const SizedBox(
                                        width: 22,
                                        height: 22,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2.5,
                                        ),
                                      )
                                    : Text(
                                        AppStrings.PROFILE_EDIT_STORY_SHARE
                                            .tr(),
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
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ======================== FILTER LIST ========================

  Widget _buildFilterList() {
    final filters = _StoryEditFilter.filters;
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

  // ======================== SHARED WIDGETS ========================

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

// ======================== MODELS ========================

class TextOverlay {
  String text;
  Color color;
  Offset position;

  TextOverlay({
    required this.text,
    required this.color,
    required this.position,
  });
}

class DrawingPoint {
  Offset? offset;
  Paint? paint;

  DrawingPoint({this.offset, this.paint});
}

class DrawingPainter extends CustomPainter {
  final List<DrawingPoint> points;

  DrawingPainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < points.length - 1; i++) {
      if (points[i].offset != null && points[i + 1].offset != null) {
        canvas.drawLine(
          points[i].offset!,
          points[i + 1].offset!,
          points[i].paint!,
        );
      }
    }
  }

  @override
  bool shouldRepaint(DrawingPainter oldDelegate) => true;
}
