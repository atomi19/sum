import 'package:flutter/material.dart';
import 'package:sum/widgets/show_alert_dialog.dart';
import 'package:sum/widgets/show_bottom_sheet.dart';

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
  final String appVersion = '19.07.2025';

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Text(title, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
    );
  }

  Widget _subsectionTitle({
    required String title,
    String? trailing,
    required VoidCallback onTap,
  }) {
    return Card(
      color: Theme.of(context).colorScheme.secondary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: EdgeInsets.zero,
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        title: Text(title),
        trailing: trailing != null ? Text(trailing, style: const TextStyle(fontSize: 16)) : null,
        contentPadding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        onTap: onTap,
      ),
    );
  }

  void _showThemePicker() {
    showCustomBottomSheet(
      context: context, 
      child: Wrap(
        children: [
          ListTile(
            leading: const Icon(Icons.light_mode_outlined),
            title: const Text('Light'),
            onTap: () {
              Navigator.pop(context);
              setState(() {
                widget.toggleLightTheme();
              });
            },
          ),
          ListTile(
            leading: const Icon(Icons.dark_mode_outlined),
            title: const Text('Dark'),
            onTap: () {
              Navigator.pop(context);
              setState(() {
                widget.toggleDarkTheme();
              });
            },
          ),
        ],
      ),
    );
  }
  
  void _showLicencesDialog() {
    Navigator.pop(context);
    
    showAlertDialog(
      context: context, 
      contentPadding: EdgeInsets.all(10),
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
    );
  }

  Widget _buildAboutSection({
    required String title,
    String? subtitle,
    required Widget trailing,
    VoidCallback? onTap,
    }) {
    return ListTile(
      tileColor: Theme.of(context).colorScheme.secondary,
      title: Text(title, style: TextStyle(fontSize: 15)),
      subtitle: subtitle != null ? SelectableText(subtitle) : null,
      trailing: trailing,
      onTap: onTap,
    );
  }

  void _showAboutDialog() {
    showAlertDialog(
      context: context, 
      contentPadding: EdgeInsets.all(10),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildAboutSection(title: 'Name', trailing: Text(appName, style: TextStyle(fontSize: 15))),
          _buildAboutSection(title: 'Version', trailing: Text(appVersion, style: TextStyle(fontSize: 15))),
          _buildAboutSection(title: 'Made by', subtitle: 'https://github.com/atomi19', trailing: Text('atomi19', style: TextStyle(fontSize: 15))),
          _buildAboutSection(title: 'Licenses', trailing: Icon(Icons.arrow_right), onTap: _showLicencesDialog),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          // top bar
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Settings', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary),),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
              children: [
                // appearance section
                _sectionTitle('Appearance'),
                _subsectionTitle(
                  title: 'Theme',
                  trailing: widget.themeMode == ThemeMode.light ? 'Light' : 'Dark',
                  onTap: _showThemePicker
                ),
                // more section
                _sectionTitle('More'),
                // about subsection
                _subsectionTitle(
                  title: 'About',
                  onTap: _showAboutDialog,
                )
              ],
            ),
          )
        ],
      )
    );
  }
}