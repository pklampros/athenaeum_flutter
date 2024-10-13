import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';

import '../settings/settings_view.dart';
import 'sample_item.dart';
import 'sample_item_details_view.dart';

/// Displays a list of SampleItems.
class SampleItemListView extends StatelessWidget {
  List<SampleItem> parseItems(String responseBody) {
    final parsed = (jsonDecode(responseBody)['items'] as List)
        .cast<Map<String, dynamic>>();

    return parsed.map<SampleItem>((json) => SampleItem.fromJson(json)).toList();
  }

  Future<List<SampleItem>> fetchItems() async {
    // Store username and password in encrypted settings
    AndroidOptions getAndroidOptions() => const AndroidOptions(
          encryptedSharedPreferences: true,
        );
    final storage = FlutterSecureStorage(aOptions: getAndroidOptions());

    final String server = "http://10.0.2.2:8081";
    final String? user = await storage.read(key: "nc-user");
    final String? password = await storage.read(key: "nc-password");
    String basicAuth = base64.encode(utf8.encode('$user:$password'));

    try {
      final response = await get(
          Uri.parse('$server/apps/athenaeum/api/0.1/items'),
          headers: <String, String>{'authorization': 'Basic $basicAuth'});
      if (response.statusCode != 200) {
        throw HttpException('${response.statusCode}');
      }
      return parseItems(response.body);
    } on SocketException {
      return Future.error("No Internet connection");
    } on HttpException catch (e) {
      return Future.error("Failed to fetch items (${e.message})");
    } on FormatException {
      return Future.error("Bad response format");
    }
  }

  SampleItemListView({
    super.key,
    this.items = const [],
  });

  static const routeName = '/';

  List<SampleItem> items;

  @override
  Widget build(BuildContext context) {
    final futitems = fetchItems();

    // print(items);

    return FutureBuilder(
      future: futitems,
      builder: (context, snapshot) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Items'),
            actions: [
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () {
                  // Navigate to the settings page. If the user leaves and returns
                  // to the app after it has been killed while running in the
                  // background, the navigation stack is restored.
                  Navigator.restorablePushNamed(
                      context, SettingsView.routeName);
                },
              ),
            ],
          ),

          // To work with lists that may contain a large number of items, it’s best
          // to use the ListView.builder constructor.
          //
          // In contrast to the default ListView constructor, which requires
          // building all Widgets up front, the ListView.builder constructor lazily
          // builds Widgets as they’re scrolled into view.
          body: Builder(builder: (BuildContext context) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: Text('Fetching items...'));
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              items = snapshot.data!;
              return ListView.builder(
                // Providing a restorationId allows the ListView to restore the
                // scroll position when a user leaves and returns to the app after it
                // has been killed while running in the background.
                restorationId: 'sampleItemListView',
                itemCount: items.length,
                itemBuilder: (BuildContext context, int index) {
                  final item = items[index];

                  return ListTile(
                      title: Text('${item.id}: ${item.title}'),
                      leading: const CircleAvatar(
                        // Display the Flutter Logo image asset.
                        foregroundImage:
                            AssetImage('assets/images/flutter_logo.png'),
                      ),
                      onTap: () {
                        // Navigate to the details page. If the user leaves and returns to
                        // the app after it has been killed while running in the
                        // background, the navigation stack is restored.
                        Navigator.restorablePushNamed(
                          context,
                          SampleItemDetailsView.routeName,
                        );
                      });
                },
              );
            }
          }),
        );
      },
    );
  }
}
