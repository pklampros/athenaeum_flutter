import 'package:athenaeum_flutter/src/serversetscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:settings_ui/settings_ui.dart';

import 'settings_controller.dart';

import '../constants.dart' as constants;

/// Displays the various settings that can be customized by the user.
///
/// When a user changes a setting, the SettingsController is updated and
/// Widgets that listen to the SettingsController are rebuilt.
class SettingsView extends StatelessWidget {
  const SettingsView({super.key, required this.controller});

  static const routeName = '/settings';

  final SettingsController controller;

  @override
  Widget build(BuildContext context) {
    return SettingsList(
      sections: [
        SettingsSection(
          title: Text('Common'),
          tiles: <SettingsTile>[
            SettingsTile(
              leading: Icon(Icons.cloud),
              title: Text('Server'),
              description: controller.serverAddress == null
                  ? Text('None')
                  : Text(controller.serverAddress!),
              onPressed: (context) async {
                final serverData = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ServerSetPage(
                          serverAddress: controller.serverAddress)),
                );

                if (serverData == null) return;
                // Store the server address in visible settings
                controller.updateServerAddress(serverData['server']);

                // Store username and password in encrypted settings
                AndroidOptions getAndroidOptions() => const AndroidOptions(
                      encryptedSharedPreferences: true,
                    );
                final storage =
                    FlutterSecureStorage(aOptions: getAndroidOptions());

                await storage.write(
                    key: constants.storeUsernameKey, value: serverData['user']);
                await storage.write(
                    key: constants.storePasswordKey,
                    value: serverData['password']);
              },
            ),
            SettingsTile.navigation(
              leading: Icon(Icons.language),
              title: Text('Language'),
              value: Text('English'),
            ),
            SettingsTile.switchTile(
              onToggle: (value) {},
              initialValue: true,
              leading: Icon(Icons.format_paint),
              title: Text('Enable custom theme'),
            ),
          ],
        ),
      ],
    );
    // return Scaffold(
    //   appBar: AppBar(
    //     title: const Text('Settings'),
    //   ),
    //   body: Padding(
    //     padding: const EdgeInsets.all(16),
    //     // Glue the SettingsController to the theme selection DropdownButton.
    //     //
    //     // When a user selects a theme from the dropdown list, the
    //     // SettingsController is updated, which rebuilds the MaterialApp.
    //     child: ListView(
    //       children: <Widget>[
    //         DropdownButton<ThemeMode>(
    //           // Read the selected themeMode from the controller
    //           value: controller.themeMode,
    //           // Call the updateThemeMode method any time the user selects a theme.
    //           onChanged: controller.updateThemeMode,
    //           items: const [
    //             DropdownMenuItem(
    //               value: ThemeMode.system,
    //               child: Text('System Theme'),
    //             ),
    //             DropdownMenuItem(
    //               value: ThemeMode.light,
    //               child: Text('Light Theme'),
    //             ),
    //             DropdownMenuItem(
    //               value: ThemeMode.dark,
    //               child: Text('Dark Theme'),
    //             )
    //           ],
    //         )
    //       ],
    //     ),
    //   ),
    // );
  }
}
