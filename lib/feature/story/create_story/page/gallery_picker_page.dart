import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../../../core/base/page/base_scaffold.dart';
import '../../../../core/components/text/text.dart';
import '../../../../core/constants/color/color.dart';
import '../../../../core/constants/string.dart';
import '../../../../core/extensions/context.dart';
import '../widgets/gallery_media_grid_item.dart';
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

  // ---------------------------------------------------------------------------
  // Data
  // ---------------------------------------------------------------------------

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

  // ---------------------------------------------------------------------------
  // Build
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: AppBar(
        backgroundColor: context.colors.surface,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.close,
            color: context.colors.onSurface,
            size: context.width * .06,
          ),
        ),
        title: TextComponent(
          text: AppStrings.PROFILE_EDIT_STORY_GALLERY,
          size: const [17],
          color: context.colors.onSurface,
          weight: FontWeight.bold,
        ),
        centerTitle: true,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading && mediaList.isEmpty) {
      return Center(
        child: CircularProgressIndicator(color: context.colors.onSurface),
      );
    }

    if (mediaList.isEmpty) {
      return Center(
        child: TextComponent(
          text: AppStrings.PROFILE_EDIT_STORY_GALLERY_EMPTY,
          size: const [14],
          color: AppColors.WHITE.withOpacity(0.7),
        ),
      );
    }

    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scroll) {
        if (scroll.metrics.pixels >= scroll.metrics.maxScrollExtent * 0.8 &&
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
            return Center(
              child: CircularProgressIndicator(color: context.colors.onSurface),
            );
          }
          return GalleryMediaGridItem(
            asset: mediaList[index],
            onTap: () => _selectMedia(mediaList[index]),
          );
        },
      ),
    );
  }
}
