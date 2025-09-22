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
  Widget _createUnitSection(
    BuildContext context,
    IconData icon,
    String title,
    VoidCallback onTap,
  ) {
    return Card(
      color: Theme.of(context).colorScheme.secondary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
        title: Text(title),
        onTap: () => onTap(),
        trailing: const Icon(Icons.arrow_right_rounded),
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
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Convert', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary)),
              ],
            ),
          ),
          // section with unit categories (e.g length, temperature, etc.)
          Expanded(
            child: ListView(
              padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
              children: [
                _createUnitSection(context, Icons.storage_outlined, 'Data', () => _navigateToConvertFromToPage('Data')),
                _createUnitSection(context, Icons.straighten_outlined, 'Length', () => _navigateToConvertFromToPage('Length')),
                _createUnitSection(context, Icons.bolt_outlined, 'Power', () => _navigateToConvertFromToPage('Power')),
                _createUnitSection(context, Icons.thermostat_outlined, 'Temperature', () => _navigateToConvertFromToPage('Temperature')),
                _createUnitSection(context, Icons.schedule_outlined, 'Time', () => _navigateToConvertFromToPage('Time')),
                _createUnitSection(context, Icons.fitness_center_outlined, 'Weight', () => _navigateToConvertFromToPage('Weight')),
              ],
            )
          )
        ],
      ),
    );
  }
}