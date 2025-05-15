import 'package:flutter/material.dart';

class SettingsTab extends StatefulWidget {
  final VoidCallback toggleLightTheme;
  final VoidCallback toggleDarkTheme;
  final ThemeMode themeMode;


  const SettingsTab({
    super.key,
    required this.toggleLightTheme,
    required this.toggleDarkTheme,
    required this.themeMode
  });

  @override
  State<SettingsTab> createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          // top bar
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
                Text('Settings', style: TextStyle(fontSize: 18, color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold),),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(10),
              children: [
                // appearance section
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                  child: const Text('Appearance', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                ),
                ListTile(
                  title: const Text('Theme'),
                  tileColor: Theme.of(context).colorScheme.secondary,
                  contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  trailing: TextButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        backgroundColor: Theme.of(context).colorScheme.secondary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
                        ),
                        builder: (BuildContext context) {
                          return Padding(
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                            child: Wrap(
                              children: [
                                ListTile(
                                  leading: const Icon(Icons.light_mode_outlined),
                                  title: const Text('Light'),
                                  onTap: () {
                                    Navigator.pop(context);
                                    widget.toggleLightTheme();
                                  },
                                ),
                                ListTile(
                                  leading: const Icon(Icons.dark_mode_outlined),
                                  title: const Text('Dark'),
                                  onTap: () {
                                    Navigator.pop(context);
                                    widget.toggleDarkTheme();
                                  },
                                ),
                              ],
                            ),
                          );
                        }
                      );
                    }, 
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      widget.themeMode == ThemeMode.light
                      ? 'Light'
                      : 'Dark',
                      style: TextStyle(fontSize: 18)
                    ),
                  )
                ),
              ],
            ),
          )
        ],
      )
    );
  }
}