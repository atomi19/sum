import 'package:flutter/material.dart';
import 'package:sum/pages/convert_from_to_page.dart';

class ConvertTab extends StatefulWidget {
  const ConvertTab({super.key});

  @override
  State<ConvertTab> createState() => _ConvertTabState();
}

class _ConvertTabState extends State<ConvertTab> {
  void _navigateToConvertFromToPage(String conversionType) {
    Navigator.push(
      context, 
      MaterialPageRoute(builder: (context) => ConvertFromToPage(conversionType: conversionType,))
    );
  }

  // create section with specific unit category(e.g. length, time, etc.)
  Widget _createUnitSection(BuildContext context, IconData icon, String title, VoidCallback onTap) {
    return Card(
      color: Theme.of(context).colorScheme.secondary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        onTap: () => onTap(),
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          // top bar (or app bar)
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Theme.of(context).colorScheme.secondary,
                  width: 1.0,
                )
              )
            ),
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Convert', style: TextStyle(fontSize: 18, color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold),),
              ],
            ),
          ),
          // section with unit categories (e.g length, temperature, etc.)
          Expanded(
            child: ListView(
              children: [
                _createUnitSection(context, Icons.storage_outlined, 'Data', () => _navigateToConvertFromToPage('Data')),
                _createUnitSection(context, Icons.straighten, 'Length', () => _navigateToConvertFromToPage('Length')),
                _createUnitSection(context, Icons.bolt_outlined, 'Power', () => _navigateToConvertFromToPage('Power')),
                _createUnitSection(context, Icons.thermostat_outlined, 'Temperature', () => _navigateToConvertFromToPage('Temperature')),
                _createUnitSection(context, Icons.schedule_outlined, 'Time', () => _navigateToConvertFromToPage('Time')),
                _createUnitSection(context, Icons.fitness_center_outlined, 'Weight', () => _navigateToConvertFromToPage('Weight')),
              ],
            )
          ),
        ],
      ),
    );
  }
}