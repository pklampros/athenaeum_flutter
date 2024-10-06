import 'package:athenaeum_flutter/src/webviewscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ServerSetPage extends StatelessWidget {
  final String? serverAddress;
  const ServerSetPage({super.key, this.serverAddress});

  @override
  Widget build(BuildContext context) {
    final serverAddressCtrl = TextEditingController();
    if (serverAddress != null) serverAddressCtrl.text = serverAddress!;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Set server'),
      ),
      body: Center(
        child: ListView(
          children: <Widget>[
            TextField(
              controller: serverAddressCtrl,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Server address',
                hintText: 'https://...',
              ),
            ),
            ElevatedButton(
              child: const Text('Login'),
              onPressed: () async {
                final path = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          WebViewScreen(serverAddress: serverAddressCtrl.text)),
                );

                if (!context.mounted) return;

                if (path == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Couldn\'t get credentials',
                      ),
                    ),
                  );
                  return;
                }

                // Path returned from webview with data in the form:
                // `server:<server>&user:<loginname>&password:<password>`
                // The server URI can contain a port number (i.e. be in
                // the form 'http://<url>:<port>') so only the first ';'
                // is to be used to determine key/value
                final pathData = path.split("&");
                Map<String, String> serverData = {};
                for (String s in pathData) {
                  var list = s.split(":");
                  if (list.length >= 2) {
                    serverData[list[0]] = list.sublist(1).join(':').trim();
                  }
                }

                if (!serverData.containsKey('server') ||
                    serverData['server'] == null ||
                    !serverData.containsKey('user') ||
                    serverData['user'] == null ||
                    !serverData.containsKey('password') ||
                    serverData['password'] == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Couldn\'t parse credentials returned',
                      ),
                    ),
                  );
                  return;
                }
                Navigator.pop(context, serverData);
              },
            ),
          ],
        ),
      ),
    );
  }
}
