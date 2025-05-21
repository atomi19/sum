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
  final String appName = 'Sum';
  final String appVersion = '18.05.2025';

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
                Card(
                  color: Theme.of(context).colorScheme.secondary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  margin: EdgeInsets.zero,
                  elevation: 0,
                  clipBehavior: Clip.antiAlias,
                  child: ListTile(
                    title: const Text('Theme'),
                    tileColor: Theme.of(context).colorScheme.secondary,
                    contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    onTap: () {
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
                    trailing: Text(
                      widget.themeMode == ThemeMode.light
                      ? 'Light'
                      : 'Dark',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400)
                    ),
                  ),
                ),
                // more section
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                  child: const Text('More', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                ),
                // about subsection
                Card(
                  color: Theme.of(context).colorScheme.secondary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  margin: EdgeInsets.zero,
                  elevation: 0,
                  clipBehavior: Clip.antiAlias,
                  child: ListTile(
                    title: const Text('About'),
                    contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          contentPadding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          backgroundColor: Theme.of(context).colorScheme.secondary,
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                tileColor: Theme.of(context).colorScheme.secondary,
                                title: Text('Name', style: TextStyle(fontSize: 15)),
                                trailing: Text(appName, style: TextStyle(fontSize: 15)),
                              ),
                              ListTile(
                                tileColor: Theme.of(context).colorScheme.secondary,
                                title: Text('Version', style: TextStyle(fontSize: 15)),
                                trailing: Text(appVersion, style: TextStyle(fontSize: 15)),
                              ),
                              ListTile(
                                tileColor: Theme.of(context).colorScheme.secondary,
                                title: Text('Made by', style: TextStyle(fontSize: 15)),
                                subtitle: SelectableText('https://github.com/atomi19'),
                                trailing: Text('atomi19', style: TextStyle(fontSize: 15)),
                              ),
                              ListTile(
                                tileColor: Theme.of(context).colorScheme.secondary,
                                title: Text('Licences', style: TextStyle(fontSize: 15)),
                                trailing: const Icon(Icons.arrow_right),
                                onTap: () {
                                  Navigator.pop(context);
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      contentPadding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                                      backgroundColor: Theme.of(context).colorScheme.secondary,
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          ListTile(
                                            title: const Text('App license'),
                                            subtitle: const SelectableText('https://github.com/atomi19/sum/blob/main/LICENSE.txt'),
                                          ),
                                          ListTile(
                                            title: const Text('Third-party licenses'),
                                            trailing: const Icon(Icons.arrow_right),
                                            onTap: () {
                                              showLicensePage(
                                                context: context,
                                                applicationName: appName,
                                                applicationVersion: appVersion,
                                              );
                                            },
                                          ),
                                        ],
                                      ), 
                                    )
                                  );
                                },
                              ),
                            ],
                          ),
                        )
                      );
                    },
                  )
                )
              ],
            ),
          )
        ],
      )
    );
  }
}