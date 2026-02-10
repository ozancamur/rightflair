import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:rightflair/core/extensions/context.dart';

import '../../../../core/components/text/text.dart';
import '../../../../core/constants/font/font_size.dart';
import 'edit_story_media_page.dart';

class GalleryPickerPage extends StatefulWidget {
  final String uid;

  const GalleryPickerPage({super.key, required this.uid});

  @override
  State<GalleryPickerPage> createState() => _GalleryPickerPageState();
}

class _GalleryPickerPageState extends State<GalleryPickerPage> {
  List<AssetEntity> _mediaList = [];
  bool _isLoading = true;
  int _currentPage = 0;
  final int _pageSize = 50;
  bool _hasMoreToLoad = true;

  @override
  void initState() {
    super.initState();
    _loadMedia();
  }

  Future<void> _loadMedia() async {
    if (!_hasMoreToLoad) return;

    setState(() => _isLoading = true);

    try {
      final PermissionState ps = await PhotoManager.requestPermissionExtend();
      if (!ps.isAuth) {
        debugPrint('Permission denied for gallery access');
        setState(() => _isLoading = false);
        return;
      }

      final List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
        type: RequestType.all,
        onlyAll: true,
      );

      if (albums.isEmpty) {
        setState(() {
          _isLoading = false;
          _hasMoreToLoad = false;
        });
        return;
      }

      final List<AssetEntity> media = await albums.first.getAssetListRange(
        start: _currentPage * _pageSize,
        end: (_currentPage + 1) * _pageSize,
      );

      setState(() {
        _mediaList.addAll(media);
        _currentPage++;
        _isLoading = false;
        _hasMoreToLoad = media.length == _pageSize;
      });
    } catch (e) {
      debugPrint('Error loading media: $e');
      setState(() => _isLoading = false);
    }
  }

  Future<void> _selectMedia(AssetEntity asset) async {
    final File? file = await asset.file;
    if (file != null && mounted) {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EditStoryMediaPage(
            mediaFile: file,
            isVideo: asset.type == AssetType.video,
            uid: widget.uid,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.close, color: Colors.white),
        ),
        title: TextComponent(
          text: 'Galeri',
          color: Colors.white,
          size: FontSizeConstants.LARGE,
          weight: FontWeight.bold,
        ),
        centerTitle: true,
      ),
      body: _isLoading && _mediaList.isEmpty
          ? Center(
              child: CircularProgressIndicator(color: context.colors.primary),
            )
          : _mediaList.isEmpty
          ? Center(
              child: TextComponent(
                text: 'Galeri boş',
                color: Colors.white,
                size: FontSizeConstants.NORMAL,
              ),
            )
          : NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scroll) {
                if (scroll.metrics.pixels >=
                        scroll.metrics.maxScrollExtent * 0.8 &&
                    !_isLoading &&
                    _hasMoreToLoad) {
                  _loadMedia();
                }
                return false;
              },
              child: GridView.builder(
                padding: const EdgeInsets.all(2),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 2,
                  crossAxisSpacing: 2,
                ),
                itemCount: _mediaList.length + (_hasMoreToLoad ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == _mediaList.length) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: context.colors.primary,
                      ),
                    );
                  }

                  final asset = _mediaList[index];
                  return GestureDetector(
                    onTap: () => _selectMedia(asset),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        FutureBuilder<Uint8List?>(
                          future: asset.thumbnailDataWithSize(
                            const ThumbnailSize.square(300),
                          ),
                          builder: (context, snapshot) {
                            if (snapshot.hasData && snapshot.data != null) {
                              return Image.memory(
                                snapshot.data!,
                                fit: BoxFit.cover,
                              );
                            }
                            return Container(color: Colors.grey[900]);
                          },
                        ),
                        if (asset.type == AssetType.video)
                          Positioned(
                            bottom: 4,
                            right: 4,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.7),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.play_arrow,
                                    color: Colors.white,
                                    size: 12,
                                  ),
                                  const SizedBox(width: 2),
                                  TextComponent(
                                    text: _formatDuration(asset.duration),
                                    color: Colors.white,
                                    size: FontSizeConstants.XXX_SMALL,
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
    );
  }

  String _formatDuration(int seconds) {
    final duration = Duration(seconds: seconds);
    final minutes = duration.inMinutes;
    final secs = duration.inSeconds % 60;
    return '${minutes.toString().padLeft(1, '0')}:${secs.toString().padLeft(2, '0')}';
  }
}
