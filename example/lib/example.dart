import 'package:color_parser/color_parser.dart';
import 'package:flutter/material.dart';

class Example extends StatefulWidget {
  @override
  _ExampleState createState() => _ExampleState();
}

class _ExampleState extends State<Example> {
  ColorParser _parser;
  TextEditingController _controller;
  String _error = "";

  @override
  void initState() {
    // initially use this color
    String code = "#00bfff";
    _parser = ColorParser.hex(code);
    _controller = TextEditingController(text: code);

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// parse the color
  void _parseColor() {
    try {
      setState(() {
        _parser = ColorParser.hex(_controller.text);
        _error = "";
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _parser = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      body: Center(
        child: Container(
          color: Colors.white,
          constraints: BoxConstraints(
            maxWidth: 700,
          ),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: EdgeInsets.all(16),
                  children: [
                    Text(
                      "Enter Color Hex Code",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      "For this example I have used hex code only, but there are several options to parse the color.\ncheck the documentation.",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black45,
                      ),
                    ),
                    SizedBox(height: 5),
                    TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: "hex code e.g (#00bfff)",
                      ),
                    ),
                    if (_error.isNotEmpty)
                      // show the error
                      Text(
                        _error,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.red,
                        ),
                      ),
                    SizedBox(height: 5),
                    RaisedButton(
                      onPressed: _parseColor,
                      color: Theme.of(context).primaryColor,
                      child: Text(
                        "Parse Color",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    SizedBox(height: 40),
                    // show the parsed values
                    parsedData(),
                  ],
                ),
              ),
              // flutter love
              Text(
                "Made with ❤️ in Flutter \n",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black26,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// display the parsed data from parser
  Widget parsedData() {
    if (_parser == null) return Container();

    return Column(
      children: [
        getRow("Name", _parser.toName()),
        divider(),
        Padding(
          padding: const EdgeInsets.only(top: 5, bottom: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  "Color",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  height: 100,
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: SizedBox(
                      width: 100,
                      height: 100,
                      child: Container(color: _parser.getColor()),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        divider(),
        getRow("RGB", _parser.toRGBString()),
        divider(),
        getRow("Hex", _parser.toHex()),
        divider(),
        getRow("HSL", _parser.toHSLString()),
        divider(),
        getRow("HWB", _parser.toHWBString()),
        divider(),
        getRow("CMYK", _parser.toCMYKString()),
        divider(),
        getRow("Ncol", _parser.toNcolString()),
      ],
    );
  }

  /// get the row
  Widget getRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(top: 5, bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// divider
  Widget divider() {
    return Container(
      height: 0.5,
      color: Colors.black26,
    );
  }
}
