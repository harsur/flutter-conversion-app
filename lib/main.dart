import 'package:flutter/material.dart';

void main() {
  runApp(const MeasuresConverterApp());
}

class MeasuresConverterApp extends StatelessWidget {
  const MeasuresConverterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Measures Converter',
      home: const ConverterPage(),
    );
  }
}

class ConverterPage extends StatefulWidget {
  const ConverterPage({super.key});

  @override
  State<ConverterPage> createState() => _ConverterPageState();
}

class _ConverterPageState extends State<ConverterPage> {
  final controller = TextEditingController(text: '100');

  String from = 'Meters';
  String to = 'Feet';
  String result = '100 Meters = 328.084 Feet';

  final units = ['Meters', 'Feet', 'Kilometers', 'Miles', 'Kilograms', 'Pounds'];

  void convert() {
    double? value = double.tryParse(controller.text);

    if (value == null) {
      setState(() => result = 'Please enter a valid number');
      return;
    }

    double converted = value;

    if (from == 'Meters' && to == 'Feet') converted = value * 3.28084;
    if (from == 'Feet' && to == 'Meters') converted = value / 3.28084;
    if (from == 'Kilometers' && to == 'Miles') converted = value * 0.621371;
    if (from == 'Miles' && to == 'Kilometers') converted = value * 1.60934;
    if (from == 'Kilograms' && to == 'Pounds') converted = value * 2.20462;
    if (from == 'Pounds' && to == 'Kilograms') converted = value / 2.20462;

    setState(() {
      result = '$value $from = ${converted.toStringAsFixed(3)} $to';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Measures Converter'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          children: [
            const Text('Value', style: TextStyle(fontSize: 28)),
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),

            const Text('From', style: TextStyle(fontSize: 28)),
            DropdownButton<String>(
              value: from,
              isExpanded: true,
              items: units.map((u) {
                return DropdownMenuItem(value: u, child: Text(u));
              }).toList(),
              onChanged: (v) => setState(() => from = v!),
            ),

            const SizedBox(height: 20),

            const Text('To', style: TextStyle(fontSize: 28)),
            DropdownButton<String>(
              value: to,
              isExpanded: true,
              items: units.map((u) {
                return DropdownMenuItem(value: u, child: Text(u));
              }).toList(),
              onChanged: (v) => setState(() => to = v!),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: convert,
              child: const Text('Convert'),
            ),

            const SizedBox(height: 25),

            Text(
              result,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 22),
            ),
          ],
        ),
      ),
    );
  }
}
