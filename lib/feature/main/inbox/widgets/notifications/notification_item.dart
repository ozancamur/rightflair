import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rightflair/core/constants/enums/notification_type.dart';

import '../../../../../core/extensions/context.dart';
import '../../model/notification_config.dart';

class NotificationItemWidget extends StatelessWidget {
  final NotificationType? type;
  const NotificationItemWidget({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    final config = NotificationConfig.getConfig(context, type);
    return Container(
      height: context.width * 0.12,
      width: context.width * 0.12,
      padding: EdgeInsets.all(context.width * 0.03),
      decoration: BoxDecoration(color: config.bgColor, shape: BoxShape.circle),
      child: SvgPicture.asset(
        config.icon,
        colorFilter: ColorFilter.mode(config.iconColor, BlendMode.srcIn),
      ),
    );
  }
}
