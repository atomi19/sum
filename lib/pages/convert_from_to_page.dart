import 'package:flutter/material.dart';
import 'package:sum/utils/convert_utils.dart';
import 'package:sum/widgets/calc_widgets.dart';
import 'package:sum/utils/calculator_utils.dart';

class ConvertFromToPage extends StatefulWidget {
  final String conversionType;

  const ConvertFromToPage({
    super.key,
    required this.conversionType,
  });

  @override
  State<ConvertFromToPage> createState() => _ConvertFromToPageState();
}

class _ConvertFromToPageState extends State<ConvertFromToPage> {
  final TextEditingController _convertController = TextEditingController();
  int _selectedCardIndex = 0; 
  String _selectedUnit = '';
  String _currentUnitType = '';
  Map<String, String> unitResults = {}; // store results of conversion to all units
  final List<String> _dataUnits = ['Bit', 'Byte', 'Kibibyte', 'Mebibyte', 'Gibibyte', 'Tebibyte'];
  final List<String> _lengthUnits = ['Millimeter', 'Centimeter', 'Meter', 'Kilometer'];
  final List<String> _powerUnits = ['Watt', 'Kilowatt', 'Mechanical horsepower', 'Metric horsepower'];
  final List<String> _temperatureUnits = ['Celsius', 'Fahrenheit', 'Kelvin'];
  final List<String> _timeUnits = ['Millisecond', 'Second', 'Minute', 'Hour', 'Day', 'Week', 'Month', 'Year'];
  final List<String> _weightUnits = ['Milligram', 'Gram', 'Kilogram', 'Tonne'];

  @override
  void initState() {
    super.initState();
    // default selected unit 
    final units = _getSelectedUnits();
    if(units.isNotEmpty) {
      _selectedUnit = units[0];
      _selectedCardIndex = 0;
    }
  }

  // choose specific conversion type based on unit category 
  // selected from convert_tab  
  List<String> _getSelectedUnits() {
    switch(widget.conversionType.toLowerCase()) {
      case 'data':
        _currentUnitType = 'data';
        return _dataUnits;
      case 'length':
        _currentUnitType = 'length';
        return _lengthUnits;
      case 'power':
        _currentUnitType = 'power';
        return _powerUnits;
      case 'temperature':
        _currentUnitType = 'temperature';
        return _temperatureUnits;
      case 'time':
        _currentUnitType = 'time';
        return _timeUnits;
      case 'weight':
        _currentUnitType = 'weight';
        return _weightUnits;
      default:
        return [];
    }
  }

  // triggers when calculator button is pressed
  void _onButtonPressed({required value}) {
    _convertController.text += value;
    onValueChanged();
  }

  // function that triggers on convertController value changed
  void onValueChanged() {
    setState(() {
      final String expression = _convertController.text.trim();

      final result = solveExpression(expression: expression);
      final double value = double.tryParse(result) ?? 0;
      unitResults.clear();

      for (var unit in _getSelectedUnits()) {
        try {
          switch (_currentUnitType) {
            case 'data':
              final result = convert(value, _selectedUnit, unit, UnitType.data);
              unitResults[unit] = result.toString();
              break;
            case 'length':
              final result = convert(value, _selectedUnit, unit, UnitType.length);
              unitResults[unit] = result.toString();
              break;
            case 'power':
              final result = convert(value, _selectedUnit, unit, UnitType.power);
              unitResults[unit] = result.toString();
              break;
            case 'temperature':
              final result = convertTemperature(value, _selectedUnit, unit);
              unitResults[unit] = result.toString();
              break;
            case 'time':
              final result = convert(value, _selectedUnit, unit, UnitType.time);
              unitResults[unit] = result.toString();
              break;
            case 'weight':
              final result = convert(value, _selectedUnit, unit, UnitType.weight);
              unitResults[unit] = result.toString();
              break;
            default:
          }
        } catch (e) {
          unitResults[unit] = 'Error';
        }
      }
    });
  }

  String _getShortUnitName(String fullUnitName) {
    switch (_currentUnitType) {
      case 'data':
        return units[UnitType.data]![fullUnitName]!.symbol;
      case 'length':
        return units[UnitType.length]![fullUnitName]!.symbol;
      case 'power':
        return units[UnitType.power]![fullUnitName]!.symbol;
      case 'temperature':
        return temperatureUnits[fullUnitName]!.symbol;
      case 'time':
        return units[UnitType.time]![fullUnitName]!.symbol;
      case 'weight':
        return units[UnitType.weight]![fullUnitName]!.symbol;
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final units = _getSelectedUnits();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.conversionType),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // conversion units
            Expanded(              
              child: ListView.builder(
                itemCount: units.length,
                itemBuilder: (context, index) {
                  bool isSelected = _selectedCardIndex == index;
                  return Card(         
                    color: isSelected
                    ? Color.lerp(Theme.of(context).colorScheme.secondary, Colors.grey.shade600, 0.6)
                    : Theme.of(context).colorScheme.secondary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 0,
                    clipBehavior: Clip.antiAlias,           
                    child: ListTile(
                      title: Text(units[index]),
                      trailing: Text(
                        _getShortUnitName(units[index]),
                        style: TextStyle(
                          fontSize: 15,
                          color: Theme.of(context).disabledColor,
                        ),
                      ),
                      subtitle: Text(
                        unitResults[units[index]] ?? '0', 
                        style: TextStyle(fontWeight: FontWeight.bold)
                      ),
                      onTap: () {
                        setState(() {
                          _selectedCardIndex = index;
                          _selectedUnit = units[index];
                        });
                      },
                    )
                  );
                }
              )
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(10.0))
                ),
                child: Column(
                  children: [
                    // currently selected unit
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(5, 10, 5, 0),
                        child: Text(_selectedUnit)
                      ),
                    ),
                    // convert controller text field
                    // with backspace button
                    Row(
                      children: [  
                        Expanded(
                          child: TextField(
                            autofocus: true,
                            controller: _convertController,
                            keyboardType: TextInputType.none,
                            onChanged: (String onChanged) {
                              onValueChanged();
                            },
                            decoration: InputDecoration(
                              hintText: '0',
                              hintStyle: TextStyle(
                                color: Theme.of(context).disabledColor
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.all(5),
                            ),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 35,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                          child: TextButton(
                            style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all(Colors.transparent),
                            ),
                            onPressed: () {
                              removeCharacter(_convertController);
                              onValueChanged();
                            },
                            onLongPress: () {
                              clearExpression(_convertController, _convertController); 
                              onValueChanged(); 
                            },
                            child: Icon(Icons.backspace_outlined, color: Theme.of(context).colorScheme.primary, size: 25)
                          ),
                        )
                      ],
                    ),
                    // calculator buttons
                    const SizedBox(height: 5),
                    buttonRow([
                      calcButton(child: const Text('7'), onPressed: () => _onButtonPressed(value: '7')),
                      calcButton(child: const Text('8'), onPressed: () => _onButtonPressed(value: '8')),
                      calcButton(child: const Text('9'), onPressed: () => _onButtonPressed(value: '9')),
                      calcButton(child: const Text('/'), onPressed: () => _onButtonPressed(value: '/')),
                    ]),
                    const SizedBox(height: 5),
                    buttonRow([
                      calcButton(child: const Text('4'), onPressed: () => _onButtonPressed(value: '4')),
                      calcButton(child: const Text('5'), onPressed: () => _onButtonPressed(value: '5')),
                      calcButton(child: const Text('6'), onPressed: () => _onButtonPressed(value: '6')),
                      calcButton(child: const Text('*'), onPressed: () => _onButtonPressed(value: '*')),
                    ]),
                    const SizedBox(height: 5),
                    buttonRow([
                      calcButton(child: const Text('1'), onPressed: () => _onButtonPressed(value: '1')),
                      calcButton(child: const Text('2'), onPressed: () => _onButtonPressed(value: '2')),
                      calcButton(child: const Text('3'), onPressed: () => _onButtonPressed(value: '3')),
                      calcButton(child: const Text('-'), onPressed: () => _onButtonPressed(value: '-')),
                    ]),
                    const SizedBox(height: 5),
                    buttonRow([
                      calcButton(child: const Text('0'), onPressed: () => _onButtonPressed(value: '0'), flex: 2),
                      calcButton(child: const Text('.'), onPressed: () => _onButtonPressed(value: '.')),
                      calcButton(child: const Text('+'), onPressed: () => _onButtonPressed(value: '+')),
                    ]),
                    const SizedBox(height: 5),
                  ],
                ),
              )
            )
          ],
        )
      ),
    );
  }
}