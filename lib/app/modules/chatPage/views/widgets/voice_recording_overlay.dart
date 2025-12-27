import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lawyer_app/app/common/constants/app_colors.dart';
import 'package:lawyer_app/app/utils/screen_utils.dart';
import '../../controllers/chat_page_controller.dart';

/// 录音界面覆盖层
class VoiceRecordingOverlay extends StatelessWidget {
  const VoiceRecordingOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ChatPageController>();

    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Obx(() {
        final isCancelMode = controller.isCancelMode.value;
        final recognizedText = controller.recognizedText.value;
        final amplitude = controller.recordingAmplitude.value;

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 20,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 30.toW),
                // 顶部提示 "请说，我在听"
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _VoiceRipple(amplitude: amplitude),
                    SizedBox(width: 7.toW),
                    Text(
                      '请说，我在听',
                      style: TextStyle(
                        fontSize: 18.toSp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.theme,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24.toW),
                // 识别的文字内容
                SingleChildScrollView(
                  child: Container(
                    constraints: BoxConstraints(
                      minHeight: 200.toW,
                      maxHeight: 400.toW,
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 24.toW),
                    alignment: Alignment.topLeft,
                    child: Text(
                      recognizedText,
                      style: TextStyle(
                        fontSize: 20.toSp,
                        color: AppColors.color_99000000,
                        fontWeight: FontWeight.w500,
                        height: 1.5,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16.toW),
                // 底部提示文字
                Text(
                  isCancelMode ? '松开取消' : '松开发送，上滑取消',
                  style: TextStyle(
                    fontSize: 12.toSp,
                    color: isCancelMode
                        ? const Color(0xFFFF3E20)
                        : AppColors.color_E6000000,
                  ),
                ),
                SizedBox(height: 16.toW),
                // 底部波形条
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 24.toW),
                  height: 52.toW,
                  decoration: BoxDecoration(
                    color: isCancelMode
                        ? const Color(0xFFFF3E20)
                        : AppColors.theme,
                    borderRadius: BorderRadius.circular(12.toW),
                  ),
                  child: Center(
                    child: _WaveformAnimation(amplitude: amplitude),
                  ),
                ),
                SizedBox(height: 20.toW),
              ],
            ),
          ),
        );
      }),
    );
  }
}

/// 波形动画组件
class _WaveformAnimation extends StatefulWidget {
  const _WaveformAnimation({required this.amplitude});

  final double amplitude;

  @override
  State<_WaveformAnimation> createState() => _WaveformAnimationState();
}

class _WaveformAnimationState extends State<_WaveformAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final int _barCount = 30;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: List.generate(_barCount, (index) {
            final baseHeight = 8.0 + widget.amplitude * 20.0;
            final phase = (index / _barCount) * 2 * pi;
            final animValue = sin(_controller.value * 2 * pi + phase);
            final centerFactor =
                1.0 - ((index - _barCount / 2).abs() / (_barCount / 2)) * 0.5;
            final height =
                baseHeight * centerFactor * (0.5 + 0.5 * animValue.abs());

            return Container(
              width: 3.toW,
              height: height.clamp(4.0, 30.0),
              margin: EdgeInsets.symmetric(horizontal: 2.toW),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(1.5.toW),
              ),
            );
          }),
        );
      },
    );
  }
}

/// 顶部柱状波形动画
class _VoiceRipple extends StatefulWidget {
  const _VoiceRipple({required this.amplitude});

  final double amplitude;

  @override
  State<_VoiceRipple> createState() => _VoiceRippleState();
}

class _VoiceRippleState extends State<_VoiceRipple>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final int _barCount = 5;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 20.toW,
      height: 20.toW,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: List.generate(_barCount, (index) {
              // 中间最长，两边短：0->0.6, 1->0.8, 2->1.0, 3->0.8, 4->0.6
              final centerFactor = 1.0 - (index - 2).abs() * 0.2;
              final baseHeight = (4.0 + widget.amplitude * 10.0) * centerFactor;
              final phase = (index / _barCount) * 2 * pi;
              final animValue = sin(_controller.value * 2 * pi + phase);
              final height = baseHeight * (0.4 + 0.6 * animValue.abs());

              return Container(
                width: 2.toW,
                height: height.clamp(3.0, 16.0),
                margin: EdgeInsets.symmetric(horizontal: 1.toW),
                decoration: BoxDecoration(
                  color: AppColors.theme,
                  borderRadius: BorderRadius.circular(1.toW),
                ),
              );
            }),
          );
        },
      ),
    );
  }
}
