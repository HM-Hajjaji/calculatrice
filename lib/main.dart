import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() => runApp(const CalculatriceApp());

class CalculatriceApp extends StatelessWidget {
  const CalculatriceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: CalculatriceScreen(title: "Calculatrice"));
  }
}

class CalculatriceScreen extends StatefulWidget {
  final String title;

  const CalculatriceScreen({super.key, required this.title});

  @override
  State<CalculatriceScreen> createState() => _CalculatriceScreenState();
}

class _CalculatriceScreenState extends State<CalculatriceScreen> {
  //====== Properties =========
  String _equation = "0";
  dynamic _result = 0;

  final Parser _parser = Parser();
  final ContextModel _contextModel = ContextModel();

  final List<String> _expressions = ["C", "⌫", "="];

  void _clear() {
    (_equation = "0", _result = 0);
  }

  void _backSpace() {
    _equation = _equation.substring(0, _equation.length - 1);
    if (_equation.isEmpty) {
      _equation = "0";
    }
  }

  void _calculateResult() {
    _result = _parser.parse(_equation.replaceAll("÷", "/").replaceAll("×", "*")).evaluate(EvaluationType.REAL, _contextModel);
  }

  void _onButtonPressed(String text) {
    setState(() {
      if (!_expressions.contains(text)) {
        _equation += text;
        if (_equation.startsWith("0")) {
          _equation = _equation.substring(1);
        }
      }

      switch (text) {
        case "C":
          _clear();
          break;
        case "⌫":
          _backSpace();
          break;
        case "=":
          _calculateResult();
          break;
      }
    });
  }

  Widget createButton(String text,
      {Color textColor = Colors.blue, Color buttonBg = Colors.white}) {
    return Container(
        color: buttonBg,
        height: MediaQuery.of(context).size.height * 0.1,
        child: MaterialButton(
          onPressed: () => _onButtonPressed(text),
          child: Text(text,
              style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.normal,
                  fontSize: 30)),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title,
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 5),
            child: Text(
              _equation,
              style: const TextStyle(fontSize: 35),
            ),
          ),
          Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: Text(
              _result.toString(),
              style: const TextStyle(fontSize: 25),
            ),
          ),
          const Expanded(child: Divider()),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                child: Table(
                  children: [
                    TableRow(children: [
                      createButton("C", textColor: Colors.red),
                      createButton("⌫"),
                      createButton("%"),
                      createButton("÷")
                    ]),
                    TableRow(children: [
                      createButton("7"),
                      createButton("8"),
                      createButton("9"),
                      createButton("×")
                    ]),
                    TableRow(children: [
                      createButton("4"),
                      createButton("5"),
                      createButton("6"),
                      createButton("-")
                    ]),
                    TableRow(children: [
                      createButton("1"),
                      createButton("2"),
                      createButton("3"),
                      createButton("+")
                    ]),
                    TableRow(children: [
                      createButton("."),
                      createButton("0"),
                      createButton("00"),
                      createButton("=",
                          textColor: Colors.white, buttonBg: Colors.blue)
                    ]),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}