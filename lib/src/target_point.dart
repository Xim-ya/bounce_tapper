part of 'zoom_tapper.dart';

/// A variable to track the pointer's unique identifier during a touch event.
/// This helps to ensure that only the current touch event (represented by a pointer ID)
/// controls the shrink and grow animations. It is used to prevent multiple simultaneous touch events
/// from triggering conflicting animations.
int? _targetPoint;
