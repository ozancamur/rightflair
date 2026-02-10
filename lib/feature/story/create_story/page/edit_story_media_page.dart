import 'dart:io';
import 'dart:ui' as ui;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';

import '../../../../core/components/text/text.dart';
import '../../../../core/constants/font/font_size.dart';
import '../../../../core/constants/string.dart';
import '../../../../core/extensions/context.dart';
import '../../../main/feed/bloc/feed_bloc.dart';
import '../cubit/create_story_cubit.dart';

class EditStoryMediaPage extends StatefulWidget {
  final File mediaFile;
  final bool isVideo;
  final String uid;

  const EditStoryMediaPage({
    super.key,
    required this.mediaFile,
    required this.isVideo,
    required this.uid,
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

  @override
  void initState() {
    super.initState();
    if (widget.isVideo) {
      _initializeVideo();
    }
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
    if (mounted) {
      setState(() {});
    }
  }

  void _addText() {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        String text = '';
        Color textColor = Colors.white;

        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              backgroundColor: context.colors.secondary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(context.width * 0.03),
              ),
              child: Padding(
                padding: EdgeInsets.all(context.width * 0.05),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    TextComponent(
                      text: AppStrings.PROFILE_EDIT_STORY_ADD_TEXT.tr(),
                      color: context.colors.primary,
                      size: FontSizeConstants.LARGE,
                      weight: FontWeight.bold,
                    ),
                    SizedBox(height: context.height * 0.025),
                    // TextField
                    TextField(
                      autofocus: true,
                      style: TextStyle(color: context.colors.primary),
                      decoration: InputDecoration(
                        hintText: AppStrings
                            .PROFILE_EDIT_STORY_WRITE_TEXT_PLACEHOLDER
                            .tr(),
                        hintStyle: TextStyle(
                          color: context.colors.primary.withOpacity(0.5),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: context.colors.primary),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: context.colors.primary),
                        ),
                      ),
                      onChanged: (value) {
                        text = value;
                      },
                    ),
                    SizedBox(height: context.height * 0.025),
                    // Renk Seçici
                    Wrap(
                      spacing: context.width * 0.025,
                      runSpacing: context.height * 0.015,
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
                              onTap: () {
                                setDialogState(() {
                                  textColor = color;
                                });
                              },
                              child: Container(
                                width: context.width * 0.1,
                                height: context.width * 0.1,
                                decoration: BoxDecoration(
                                  color: color,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: textColor == color
                                        ? context.colors.primary
                                        : Colors.transparent,
                                    width: context.width * 0.0075,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                    ),
                    SizedBox(height: context.height * 0.025),
                    // Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(dialogContext),
                          child: TextComponent(
                            text: AppStrings.DIALOG_CANCEL.tr(),
                            color: context.colors.primary,
                            size: FontSizeConstants.NORMAL,
                          ),
                        ),
                        SizedBox(width: context.width * 0.02),
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
                            text: AppStrings.PROFILE_EDIT_ADD_NEW.tr(),
                            color: context.colors.primary,
                            size: FontSizeConstants.NORMAL,
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
      backgroundColor: context.colors.secondary,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(context.width * 0.05),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextComponent(
                text: AppStrings.PROFILE_EDIT_STORY_SELECT_COLOR.tr(),
                color: context.colors.primary,
                size: FontSizeConstants.LARGE,
                weight: FontWeight.bold,
              ),
              SizedBox(height: context.height * 0.025),
              Wrap(
                spacing: context.width * 0.0375,
                runSpacing: context.height * 0.02,
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
                          setState(() {
                            _selectedColor = color;
                          });
                          Navigator.pop(context);
                        },
                        child: Container(
                          width: context.width * 0.125,
                          height: context.width * 0.125,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: _selectedColor == color
                                  ? context.colors.primary
                                  : Colors.transparent,
                              width: context.width * 0.0075,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
              ),
              SizedBox(height: context.height * 0.025),
            ],
          ),
        );
      },
    );
  }

  Future<File?> _createCompositeImage() async {
    try {
      // RepaintBoundary'den resmi al
      final boundary =
          _repaintKey.currentContext!.findRenderObject()
              as RenderRepaintBoundary;
      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final pngBytes = byteData!.buffer.asUint8List();

      // Geçici dosya oluştur
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
    // Story'yi upload et
    if (mounted) {
      File fileToUpload = widget.mediaFile;

      // Eğer text overlay veya çizim varsa, composite image oluştur
      if (!widget.isVideo &&
          (_textOverlays.isNotEmpty || _drawingPoints.isNotEmpty)) {
        final compositeFile = await _createCompositeImage();
        if (compositeFile != null) {
          fileToUpload = compositeFile;
        }
      }

      context.read<CreateStoryCubit>().uploadStoryMedia(
        context: context,
        uid: widget.uid,
        mediaFile: fileToUpload,
        isVideo: widget.isVideo,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.surface,
      body: BlocListener<CreateStoryCubit, CreateStoryState>(
        listener: (context, state) {
          if (state.isLoading == false && state.uploadSuccess == true) {
            debugPrint('=== Story upload successful ===');
            debugPrint('Uploaded Media URL: ${state.uploadedMediaUrl}');
            debugPrint('Media Type: ${state.mediaType}');
            debugPrint('Duration: ${state.duration}');

            if (state.uploadedMediaUrl != null &&
                state.mediaType != null &&
                state.duration != null) {
              debugPrint('Adding story to feed...');
              context.read<FeedBloc>().add(
                AddNewStoryEvent(
                  mediaUrl: state.uploadedMediaUrl!,
                  mediaType: state.mediaType!,
                  duration: state.duration!,
                ),
              );
              debugPrint('Story event added to FeedBloc');
            } else {
              debugPrint('WARNING: Missing story data - cannot add to feed');
            }

            // Başarı mesajı göster
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  AppStrings.PROFILE_EDIT_STORY_CREATED_SUCCESS.tr(),
                ),
                backgroundColor: context.colors.tertiary,
              ),
            );

            // Upload başarılı olduktan sonra sayfaları kapat
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
                backgroundColor: context.colors.error,
              ),
            );
          }
        },
        child: Stack(
          children: [
            // RepaintBoundary ile medya, çizimler ve text'leri sarmalıyoruz
            RepaintBoundary(
              key: _repaintKey,
              child: Stack(
                children: [
                  // Medya Önizleme
                  if (widget.isVideo && _videoController != null)
                    Center(
                      child: AspectRatio(
                        aspectRatio: _videoController!.value.aspectRatio,
                        child: VideoPlayer(_videoController!),
                      ),
                    )
                  else
                    Center(
                      child: InteractiveViewer(
                        minScale: 0.5,
                        maxScale: 4.0,
                        panEnabled: true,
                        scaleEnabled: true,
                        child: Image.file(
                          widget.mediaFile,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),

                  // Çizim Katmanı
                  if (!widget.isVideo)
                    Positioned.fill(
                      child: CustomPaint(
                        painter: DrawingPainter(_drawingPoints),
                      ),
                    ),

                  // Metin Overlay'leri
                  ..._textOverlays.map((textOverlay) {
                    return Positioned(
                      left: textOverlay.position.dx,
                      top: textOverlay.position.dy,
                      child: Container(
                        padding: EdgeInsets.all(context.width * 0.02),
                        decoration: BoxDecoration(
                          color: context.colors.surface.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(
                            context.width * 0.02,
                          ),
                        ),
                        child: TextComponent(
                          text: textOverlay.text,
                          color: textOverlay.color,
                          size: FontSizeConstants.X_LARGE,
                          weight: FontWeight.bold,
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),

            // Çizim Input Katmanı (RepaintBoundary dışında)
            if (_isDrawing)
              GestureDetector(
                onPanStart: (details) {
                  setState(() {
                    _drawingPoints.add(
                      DrawingPoint(
                        offset: details.localPosition,
                        paint: Paint()
                          ..color = _selectedColor
                          ..strokeWidth = _strokeWidth
                          ..strokeCap = StrokeCap.round,
                      ),
                    );
                  });
                },
                onPanUpdate: (details) {
                  setState(() {
                    _drawingPoints.add(
                      DrawingPoint(
                        offset: details.localPosition,
                        paint: Paint()
                          ..color = _selectedColor
                          ..strokeWidth = _strokeWidth
                          ..strokeCap = StrokeCap.round,
                      ),
                    );
                  });
                },
                onPanEnd: (details) {
                  _drawingPoints.add(DrawingPoint(offset: null, paint: null));
                },
                child: Container(color: Colors.transparent),
              ),

            // Metin Overlay'leri - Hareket Edilebilir (RepaintBoundary dışında)
            ..._textOverlays.map((textOverlay) {
              return Positioned(
                left: textOverlay.position.dx,
                top: textOverlay.position.dy,
                child: GestureDetector(
                  onPanUpdate: (details) {
                    setState(() {
                      textOverlay.position = Offset(
                        textOverlay.position.dx + details.delta.dx,
                        textOverlay.position.dy + details.delta.dy,
                      );
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(context.width * 0.02),
                    decoration: BoxDecoration(
                      color: context.colors.surface.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(context.width * 0.02),
                      border: Border.all(
                        color: context.colors.onSurface.withOpacity(0.5),
                        width: 1,
                      ),
                    ),
                    child: TextComponent(
                      text: textOverlay.text,
                      color: textOverlay.color,
                      size: FontSizeConstants.X_LARGE,
                      weight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            }),

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
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(
                        Icons.close,
                        color: context.colors.onSurface,
                        size: context.width * 0.075,
                      ),
                    ),
                    Row(
                      children: [
                        // Metin Ekle
                        IconButton(
                          onPressed: _addText,
                          icon: Icon(
                            Icons.text_fields,
                            color: context.colors.onSurface,
                            size: context.width * 0.075,
                          ),
                        ),
                        // Çizim Modu
                        IconButton(
                          onPressed: () {
                            setState(() {
                              _isDrawing = !_isDrawing;
                            });
                          },
                          icon: Icon(
                            Icons.draw,
                            color: _isDrawing
                                ? context.colors.tertiary
                                : context.colors.onSurface,
                            size: context.width * 0.075,
                          ),
                        ),
                        // Renk Seçici (Çizim için)
                        if (_isDrawing)
                          IconButton(
                            onPressed: _showColorPicker,
                            icon: Icon(
                              Icons.color_lens,
                              color: _selectedColor,
                              size: context.width * 0.075,
                            ),
                          ),
                        // Çizimi Temizle
                        if (_drawingPoints.isNotEmpty)
                          IconButton(
                            onPressed: () {
                              setState(() {
                                _drawingPoints.clear();
                              });
                            },
                            icon: Icon(
                              Icons.delete,
                              color: context.colors.onSurface,
                              size: context.width * 0.075,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Alt Buton - Paylaş
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: SafeArea(
                child: Container(
                  margin: EdgeInsets.all(context.width * 0.05),
                  child: BlocBuilder<CreateStoryCubit, CreateStoryState>(
                    builder: (context, state) {
                      if (state.isLoading == true) {
                        return Container(
                          padding: EdgeInsets.symmetric(
                            vertical: context.height * 0.02,
                          ),
                          decoration: BoxDecoration(
                            color: context.colors.primary,
                            borderRadius: BorderRadius.circular(
                              context.width * 0.075,
                            ),
                          ),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: context.colors.onPrimary,
                            ),
                          ),
                        );
                      }

                      return ElevatedButton(
                        onPressed: _uploadStory,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: context.colors.primary,
                          padding: EdgeInsets.symmetric(
                            vertical: context.height * 0.02,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              context.width * 0.075,
                            ),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.send, color: context.colors.onPrimary),
                            SizedBox(width: context.width * 0.025),
                            TextComponent(
                              text: AppStrings.PROFILE_EDIT_STORY_SHARE.tr(),
                              color: context.colors.onPrimary,
                              size: FontSizeConstants.LARGE,
                              weight: FontWeight.bold,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Metin Overlay Model
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

// Çizim Noktası Model
class DrawingPoint {
  Offset? offset;
  Paint? paint;

  DrawingPoint({this.offset, this.paint});
}

// Çizim Painter
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
