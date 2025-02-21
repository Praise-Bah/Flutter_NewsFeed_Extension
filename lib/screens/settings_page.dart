import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _darkMode = true;
  String _defaultCategory = 'all';
  bool _autoRefresh = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _darkMode = prefs.getBool('darkMode') ?? true;
      _defaultCategory = prefs.getString('defaultCategory') ?? 'all';
      _autoRefresh = prefs.getBool('autoRefresh') ?? true;
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkMode', _darkMode);
    await prefs.setString('defaultCategory', _defaultCategory);
    await prefs.setBool('autoRefresh', _autoRefresh);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Dark Mode'),
            subtitle: const Text('Enable dark theme'),
            value: _darkMode,
            onChanged: (value) {
              setState(() {
                _darkMode = value;
                _saveSettings();
              });
            },
          ),
          ListTile(
            title: const Text('Default Category'),
            subtitle: DropdownButton<String>(
              value: _defaultCategory,
              items: [
                'all',
                'business',
                'entertainment',
                'health',
                'science',
                'sports',
                'technology'
              ].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? value) {
                if (value != null) {
                  setState(() {
                    _defaultCategory = value;
                    _saveSettings();
                  });
                }
              },
            ),
          ),
          SwitchListTile(
            title: const Text('Auto Refresh'),
            subtitle: const Text('Automatically refresh news'),
            value: _autoRefresh,
            onChanged: (value) {
              setState(() {
                _autoRefresh = value;
                _saveSettings();
              });
            },
          ),
        ],
      ),
    );
  }
}