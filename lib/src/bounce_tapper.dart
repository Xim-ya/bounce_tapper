import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

part 'bounce_tapper_event.dart';

part 'target_point.dart';

class BounceTapper extends StatefulWidget {
  const BounceTapper({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.onLongPressUp,
    this.shrinkScaleFactor = 0.965,
    this.shrinkCurve = Curves.easeInSine,
    this.growCurve = Curves.easeOutSine,
    this.shrinkDuration = const Duration(milliseconds: 160),
    this.growDuration = const Duration(milliseconds: 120),
    this.delayedDurationBeforeGrow = const Duration(milliseconds: 60),
    this.highlightBorderRadius,
    this.highlightColor = const Color(0x1F939BAC),
    this.enable = true,
    this.blockTapOnLongPressEvent = true,
    this.disableBounceOnScroll = true,
  }) : assert(shrinkScaleFactor > 0 && shrinkScaleFactor <= 1,
            'shrinkScaleFactor must be greater than 0 and less than or equal to 1');

  /// The child widget that will have the shrink/grow animation applied.
  final Widget child;

  /// Callback methods for various touch interactions.
  final Function()? onTap, onLongPress, onLongPressUp;

  /// The closer to 0, the more it will shrink.
  /// Values between 0 and 1 (exclusive) are valid.
  final double shrinkScaleFactor;

  /// The curve for shrink and grow animations.
  final Curve shrinkCurve, growCurve;

  /// The duration for the shrink and grow animations.
  final Duration shrinkDuration, growDuration;

  /// Delay before the grow animation starts after the shrink animation completes.
  ///
  /// You can set it to [Duration.zero] to remove the delay, but a small delay provides a smoother effect.
  final Duration delayedDurationBeforeGrow;

  /// Whether the shrink and grow animations are enabled.
  ///
  /// Set this to [false] to disable the animation.
  final bool enable;

  /// Border radius for the highlight overlay widget.
  final BorderRadius? highlightBorderRadius;

  /// Color that will be highlighted when the widget is tapped.
  final Color highlightColor;

  /// Whether to enable grow animation when scrolling.
  ///
  /// If true, the grow animation will be disabled while scrolling.
  final bool disableBounceOnScroll;

  /// Controls whether a tap event is blocked if a long press event occurs.
  ///
  /// If set to [true], the tap event will not be triggered after a long press.
  final bool blockTapOnLongPressEvent;

  @override
  State<StatefulWidget> createState() => _BounceTapperState();
}

class _BounceTapperState extends State<BounceTapper>
    with SingleTickerProviderStateMixin<BounceTapper>, _Event {
  /// Animation controller to manage animation states.
  late final AnimationController _controller;

  /// The shrink and grow animation value.
  late final Animation<double> _animation;

  /// Key for the touch area widget.
  final GlobalKey _touchAreaKey = GlobalKey();

  /// Size of the touchable area.
  Size touchAreaSize = Size.zero;

  /// Target border radius for the child widget.
  BorderRadiusGeometry? autoDetectedRadius;

  @override
  void initState() {
    super.initState();

    // Initialize the animation controller and the animation with given curves and durations.
    _controller = AnimationController(
      vsync: this,
      duration: widget.shrinkDuration,
      reverseDuration: widget.growDuration,
    );
    _animation = Tween(begin: 1.0, end: widget.shrinkScaleFactor).animate(
      CurvedAnimation(
        parent: _controller,
        curve: widget.shrinkCurve,
        reverseCurve: widget.growCurve,
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Get the target border radius after the frame is rendered.
      if (widget.highlightBorderRadius == null) {
        autoDetectedRadius = getChildBorderCloseBorderRadius(context);
      }

      // Measure the size of the touch area.
      if (_touchAreaKey.currentContext != null) {
        touchAreaSize = _touchAreaKey.currentContext!.size ?? Size.zero;
      }

      // Listen for scroll events to trigger the grow animation if enabled.
      if (Scrollable.maybeOf(context)?.widget.controller != null &&
          widget.disableBounceOnScroll) {
        Scrollable.of(context).widget.controller!.addListener(
          () async {
            if (!widget.enable ||
                !_controller.isCompleted ||
                _targetPoint == null) return;

            await _controller.reverse();
            _targetPoint = null;
          },
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        if (!widget.enable) return;
        widget.onLongPress?.call();
        if (widget.enable &&
            widget.onLongPressUp != null &&
            widget.blockTapOnLongPressEvent) {
          _targetPoint = (_targetPoint ?? 0) - 2;
        }
      },
      onLongPressUp: () async {
        if (!widget.enable) return;
        Future.value(widget.onLongPressUp?.call()).whenComplete(() async {
          if (widget.onLongPressUp != null && widget.blockTapOnLongPressEvent) {
            await _controller.reverse();
            _targetPoint = null;
          }
        });
      },
      child: Listener(
        /// When a pointer moves within the widget.
        /// If the pointer moves outside the touch area, trigger the grow animation.
        onPointerMove: (event) async {
          if (!widget.enable) return;

          if (!isWithinBounds(
              position: event.localPosition, touchAreaSize: touchAreaSize)) {
            if (_controller.isCompleted) {
              await _controller.reverse();
              _targetPoint = null;
            }
          }
        },

        /// When a pointer touches the display.
        /// Start the shrink animation.
        onPointerDown: (event) async {
          print(event.pointer - (_targetPoint ?? 0) < 4);
          if (!widget.enable ||
              (_targetPoint != null &&
                  event.pointer - (_targetPoint ?? 0) < 4) ||
              _controller.isAnimating) {
            return;
          }

          _targetPoint = event.pointer;
          _controller.forward();
        },

        /// When a pointer is lifted from the display.
        /// If lifted within the touch area, trigger the onTap callback and grow animation.
        onPointerUp: (event) async {
          if (!widget.enable ||
              _controller.isDismissed ||
              _targetPoint != event.pointer) return;

          // Wait for the shrink animation to finish before starting the grow animation.
          await _controller.forward();
          await Future.delayed(widget.delayedDurationBeforeGrow);

          _controller.reverse();

          // If the pointer was lifted within the bounds of the touch area, trigger the onTap callback.
          if (isWithinBounds(
            position: event.localPosition,
            touchAreaSize: touchAreaSize,
          )) {
            await Future.value(widget.onTap?.call()).whenComplete(() {
              _targetPoint = null;
            });
            return;
          }

          await _controller.reverse();
          _targetPoint = null;
        },

        /// Build the widget with the shrink/grow animation applied.
        child: AnimatedBuilder(
          animation: _animation,
          child: widget.child,
          builder: (context, child) {
            return Transform.scale(
              key: _touchAreaKey,
              alignment: Alignment.center,
              scale: widget.enable ? _animation.value : 1.0,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // The child widget.
                  child!,

                  // Highlight color overlay.
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: widget.highlightBorderRadius ??
                          autoDetectedRadius ??
                          BorderRadius.zero,
                      child: IgnorePointer(
                        child: AnimatedBuilder(
                          animation: _animation,
                          builder: (context, child) {
                            final opacity =
                                _animation.value == widget.shrinkScaleFactor
                                    ? 1.0
                                    : (1.0 - _animation.value) /
                                        (1.0 - widget.shrinkScaleFactor);
                            return Opacity(
                              opacity: opacity,
                              child: ColoredBox(
                                color: widget.highlightColor,
                              ),
                            );
                          },
                        ),
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

  @override
  void dispose() {
    _controller.stop();
    _controller.dispose();
    super.dispose();
  }
}
