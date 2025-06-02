enum UnitType{length, time, weight}

class Unit {
  final String name;
  final String symbol;
  final double factor;

  const Unit({
    required this.name,
    required this.symbol,
    required this.factor,
  });
}

class TemperatureUnit {
  final String name;
  final String symbol;
  final double Function(double) fromKelvin;
  final double Function(double) toKelvin;

  const TemperatureUnit({
    required this.name,
    required this.symbol,
    required this.fromKelvin,
    required this.toKelvin,
  });
}

final Map<UnitType, Map<String, Unit>> units = {
  UnitType.length: {
    'Millimeter': Unit(name: 'millimeter', symbol: 'mm', factor: 0.001),
    'Centimeter': Unit(name: 'centimeter', symbol: 'cm', factor: 0.01),
    'Meter': Unit(name: 'meter', symbol: 'm', factor: 1.0), // base unit
    'Kilometer': Unit(name: 'kilometer', symbol: 'km', factor: 1000),
  },
  UnitType.time: {
    'Millisecond': Unit(name: 'millisecond', symbol: 'ms', factor: 0.001),
    'Second': Unit(name: 'second', symbol: 'sec', factor: 1.0), // base unit
    'Minute': Unit(name: 'minute', symbol: 'min', factor: 60),
    'Hour': Unit(name: 'hour', symbol: 'hr', factor: 3600),
    'Day': Unit(name: 'day', symbol: 'd', factor: 86400),
    'Week': Unit(name: 'week', symbol: 'wk', factor: 604800),
    'Month': Unit(name: 'month', symbol: 'mo', factor: 2629800),
    'Year': Unit(name: 'year', symbol: 'yr', factor: 31557600),
  },
  UnitType.weight: {
    'Milligram': Unit(name: 'milligram', symbol: 'mg', factor: 1e-6),
    'Gram': Unit(name: 'gram', symbol: 'g', factor: 0.001),
    'Kilogram': Unit(name: 'kilogram', symbol: 'kg', factor: 1.0), // base unit
    'Tonne': Unit(name: 'tonne', symbol: 't', factor: 1000)
  }
};

final Map<String, TemperatureUnit> temperatureUnits = {
  'Celsius': TemperatureUnit(
    name: 'celsius', 
    symbol: '°C', 
    fromKelvin: (value) => value - 273.15 , 
    toKelvin: (value) => value + 273.15,
  ),
  'Fahrenheit': TemperatureUnit(
    name: 'fahrenheit',
    symbol: '°F', 
    fromKelvin: (value) => (value - 273.15) * 9 / 5 + 32, 
    toKelvin: (value) => (value - 32) * 5 / 9 + 273.15,
  ),
  'Kelvin': TemperatureUnit(
    name: 'kelvin',
    symbol: 'K', 
    fromKelvin: (k) => k, 
    toKelvin: (k) => k
  )
};

double convert(
  double value, 
  String fromSymbol, 
  String toSymbol, 
  UnitType unitType
) {
  final unitMap = units[unitType];

  if (unitMap == null || !unitMap.containsKey(fromSymbol) || !unitMap.containsKey(toSymbol)) {
    return 0;
  }

  final from = unitMap[fromSymbol]!;
  final to = unitMap[toSymbol]!;

  double valueInBase = value * from.factor;
  return valueInBase / to.factor;
}

double convertTemperature(
  double value,
  String from, 
  String to 
) {
  final fromUnit = temperatureUnits[from];
  final toUnit = temperatureUnits[to];

  if(fromUnit == null || toUnit == null) {
    return 0;
  }

  final kelvin = fromUnit.toKelvin(value);
  return toUnit.fromKelvin(kelvin);
}