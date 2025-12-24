part of 'widget.dart';

class HandleBar extends StatelessWidget {
  const HandleBar({
    Key? key,
    this.decoration,
    this.margin = const EdgeInsets.only(top: 2),
    this.onPressed,
    this.animationController,
  }) : super(key: key);

  final BoxDecoration? decoration;
  final EdgeInsetsGeometry margin;
  final VoidCallback? onPressed;
  final AnimationController? animationController;

  @override
  Widget build(BuildContext context) {
    if (animationController == null) {
      return const SizedBox.shrink();
    }
    // 根据动画值判断是否展开，使用 >= 0.5 更准确
    return GestureDetector(
      onTap: onPressed,
      behavior: HitTestBehavior.translucent,
      child: Container(
        margin: margin,
        alignment: Alignment.center,
        child: AnimatedBuilder(
          animation: animationController!,
          builder: (context, child) {
            final isOpen = animationController!.value >= 0.5;
            return Transform.rotate(
              angle: !isOpen ? pi / 2 : -pi / 2,
              child: Icon(
                Icons.arrow_forward_ios,
                size: 17,
                color: const Color(0x55000000),
              ),
            );
          },
        ),
      ),
    );
  }
}
