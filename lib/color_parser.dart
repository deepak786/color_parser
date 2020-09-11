library color_parser;

import 'dart:math' as Math;

import 'package:flutter/material.dart';

import 'color_names.dart';

/// class to parse the color and get the color value using different approaches
/// such as RGB, HEX etc.
/// inspired from the JS https://www.w3schools.com/lib/w3color.js
class ColorParser {
  /// color
  Color _color;

  /// hue
  num _hue;

  /// saturation
  num _sat;

  /// lightness
  num _lightness;

  /// whiteness
  num _whiteness;

  /// blackness
  num _blackness;

  /// cyan
  num _cyan;

  /// magenta
  num _magenta;

  /// yellow
  num _yellow;

  /// black
  num _black;

  /// Ncol
  String _ncol;

  /// create a object of this class using the RGB values
  ///
  /// r = red value [0-255]
  /// g = green value [0-255]
  /// b = blue value [0-255]
  ///
  /// here the alpha is fully opaque [255]
  ColorParser.rgb(int r, int g, int b) {
    this._color = Color.fromARGB(255, r, g, b);
    _calculateFromRGB();
  }

  /// create a object of this class using the ARGB values
  ///
  /// a = alpha value [0-255], 0 being fully transparent and 255 being fully opaque
  /// r = red value [0-255]
  /// g = green value [0-255]
  /// b = blue value [0-255]
  ColorParser.argb(int a, int r, int g, int b) {
    this._color = Color.fromARGB(a, r, g, b);
    _calculateFromRGB();
  }

  /// create a object of this class using the RGBO values
  ///
  /// r = red value [0-255]
  /// g = green value [0-255]
  /// b = blue value [0-255]
  /// o = opacity as double, with 0.0 being transparent and 1.0 being fully opaque.
  ColorParser.rgbo(int r, int g, int b, double o) {
    this._color = Color.fromRGBO(r, g, b, o);
    _calculateFromRGB();
  }

  /// get the object of this class using material color
  ColorParser.color(Color color) {
    this._color = color;
    _calculateFromRGB();
  }

  /// get the object of this class using int value of color
  ColorParser.value(int value) {
    this._color = Color(value);
    _calculateFromRGB();
  }

  /// get the object of this class using hex color code
  ColorParser.hex(String hexCode) {
    bool startsWithHash = hexCode.startsWith("#");
    this._color = new Color(int.parse(
            hexCode.substring(startsWithHash ? 1 : 0, startsWithHash ? 7 : 6),
            radix: 16) +
        0xFF000000);
    _calculateFromRGB();
  }

  /// calculate values from RGB
  void _calculateFromRGB() {
    List<num> hwb = _calculateHWB(_color.red, _color.green, _color.blue);
    List<num> hsl = _calculateHSL(_color.red, _color.green, _color.blue);
    List<num> cmyk = _calculateCMYK(_color.red, _color.green, _color.blue);

    _hue = num.parse(hsl[0].toStringAsFixed(0));
    _whiteness = num.parse(hwb[1].toStringAsFixed(2));
    _blackness = num.parse(hwb[2].toStringAsFixed(2));
    _sat = num.parse(hsl[1].toStringAsFixed(2));
    _lightness = num.parse(hsl[2].toStringAsFixed(2));
    _cyan = num.parse(cmyk[0].toStringAsFixed(2));
    _magenta = num.parse(cmyk[1].toStringAsFixed(2));
    _yellow = num.parse(cmyk[2].toStringAsFixed(2));
    _black = num.parse(cmyk[3].toStringAsFixed(2));

    _ncol = _hueToNcol(_hue);
  }

  /// calculate the HWB value from RGB
  List<num> _calculateHWB(int red, int green, int blue) {
    num h, w, bl;

    num r = red / 255;
    num g = green / 255;
    num b = blue / 255;

    num max = Math.max(Math.max(r, g), b);
    num min = Math.min(Math.min(r, g), b);
    num chroma = max - min;
    if (chroma == 0) {
      h = 0;
    } else if (r == max) {
      h = (((g - b) / chroma) % 6) * 360;
    } else if (g == max) {
      h = ((((b - r) / chroma) + 2) % 6) * 360;
    } else {
      h = ((((r - g) / chroma) + 4) % 6) * 360;
    }
    w = min;
    bl = 1 - max;

    return [h, w, bl];
  }

  /// calculate HSL from RGB
  List<num> _calculateHSL(int red, int green, int blue) {
    num h, s, l;

    List<num> rgb = [];
    rgb.add(red / 255);
    rgb.add(green / 255);
    rgb.add(blue / 255);

    num min = rgb[0];
    num max = rgb[0];
    num maxColor = 0;

    for (int i = 0; i < rgb.length - 1; i++) {
      if (rgb[i + 1] <= min) {
        min = rgb[i + 1];
      }
      if (rgb[i + 1] >= max) {
        max = rgb[i + 1];
        maxColor = i + 1;
      }
    }
    if (maxColor == 0) {
      h = (rgb[1] - rgb[2]) / (max - min);
    }
    if (maxColor == 1) {
      h = 2 + (rgb[2] - rgb[0]) / (max - min);
    }
    if (maxColor == 2) {
      h = 4 + (rgb[0] - rgb[1]) / (max - min);
    }

    if (h.isNaN) {
      h = 0;
    }
    h = h * 60;
    if (h < 0) {
      h = h + 360;
    }
    l = (min + max) / 2;
    if (min == max) {
      s = 0;
    } else {
      if (l < 0.5) {
        s = (max - min) / (max + min);
      } else {
        s = (max - min) / (2 - max - min);
      }
    }
    return [h, s, l];
  }

  /// calculate CMYK from RGB
  List<num> _calculateCMYK(int red, int green, int blue) {
    num c, m, y, k;
    num r = red / 255;
    num g = green / 255;
    num b = blue / 255;

    num max = Math.max(Math.max(r, g), b);
    k = 1 - max;
    if (k == 1) {
      c = 0;
      m = 0;
      y = 0;
    } else {
      c = (1 - r - k) / (1 - k);
      m = (1 - g - k) / (1 - k);
      y = (1 - b - k) / (1 - k);
    }
    return [c, m, y, k];
  }

  /// calculate Ncol from hue
  String _hueToNcol(num hue) {
    while (hue >= 360) {
      hue = hue - 360;
    }
    if (hue < 60) {
      return "R" + (hue / 0.6).round().toString();
    }
    if (hue < 120) {
      return "Y" + ((hue - 60) / 0.6).round().toString();
    }
    if (hue < 180) {
      return "G" + ((hue - 120) / 0.6).round().toString();
    }
    if (hue < 240) {
      return "C" + ((hue - 180) / 0.6).round().toString();
    }
    if (hue < 300) {
      return "B" + ((hue - 240) / 0.6).round().toString();
    }
    if (hue < 360) {
      return "M" + ((hue - 300) / 0.6).round().toString();
    }

    return "";
  }

  /// get the Color
  Color getColor() {
    return _color;
  }

  /// get RGB
  List<int> toRGB() {
    return [_color.red, _color.green, _color.blue];
  }

  /// RGB string
  String toRGBString() {
    return "rgb(${_color.red}, ${_color.green}, ${_color.blue})";
  }

  /// get RGB with alpha
  List<int> toRGBA() {
    return [_color.red, _color.green, _color.blue, _color.alpha];
  }

  /// RGB string with alpha
  String toRGBAString() {
    return "rgba(${_color.red}, ${_color.green}, ${_color.blue}, ${_color.alpha})";
  }

  /// get HWB
  List<num> toHWB() {
    return [_hue, _whiteness, _blackness];
  }

  /// HWB string
  String toHWBString() {
    return "hwb($_hue, ${(_whiteness * 100).round()}%, ${(_blackness * 100).round()}%)";
  }

  /// HWB string decimal
  String toHWBDecimal() {
    return "hwb($_hue, $_whiteness, $_blackness)";
  }

  /// get HWB with alpha
  List<num> toHWBA() {
    return [_hue, _whiteness, _blackness, _color.alpha];
  }

  /// HWB string with alpha
  String toHWBAString() {
    return "hwba($_hue, ${(_whiteness * 100).round()}%, ${(_blackness * 100).round()}%, ${_color.alpha})";
  }

  /// get HSL
  List<num> toHSL() {
    return [_hue, _sat, _lightness];
  }

  /// HSL string
  String toHSLString() {
    return "hsl($_hue, ${(_sat * 100).round()}%, ${(_lightness * 100).round()}%)";
  }

  /// HSL string decimal
  String toHSLDecimal() {
    return "hsl($_hue, $_sat, $_lightness)";
  }

  /// get HSL with alpha
  List<num> toHSLA() {
    return [
      _hue,
      _sat,
      _lightness,
      _color.alpha,
    ];
  }

  /// HSL string with alpha
  String toHSLAString() {
    return "hsla($_hue, ${(_sat * 100).round()}%, ${(_lightness * 100).round()}%, ${_color.alpha})";
  }

  /// getCMYK
  List<num> toCMYK() {
    return [_cyan, _magenta, _yellow, _black];
  }

  /// CMYK string
  String toCMYKString() {
    return "cmyk(${(_cyan * 100).round()}%, ${(_magenta * 100).round()}%, ${(_yellow * 100).round()}%, ${(_black * 100).round()}%)";
  }

  /// CMYK string decimal
  String toCMYKDecimal() {
    return "cmyk($_cyan, $_magenta, $_yellow, $_black)";
  }

  /// get CMYK with alpha
  List<num> toCMYKA() {
    return [
      _cyan,
      _magenta,
      _yellow,
      _black,
      _color.alpha,
    ];
  }

  /// get NCOL
  List<dynamic> toNcol() {
    return [_ncol, _whiteness, _blackness];
  }

  /// NCOL string
  String toNcolString() {
    return "$_ncol, ${(_whiteness * 100).round()}%, ${(_blackness * 100).round()}%";
  }

  /// NCOL string decimal
  String toNcolDecimal() {
    return "$_ncol, $_whiteness, $_blackness";
  }

  /// get NCOL with alpha
  List<dynamic> toNcolA() {
    return [_ncol, _whiteness, _blackness, _color.alpha];
  }

  /// NCOL string with alpha
  String toNcolAString() {
    return "$_ncol, ${(_whiteness * 100).round()}%, ${(_blackness * 100).round()}%, ${_color.alpha}";
  }

  /// get color name
  String toName() {
    List<String> colorCodes = colorNames.keys.toList();
    for (String code in colorCodes) {
      num r = int.parse(code.substring(0, 2), radix: 16);
      num g = int.parse(code.substring(2, 4), radix: 16);
      num b = int.parse(code.substring(4, 6), radix: 16);

      if (_color.red == r && _color.green == g && _color.blue == b) {
        return colorNames[code];
      }
    }

    return "";
  }

  /// hex string
  String toHex() {
    return "#${_intToHex(_color.red)}${_intToHex(_color.green)}${_intToHex(_color.blue)}";
  }

  /// convert int value to hex
  String _intToHex(int value) {
    String hex = value.toRadixString(16);
    while (hex.length < 2) {
      hex = "0" + hex;
    }
    return hex;
  }
}
