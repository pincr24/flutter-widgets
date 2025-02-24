import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/src/chart/common/common.dart';
import '../common/renderer.dart';
import '../common/segment_properties.dart';
import '../utils/helper.dart';
import 'chart_segment.dart';

/// Creates the segments for spline area series.
///
/// Generates the spline area series points and has the [calculateSegmentPoints] method overrided to customize
/// the spline area segment point calculation.
///
/// Gets the path and color from the `series`.
class SplineAreaSegment extends ChartSegment {
  late SegmentProperties _segmentProperties;
  bool _isInitialize = false;

  /// Gets the color of the series.
  @override
  Paint getFillPaint() {
    _setSegmentProperties();
    fillPaint = Paint();
    if (_segmentProperties.series.gradient == null) {
      if (_segmentProperties.color != null) {
        fillPaint!.color = _segmentProperties.color!;
        fillPaint!.style = PaintingStyle.fill;
      }
    } else {
      fillPaint = (_segmentProperties.pathRect != null)
          ? getLinearGradientPaint(
              _segmentProperties.series.gradient!,
              _segmentProperties.pathRect!,
              _segmentProperties.stateProperties.requireInvertedAxis)
          : fillPaint;
    }
    assert(_segmentProperties.series.opacity >= 0 == true,
        'The opacity value of the spline area series should be greater than or equal to 0.');
    assert(_segmentProperties.series.opacity <= 1 == true,
        'The opacity value of the spline area series should be less than or equal to 1.');
    fillPaint!.color = (_segmentProperties.series.opacity < 1 == true &&
            fillPaint!.color != Colors.transparent)
        ? fillPaint!.color.withOpacity(_segmentProperties.series.opacity)
        : fillPaint!.color;
    _segmentProperties.defaultFillColor = fillPaint;
    setShader(_segmentProperties, fillPaint!);
    return fillPaint!;
  }

  /// Gets the border color of the series.
  @override
  Paint getStrokePaint() {
    _setSegmentProperties();
    final Paint strokePaint = Paint();
    strokePaint
      ..style = PaintingStyle.stroke
      ..strokeWidth = _segmentProperties.series.borderWidth;
    if (_segmentProperties.series.borderGradient != null) {
      strokePaint.shader = _segmentProperties.series.borderGradient!
          .createShader(_segmentProperties.strokePath!.getBounds());
    } else if (_segmentProperties.strokeColor != null) {
      strokePaint.color = _segmentProperties.series.borderColor;
    }
    _segmentProperties.series.borderWidth == 0
        ? strokePaint.color = Colors.transparent
        : strokePaint.color;
    strokePaint.strokeCap = StrokeCap.round;
    _segmentProperties.defaultStrokeColor = strokePaint;
    return strokePaint;
  }

  /// Calculates the rendering bounds of a segment.
  @override
  void calculateSegmentPoints() {}

  /// Draws segment in series bounds.
  @override
  void onPaint(Canvas canvas) {
    _setSegmentProperties();
    _segmentProperties.pathRect = _segmentProperties.path.getBounds();
    canvas.drawPath(
        _segmentProperties.path,
        (_segmentProperties.series.gradient == null)
            ? fillPaint!
            : getFillPaint());
    drawDashedLine(canvas, _segmentProperties.series.dashArray, strokePaint!,
        _segmentProperties.strokePath!);
  }

  /// Method to set segment properties
  void _setSegmentProperties() {
    if (!_isInitialize) {
      _segmentProperties = SegmentHelper.getSegmentProperties(this);
      _isInitialize = true;
    }
  }
}
