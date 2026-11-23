import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/avatar_controller.dart';

class AvatarLayeredDisplay extends StatelessWidget {
  final double size;

  const AvatarLayeredDisplay({Key? key, this.size = 200}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AvatarController controller = Get.find<AvatarController>();

    return Obx(() {
      return SizedBox(
        width: size,
        height: size,
        child: Image.asset(
          controller.currentAvatarDisplayPath.value,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return Icon(Icons.person, size: size * 0.8, color: Colors.grey.shade300);
          },
        ),
      );
    });
  }
}
