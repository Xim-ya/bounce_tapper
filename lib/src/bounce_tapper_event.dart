part of 'bounce_tapper.dart';

mixin class _Event {
  /// Checks if a pointer is within the bounds of the touch area.
  bool isWithinBounds({required Offset position, required Size touchAreaSize}) {
    return !(position.dx <= 0 ||
        position.dx >= touchAreaSize.width ||
        position.dy <= 0 ||
        position.dy >= touchAreaSize.height);
  }

  /// Finds the closest [BorderRadius] of a child widget within the widget tree.
  /// This method traverses the widget tree to find and return the closest non-zero [BorderRadius].
  BorderRadiusGeometry? getChildBorderCloseBorderRadius(BuildContext context) {
    try {
      BorderRadiusGeometry? closestBorderRadius;

      void inspectElement(Element element) {
        final renderObject = element.renderObject;
        if (renderObject is RenderBox) {
          final renderInfo = _getRenderInfoFromRenderObject(renderObject);
          if (context.size == renderInfo.size &&
              renderInfo.borderRadius != null &&
              renderInfo.borderRadius != BorderRadius.zero) {
            closestBorderRadius = renderInfo.borderRadius;
            return;
          }
        }

        element.visitChildren((childElement) {
          inspectElement(childElement);
          if (closestBorderRadius != null) return;
        });
      }

      final rootElement = context as Element;
      inspectElement(rootElement);

      return closestBorderRadius;
    } catch (e) {
      log('An issue occurred while retrieving the borderRadius of the target widget. This might be due to an unexpected error or require updates for compatibility with the Flutter version. $e');
      return null;
    }
  }

  /// Extracts BorderRadius from various types of RenderBox.
  ({Size size, BorderRadiusGeometry? borderRadius})
      _getRenderInfoFromRenderObject(RenderBox renderObject) {
    if (renderObject is RenderClipRRect) {
      return (size: renderObject.size, borderRadius: renderObject.borderRadius);
    }
    if (renderObject is RenderPhysicalModel) {
      return (size: renderObject.size, borderRadius: renderObject.borderRadius);
    }
    if (renderObject is RenderDecoratedBox) {
      final decoration = renderObject.decoration;
      if (decoration is BoxDecoration) {
        return (size: renderObject.size, borderRadius: decoration.borderRadius);
      } else if (decoration is ShapeDecoration) {
        final shape = decoration.shape;
        if (shape is RoundedRectangleBorder) {
          return (size: renderObject.size, borderRadius: shape.borderRadius);
        }
      }
    }
    if (renderObject is RenderPhysicalShape) {
      final CustomClipper<Path>? clipper = renderObject.clipper;
      if (clipper is ShapeBorderClipper) {
        final shape = clipper.shape;
        if (shape is RoundedRectangleBorder) {
          return (size: renderObject.size, borderRadius: shape.borderRadius);
        }
      }
    }
    return (size: renderObject.size, borderRadius: null);
  }

  /// Resets the process configuration settings for the bounce animation widget.
  void resetProcessConfigs(_BounceTapperState widget) {
    widget._longPressTimer?.cancel();
    widget._isLongPressed = false;
    _targetPoint = null;
  }
}
