import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';

/// 录音界面覆盖层：显示波形动画和提示文字
class VoiceRecordingOverlay extends StatelessWidget {
  const VoiceRecordingOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();
    
    return Obx(() {
      if (!controller.isRecording.value) {
        return const SizedBox.shrink();
      }
      
      return Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: Container(
          height: 140,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.white,
                Color(0xFF4A90E2), // 蓝色
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),
              // 提示文字
              Text(
                controller.isCancelMode.value ? '松开取消' : '松手发送,上移取消',
                style: TextStyle(
                  color: controller.isCancelMode.value 
                      ? Colors.red.shade300 
                      : Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 10),
              // 波形动画 - 固定高度避免文字抖动
              SizedBox(
                height: 36,
                child: Center(
                  child: _WaveformAnimation(amplitude: controller.recordingAmplitude.value),
                ),
              ),
              const Spacer(flex: 3),
            ],
          ),
        ),
      );
    });
  }
}

/// 波形动画组件：根据录音振幅显示动态波形
class _WaveformAnimation extends StatefulWidget {
  const _WaveformAnimation({required this.amplitude});

  final double amplitude;

  @override
  State<_WaveformAnimation> createState() => _WaveformAnimationState();
}

class _WaveformAnimationState extends State<_WaveformAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<double> _waveHeights = List.generate(20, (_) => 0.0);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(_WaveformAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.amplitude != oldWidget.amplitude) {
      _updateWaveHeights();
    }
  }

  void _updateWaveHeights() {
    final baseHeight = 4.0 + widget.amplitude * 20.0;
    final random = Random();
    
    for (int i = 0; i < _waveHeights.length; i++) {
      // 中心波峰效果
      final distanceFromCenter = (i - _waveHeights.length / 2).abs();
      final factor = 1.0 - (distanceFromCenter / (_waveHeights.length / 2));
      final variation = random.nextDouble() * 0.3 + 0.7;
      _waveHeights[i] = baseHeight * factor * variation;
    }
  }

  @override
  Widget build(BuildContext context) {
    _updateWaveHeights();
    
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: List.generate(
            _waveHeights.length,
            (index) {
              final height = _waveHeights[index];
              final phase = (index / _waveHeights.length) * 2 * pi;
              final animatedHeight = height * (0.7 + 0.3 * sin(_controller.value * 2 * pi + phase));
              
              return Container(
                width: 4,
                height: animatedHeight.clamp(6.0, 30.0),
                margin: const EdgeInsets.symmetric(horizontal: 2.5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(2),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

