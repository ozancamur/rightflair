import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/constants/string.dart';
import '../../../core/extensions/context.dart';

class ShareSocialMediaGridWidget extends StatelessWidget {
  final String? postId;
  final String userId;
  const ShareSocialMediaGridWidget({
    super.key,
    this.postId,
    required this.userId,
  });

  String get _shareLink {
    if (postId != null && postId!.isNotEmpty) {
      return 'https://rightflair.com/post/$postId';
    }
    return 'https://rightflair.com/user/$userId';
  }

  String get _shareText => 'Check this out on Rightflair! $_shareLink';

  @override
  Widget build(BuildContext context) {
    final items = _socialItems(context);

    return SizedBox(
      height: context.height * 0.1,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: context.width * 0.03),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return _SocialItem(
            icon: item.icon,
            label: item.label,
            color: item.color,
            onTap: item.onTap,
          );
        },
      ),
    );
  }

  List<_SocialData> _socialItems(BuildContext context) {
    return [
      _SocialData(
        icon: Icons.copy_rounded,
        label: AppStrings.SHARE_DIALOG_COPY_LINK.tr(),
        color: context.colors.primary,
        onTap: () => _copyLink(context),
      ),
      _SocialData(
        icon: Icons.message_rounded,
        label: AppStrings.SHARE_DIALOG_SMS.tr(),
        color: const Color(0xFF34C759),
        onTap: () => _openSms(),
      ),
      _SocialData(
        icon: Icons.share_rounded,
        label: AppStrings.SHARE_DIALOG_MORE.tr(),
        color: context.colors.primary,
        onTap: () => _shareMore(),
      ),
    ];
  }

  void _copyLink(BuildContext context) {
    Clipboard.setData(ClipboardData(text: _shareLink));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppStrings.SHARE_DIALOG_LINK_COPIED.tr()),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Future<void> _openSms() async {
    final uri = Uri(
      scheme: 'sms',
      path: '',
      queryParameters: {'body': _shareText},
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> _shareMore() async {
    await SharePlus.instance.share(ShareParams(text: _shareText));
  }
}

class _SocialData {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  _SocialData({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });
}

class _SocialItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _SocialItem({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final size = context.width * 0.15;

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: context.width * 0.02),
        child: SizedBox(
          width: size,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color.withValues(alpha: 0.12),
                ),
                child: Icon(icon, color: color, size: size * 0.45),
              ),
              SizedBox(height: context.height * 0.005),
              Text(
                label,
                style: TextStyle(
                  color: context.colors.primary,
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
