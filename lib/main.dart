import 'package:flutter/material.dart'; 

 

void main() { 

  runApp(const ConversionApp()); 

} 

 

/// Root widget for the conversion application. 

class ConversionApp extends StatelessWidget { 

  const ConversionApp({super.key}); 

 

  @override 

  Widget build(BuildContext context) { 

    return MaterialApp( 

      debugShowCheckedModeBanner: false, 

      title: 'Conversion App', 

      theme: ThemeData( 

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue), 

        useMaterial3: true, 

      ), 

      home: const ConversionPage(), 

    ); 

  } 

} 

 

/// Main page where users enter values and select measurement units. 

class ConversionPage extends StatefulWidget { 

  const ConversionPage({super.key}); 

 

  @override 

  State<ConversionPage> createState() => _ConversionPageState(); 

} 

 

class _ConversionPageState extends State<ConversionPage> { 

  final TextEditingController _valueController = TextEditingController(); 

 

  String _category = 'Distance'; 

  String _fromUnit = 'Kilometers'; 

  String _toUnit = 'Miles'; 

  String _result = ''; 

 

  final Map<String, List<String>> _units = { 

    'Distance': ['Kilometers', 'Meters', 'Miles', 'Feet'], 

    'Weight': ['Kilograms', 'Grams', 'Pounds', 'Ounces'], 

  }; 

 

  @override 

  void dispose() { 

    _valueController.dispose(); 

    super.dispose(); 

  } 

 

  /// Performs conversion using a common base unit for each category. 

  void _convert() { 

    final value = double.tryParse(_valueController.text.trim()); 

 

    if (value == null) { 

      setState(() { 

        _result = 'Please enter a valid number.'; 

      }); 

      return; 

    } 

 

    final converted = _category == 'Distance' 

        ? _convertDistance(value, _fromUnit, _toUnit) 

        : _convertWeight(value, _fromUnit, _toUnit); 

 

    setState(() { 

      _result = '${_format(converted)} $_toUnit'; 

    }); 

  } 

 

  double _convertDistance(double value, String from, String to) { 

    // Convert the source value to meters first. 

    double meters; 

 

    switch (from) { 

      case 'Kilometers': 

        meters = value * 1000; 

        break; 

      case 'Miles': 

        meters = value * 1609.344; 

        break; 

      case 'Feet': 

        meters = value * 0.3048; 

        break; 

      default: 

        meters = value; 

    } 

 

    // Convert meters to the requested destination unit. 

    switch (to) { 

      case 'Kilometers': 

        return meters / 1000; 

      case 'Miles': 

        return meters / 1609.344; 

      case 'Feet': 

        return meters / 0.3048; 

      default: 

        return meters; 

    } 

  } 

 

  double _convertWeight(double value, String from, String to) { 

    // Convert the source value to grams first. 

    double grams; 

 

    switch (from) { 

      case 'Kilograms': 

        grams = value * 1000; 

        break; 

      case 'Pounds': 

        grams = value * 453.59237; 

        break; 

      case 'Ounces': 

        grams = value * 28.349523125; 

        break; 

      default: 

        grams = value; 

    } 

 

    // Convert grams to the requested destination unit. 

    switch (to) { 

      case 'Kilograms': 

        return grams / 1000; 

      case 'Pounds': 

        return grams / 453.59237; 

      case 'Ounces': 

        return grams / 28.349523125; 

      default: 

        return grams; 

    } 

  } 

 

  String _format(double value) { 

    return value.toStringAsFixed(4).replaceFirst(RegExp(r'\.?0+$'), ''); 

  } 

 

  void _reset() { 

    setState(() { 

      _valueController.clear(); 

      _category = 'Distance'; 

      _fromUnit = 'Kilometers'; 

      _toUnit = 'Miles'; 

      _result = ''; 

    }); 

  } 

 

  @override 

  Widget build(BuildContext context) { 

    final availableUnits = _units[_category]!; 

 

    return Scaffold( 

      appBar: AppBar( 

        title: const Text('Unit Conversion'), 

        centerTitle: true, 

      ), 

      body: SafeArea( 

        child: SingleChildScrollView( 

          padding: const EdgeInsets.all(20), 

          child: Column( 

            crossAxisAlignment: CrossAxisAlignment.stretch, 

            children: [ 

              const Text( 

                'Metric & Imperial Converter', 

                style: TextStyle( 

                  fontSize: 26, 

                  fontWeight: FontWeight.bold, 

                ), 

              ), 

              const SizedBox(height: 8), 

              const Text( 

                'Convert distance and weight between commonly used units.', 

              ), 

              const SizedBox(height: 24), 

 

              DropdownButtonFormField<String>( 

                value: _category, 

                decoration: const InputDecoration( 

                  labelText: 'Measurement', 

                  border: OutlineInputBorder(), 

                ), 

                items: _units.keys 

                    .map( 

                      (category) => DropdownMenuItem( 

                        value: category, 

                        child: Text(category), 

                      ), 

                    ) 

                    .toList(), 

                onChanged: (value) { 

                  if (value == null) return; 

                  setState(() { 

                    _category = value; 

                    _fromUnit = _units[value]!.first; 

                    _toUnit = _units[value]!.last; 

                    _result = ''; 

                  }); 

                }, 

              ), 

              const SizedBox(height: 16), 

 

              TextField( 

                controller: _valueController, 

                keyboardType: const TextInputType.numberWithOptions( 

                  decimal: true, 

                  signed: true, 

                ), 

                decoration: const InputDecoration( 

                  labelText: 'Enter value', 

                  border: OutlineInputBorder(), 

                  hintText: 'Example: 10', 

                ), 

              ), 

              const SizedBox(height: 16), 

 

              DropdownButtonFormField<String>( 

                value: _fromUnit, 

                decoration: const InputDecoration( 

                  labelText: 'From', 

                  border: OutlineInputBorder(), 

                ), 

                items: availableUnits 

                    .map( 

                      (unit) => DropdownMenuItem( 

                        value: unit, 

                        child: Text(unit), 

                      ), 

                    ) 

                    .toList(), 

                onChanged: (value) { 

                  if (value != null) { 

                    setState(() => _fromUnit = value); 

                  } 

                }, 

              ), 

              const SizedBox(height: 16), 

 

              DropdownButtonFormField<String>( 

                value: _toUnit, 

                decoration: const InputDecoration( 

                  labelText: 'To', 

                  border: OutlineInputBorder(), 

                ), 

                items: availableUnits 

                    .map( 

                      (unit) => DropdownMenuItem( 

                        value: unit, 

                        child: Text(unit), 

                      ), 

                    ) 

                    .toList(), 

                onChanged: (value) { 

                  if (value != null) { 

                    setState(() => _toUnit = value); 

                  } 

                }, 

              ), 

              const SizedBox(height: 24), 

 

              FilledButton.icon( 

                onPressed: _convert, 

                icon: const Icon(Icons.calculate), 

                label: const Text('Convert'), 

              ), 

              const SizedBox(height: 12), 

 

              OutlinedButton( 

                onPressed: _reset, 

                child: const Text('Reset'), 

              ), 

              const SizedBox(height: 24), 

 

              if (_result.isNotEmpty) 

                Card( 

                  child: Padding( 

                    padding: const EdgeInsets.all(20), 

                    child: Column( 

                      children: [ 

                        const Text( 

                          'Converted Result', 

                          style: TextStyle( 

                            fontSize: 16, 

                            fontWeight: FontWeight.w600, 

                          ), 

                        ), 

                        const SizedBox(height: 8), 

                        Text( 

                          _result, 

                          textAlign: TextAlign.center, 

                          style: const TextStyle( 

                            fontSize: 28, 

                            fontWeight: FontWeight.bold, 

                          ), 

                        ), 

                      ], 

                    ), 

                  ), 

                ), 

            ], 

          ), 

        ), 

      ), 

    ); 

  } 

}
