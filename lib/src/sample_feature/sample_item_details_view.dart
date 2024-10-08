import 'package:flutter/material.dart';

/// Displays detailed information about a SampleItem.
class SampleItemDetailsView extends StatelessWidget {
  const SampleItemDetailsView({super.key});

  static const routeName = '/sample_item';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Item Details'),
      ),
      body: Center(
          child: ListView(children: <Widget>[
        Text('More Information Here'),
        TextButton(
          style: ButtonStyle(
            foregroundColor: WidgetStateProperty.all<Color>(Colors.blue),
          ),
          onPressed: () async {
            // if (Platform.isAndroid || Platform.isIOS) {

            // } else {
            //   WidgetsFlutterBinding.ensureInitialized();
            //   final webview = await WebviewWindow.create();
            //   webview.launch("https://flutter.dev");
            // }
          },
          child: Text('TextButton'),
        )
      ])),
    );
  }
}
