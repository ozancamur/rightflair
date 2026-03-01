import 'dart:io';
import 'dart:ui' as ui;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';

import '../../../../core/base/page/base_scaffold.dart';
import '../../../../core/components/text/text.dart';
import '../../../../core/constants/color/color.dart';
import '../../../../core/constants/string.dart';
import '../../../../core/extensions/context.dart';
import '../cubit/create_story_cubit.dart';
import '../model/story_drawing.dart';
import '../model/story_filter.dart';
import '../widgets/story_action_buttons.dart';
import '../widgets/story_circle_icon_button.dart';
import '../widgets/story_filter_list.dart';
import '../widgets/story_side_toolbar_icon.dart';
import '../widgets/story_trash_bin.dart';

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
      for (int i = 0; i < StoryFilter.filters.length; i++) {
        if (StoryFilter.filters[i].colorMatrix != null &&
            _listsEqual(
              StoryFilter.filters[i].colorMatrix!,
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
    final filter = StoryFilter.filters[_selectedFilterIndex];
    if (filter.colorMatrix == null) return child;
    return ColorFiltered(
      colorFilter: ColorFilter.matrix(filter.colorMatrix!),
      child: child,
    );
  }

  Future<File?> _applyFilterToFile(File file) async {
    final filter = StoryFilter.filters[_selectedFilterIndex];
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
        Color textColor = AppColors.WHITE;

        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            return Dialog(
              backgroundColor: context.colors.surfaceContainerHighest,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(context.width * .03),
              ),
              child: Padding(
                padding: EdgeInsets.all(context.width * .05),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextComponent(
                      text: AppStrings.PROFILE_EDIT_STORY_ADD_TEXT,
                      size: const [16],
                      color: AppColors.WHITE,
                      weight: FontWeight.bold,
                    ),
                    SizedBox(height: context.height * .019),
                    TextField(
                      autofocus: true,
                      style: const TextStyle(color: AppColors.WHITE),
                      decoration: InputDecoration(
                        hintText: AppStrings
                            .PROFILE_EDIT_STORY_WRITE_TEXT_PLACEHOLDER
                            .tr(),
                        hintStyle: TextStyle(color: AppColors.WHITE_50),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColors.WHITE_54),
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColors.WHITE),
                        ),
                      ),
                      onChanged: (value) => text = value,
                    ),
                    SizedBox(height: context.height * .019),
                    Wrap(
                      spacing: context.width * .02,
                      runSpacing: context.width * .02,
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
                                width: context.width * .09,
                                height: context.width * .09,
                                decoration: BoxDecoration(
                                  color: color,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: textColor == color
                                        ? AppColors.WHITE
                                        : AppColors.TRANSPARENT,
                                    width: 2.5,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                    ),
                    SizedBox(height: context.height * .019),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(dialogContext),
                          child: TextComponent(
                            text: AppStrings.DIALOG_CANCEL,
                            size: const [14],
                            color: AppColors.WHITE.withOpacity(0.7),
                          ),
                        ),
                        SizedBox(width: context.width * .02),
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
                          child: TextComponent(
                            text: AppStrings.PROFILE_EDIT_ADD_NEW,
                            size: const [14],
                            color: AppColors.WHITE,
                            weight: FontWeight.bold,
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
      backgroundColor: context.colors.surfaceContainerHighest,
      builder: (BuildContext ctx) {
        return Padding(
          padding: EdgeInsets.all(context.width * .05),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextComponent(
                text: AppStrings.PROFILE_EDIT_STORY_SELECT_COLOR,
                size: const [16],
                color: AppColors.WHITE,
                weight: FontWeight.bold,
              ),
              SizedBox(height: context.height * .019),
              Wrap(
                spacing: context.width * .03,
                runSpacing: context.width * .03,
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
                          width: context.width * .11,
                          height: context.width * .11,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: _selectedColor == color
                                  ? AppColors.WHITE
                                  : AppColors.TRANSPARENT,
                              width: 2.5,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
              ),
              SizedBox(height: context.height * .019),
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
    return BaseScaffold(
      body: BlocListener<CreateStoryCubit, CreateStoryState>(
        listener: (context, state) {
          if (state.isLoading == false && state.uploadSuccess == true) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  AppStrings.PROFILE_EDIT_STORY_CREATED_SUCCESS.tr(),
                ),
                backgroundColor: AppColors.GREEN,
              ),
            );
            Future.delayed(const Duration(milliseconds: 500), () {
              if (context.mounted) {
                Navigator.pop(context, true);
                Navigator.pop(context, true);
              }
            });
          } else if (state.error != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error!),
                backgroundColor: AppColors.RED_ACCENT,
              ),
            );
          }
        },
        child: Stack(
          fit: StackFit.expand,
          children: [
            _buildMediaPreview(),
            if (_isDrawing) _buildDrawingLayer(),
            ..._buildDraggableTextOverlays(),
            if (_isDraggingText) _buildTrashBin(),
            _buildTopBar(),
            _buildRightToolbar(),
            _buildBottom(),
          ],
        ),
      ),
    );
  }

  // ======================== MEDIA PREVIEW ========================

  Widget _buildMediaPreview() {
    return RepaintBoundary(
      key: _repaintKey,
      child: Stack(
        fit: StackFit.expand,
        children: [
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
            Positioned.fill(
              child: _applyFilter(
                Image.file(widget.mediaFile, fit: BoxFit.cover),
              ),
            ),
          if (!widget.isVideo)
            Positioned.fill(
              child: CustomPaint(painter: DrawingPainter(_drawingPoints)),
            ),
          ..._textOverlays.map((overlay) {
            return Positioned(
              left: overlay.position.dx,
              top: overlay.position.dy,
              child: Container(
                padding: EdgeInsets.all(context.width * .02),
                decoration: BoxDecoration(
                  color: AppColors.BLACK.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(context.width * .02),
                ),
                child: TextComponent(
                  text: overlay.text,
                  tr: false,
                  size: const [18],
                  color: overlay.color,
                  weight: FontWeight.bold,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  // ======================== DRAWING LAYER ========================

  Widget _buildDrawingLayer() {
    return GestureDetector(
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
      child: Container(color: AppColors.TRANSPARENT),
    );
  }

  // ======================== DRAGGABLE TEXT OVERLAYS ========================

  List<Widget> _buildDraggableTextOverlays() {
    return _textOverlays.asMap().entries.map((entry) {
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
              padding: EdgeInsets.all(context.width * .02),
              decoration: BoxDecoration(
                color: AppColors.BLACK.withOpacity(0.25),
                borderRadius: BorderRadius.circular(context.width * .02),
                border: Border.all(
                  color: AppColors.WHITE.withOpacity(0.4),
                  width: 1,
                ),
              ),
              child: TextComponent(
                text: overlay.text,
                tr: false,
                size: const [18],
                color: overlay.color,
                weight: FontWeight.bold,
              ),
            ),
          ),
        ),
      );
    }).toList();
  }

  // ======================== TRASH BIN ========================

  Widget _buildTrashBin() {
    return Positioned(
      bottom: context.height * .12,
      left: 0,
      right: 0,
      child: Center(
        child: StoryTrashBin(trashKey: _trashKey, isOverTrash: _isOverTrash),
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
                icon: Icons.arrow_back_ios_new,
                onTap: () => Navigator.pop(context),
              ),
              const Spacer(),
              SizedBox(width: context.width * .1),
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
            StorySideToolbarIcon(icon: Icons.text_fields, onTap: _addText),
            SizedBox(height: context.height * .026),
            StorySideToolbarIcon(
              icon: Icons.brush_outlined,
              onTap: () => setState(() => _isDrawing = !_isDrawing),
              hasBadge: _isDrawing,
            ),
            SizedBox(height: context.height * .026),
            if (_isDrawing) ...[
              GestureDetector(
                onTap: _showColorPicker,
                child: Container(
                  width: context.width * .07,
                  height: context.width * .07,
                  decoration: BoxDecoration(
                    color: _selectedColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.WHITE, width: 2),
                  ),
                ),
              ),
              SizedBox(height: context.height * .026),
            ],
            if (_drawingPoints.isNotEmpty) ...[
              StorySideToolbarIcon(
                icon: Icons.delete_outline,
                onTap: () => setState(() => _drawingPoints.clear()),
              ),
              SizedBox(height: context.height * .026),
            ],
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
            colors: [AppColors.BLACK_80, AppColors.TRANSPARENT],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: context.width * .04,
              vertical: context.height * .014,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_showFilters) ...[
                  TextComponent(
                    text: StoryFilter.filters[_selectedFilterIndex].name,
                    tr: false,
                    size: const [12],
                    color: AppColors.WHITE,
                    weight: FontWeight.w600,
                  ),
                  SizedBox(height: context.height * .012),
                  StoryFilterList(
                    selectedFilterIndex: _selectedFilterIndex,
                    onFilterSelected: (i) =>
                        setState(() => _selectedFilterIndex = i),
                  ),
                  SizedBox(height: context.height * .019),
                ],
                StoryActionButtons(
                  onRetake: () => Navigator.pop(context),
                  onShare: _uploadStory,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
