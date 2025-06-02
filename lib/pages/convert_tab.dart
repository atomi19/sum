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
                Card(
                  color: Theme.of(context).colorScheme.secondary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 0,
                  clipBehavior: Clip.antiAlias,
                  child: ListTile(
                    leading: const Icon(Icons.straighten),
                    title: const Text('Length'),
                    onTap: () => _navigateToConvertFromToPage('Length'),
                  ),
                ),
                Card(
                  color: Theme.of(context).colorScheme.secondary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 0,
                  clipBehavior: Clip.antiAlias,
                  child: ListTile(
                    leading: const Icon(Icons.thermostat_outlined),
                    title: const Text('Temperature'),
                    onTap: () => _navigateToConvertFromToPage('Temperature'),
                  ),
                ),
                Card(
                  color: Theme.of(context).colorScheme.secondary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 0,
                  clipBehavior: Clip.antiAlias,
                  child: ListTile(
                    leading: const Icon(Icons.schedule_outlined),
                    title: const Text('Time'),
                    onTap: () => _navigateToConvertFromToPage('Time'),
                  ),
                ),
                Card(
                  color: Theme.of(context).colorScheme.secondary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 0,
                  clipBehavior: Clip.antiAlias,
                  child: ListTile(
                    leading: const Icon(Icons.fitness_center_outlined),
                    title: const Text('Weight'),
                    onTap: () => _navigateToConvertFromToPage('Weight'),
                  ),
                ),
              ],
            )
          ),
        ],
      ),
    );
  }
}