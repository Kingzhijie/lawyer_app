import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:cached_network_image/cached_network_image.dart';

/// 图片浏览工具
///
/// 支持单图和多图浏览、缩放、滑动切换
class ImageViewerUtil {
  ImageViewerUtil._();

  /// 显示单张图片
  ///
  /// [context] 上下文
  /// [imageUrl] 图片URL
  /// [heroTag] Hero动画标签（可选）
  static void showSingleImage(
    BuildContext context,
    String imageUrl, {
    String? heroTag,
  }) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => _ImageViewerPage(
          imageUrls: [imageUrl],
          initialIndex: 0,
          heroTag: heroTag,
        ),
      ),
    );
  }

  /// 显示多张图片（支持滑动切换）
  ///
  /// [context] 上下文
  /// [imageUrls] 图片URL列表
  /// [initialIndex] 初始显示的图片索引
  /// [heroTag] Hero动画标签（可选）
  static void showImageGallery(
    BuildContext context,
    List<String> imageUrls, {
    int initialIndex = 0,
    String? heroTag,
  }) {
    if (imageUrls.isEmpty) return;

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => _ImageViewerPage(
          imageUrls: imageUrls,
          initialIndex: initialIndex,
          heroTag: heroTag,
        ),
      ),
    );
  }
}

/// 图片浏览页面
class _ImageViewerPage extends StatefulWidget {
  const _ImageViewerPage({
    required this.imageUrls,
    required this.initialIndex,
    this.heroTag,
  });

  final List<String> imageUrls;
  final int initialIndex;
  final String? heroTag;

  @override
  State<_ImageViewerPage> createState() => _ImageViewerPageState();
}

class _ImageViewerPageState extends State<_ImageViewerPage> {
  late PageController _pageController;
  late int _currentIndex;
  bool _showAppBar = true;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _toggleAppBar() {
    setState(() {
      _showAppBar = !_showAppBar;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isSingleImage = widget.imageUrls.length == 1;

    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: _showAppBar
          ? AppBar(
              backgroundColor: Colors.black.withOpacity(0.5),
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: isSingleImage
                  ? null
                  : Text(
                      '${_currentIndex + 1}/${widget.imageUrls.length}',
                      style: const TextStyle(color: Colors.white),
                    ),
              centerTitle: true,
            )
          : null,
      body: GestureDetector(
        onTap: _toggleAppBar,
        child: isSingleImage ? _buildSingleImage() : _buildImageGallery(),
      ),
    );
  }

  /// 构建单图浏览
  Widget _buildSingleImage() {
    final imageUrl = widget.imageUrls.first;

    Widget photoView = PhotoView(
      imageProvider: CachedNetworkImageProvider(imageUrl),
      minScale: PhotoViewComputedScale.contained,
      maxScale: PhotoViewComputedScale.covered * 3,
      initialScale: PhotoViewComputedScale.contained,
      backgroundDecoration: const BoxDecoration(color: Colors.black),
      loadingBuilder: (context, event) => Center(
        child: CircularProgressIndicator(
          value: event == null
              ? null
              : event.cumulativeBytesLoaded / (event.expectedTotalBytes ?? 1),
          valueColor: const AlwaysStoppedAnimation(Colors.white),
        ),
      ),
      errorBuilder: (context, error, stackTrace) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.broken_image, color: Colors.white54, size: 64),
            const SizedBox(height: 16),
            Text(
              '图片加载失败',
              style: TextStyle(color: Colors.white54, fontSize: 14),
            ),
          ],
        ),
      ),
    );

    // 如果有 heroTag，添加 Hero 动画
    if (widget.heroTag != null) {
      photoView = Hero(tag: widget.heroTag!, child: photoView);
    }

    return photoView;
  }

  /// 构建图片画廊（多图）
  Widget _buildImageGallery() {
    return PhotoViewGallery.builder(
      scrollPhysics: const BouncingScrollPhysics(),
      builder: (context, index) {
        final imageUrl = widget.imageUrls[index];

        return PhotoViewGalleryPageOptions(
          imageProvider: CachedNetworkImageProvider(imageUrl),
          minScale: PhotoViewComputedScale.contained,
          maxScale: PhotoViewComputedScale.covered * 3,
          initialScale: PhotoViewComputedScale.contained,
          heroAttributes: widget.heroTag != null && index == widget.initialIndex
              ? PhotoViewHeroAttributes(tag: widget.heroTag!)
              : null,
        );
      },
      itemCount: widget.imageUrls.length,
      loadingBuilder: (context, event) => Center(
        child: CircularProgressIndicator(
          value: event == null
              ? null
              : event.cumulativeBytesLoaded / (event.expectedTotalBytes ?? 1),
          valueColor: const AlwaysStoppedAnimation(Colors.white),
        ),
      ),
      backgroundDecoration: const BoxDecoration(color: Colors.black),
      pageController: _pageController,
      onPageChanged: (index) {
        setState(() {
          _currentIndex = index;
        });
      },
    );
  }
}
