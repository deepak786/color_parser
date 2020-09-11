# color_parser

A package to parse the color.
This package is inspired from the JS library https://www.w3schools.com/lib/w3color.js

# Usage

Import `import 'package:color_parser/color_parser.dart';`

Example:

```dart
import 'package:color_parser/color_parser.dart';

ColorParser parser;
// there are various ways to instantiate the object

// using RGB
parser = ColorParser.rgb(0, 191, 255);

// using HexCode
parser = ColorParser.hex('#00bfff');

// using ARGB, A = alpha
parser = ColorParser.argb(255, 0, 191, 255);

// using ARGO, O = opacity
parser = ColorParser.rgbo(0, 191, 255, 1);

// using color value
parser = ColorParser.value(0xff00bff);

// using color itself
parser = ColorParser.color(Colors.lightBlueAccent);

// get the info from the object such as

// color name
print(parser.toName()); // e.g. DeepSkyBlue

// material color
Color color = parser.getColor();

// RGB
print(parser.toRGBString()); // e.g. rgb(0, 191, 255)

// Hex
print(parser.toHex()); // e.g. #00bfff

// HSL
print(parser.toHSLString()); // e.g hsl(195, 100%, 50%)

// HWB
print(parser.toHWBString()); // e.g. hwb(195, 0%, 0%)

// CMYK
print(parser.toCMYKString()); // e.g. cmyk(100%, 25%, 0%, 0%)

// Ncol
print(parser.toNcolString()); // e.g. C25, 0%, 0%
```

There are methods available for String representation as well as for values to use in the code.

# Working Demo:
check the working demo at:
https://deepak786.github.io/demo-color-parser/
