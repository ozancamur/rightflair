import 'dart:io';
import 'dart:typed_data';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../../../core/constants/string.dart';
import 'edit_story_media_page.dart';

class GalleryPickerPage extends StatefulWidget {
  final String uid;

  const GalleryPickerPage({super.key, required this.uid});

  @override
  State<GalleryPickerPage> createState() => _GalleryPickerPageState();
}

class _GalleryPickerPageState extends State<GalleryPickerPage> {
  List<AssetEntity> mediaList = [];
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
        mediaList.addAll(media);
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
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.close, color: Colors.white),
        ),
        title: Text(
          AppStrings.PROFILE_EDIT_STORY_GALLERY.tr(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: _isLoading && mediaList.isEmpty
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : mediaList.isEmpty
          ? Center(
              child: Text(
                AppStrings.PROFILE_EDIT_STORY_GALLERY_EMPTY.tr(),
                style: const TextStyle(color: Colors.white70, fontSize: 14),
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
                padding: const EdgeInsets.all(1),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 1,
                  crossAxisSpacing: 1,
                ),
                itemCount: mediaList.length + (_hasMoreToLoad ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == mediaList.length) {
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    );
                  }

                  final asset = mediaList[index];
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
                            return Container(color: Colors.grey.shade900);
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
                                  Text(
                                    _formatDuration(asset.duration),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                    ),
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
