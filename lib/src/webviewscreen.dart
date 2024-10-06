import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class WebViewScreen extends StatefulWidget {
  final String serverAddress;

  const WebViewScreen({super.key, required this.serverAddress});

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late WebViewController controller;
  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setNavigationDelegate(
          NavigationDelegate(onNavigationRequest: (navigation) async {
        final uri = Uri.parse(navigation.url);
        // Expected uri is nc://login/<server login data>
        if (uri.scheme == 'nc') {
          final currContext = context;
          if (!currContext.mounted) return NavigationDecision.prevent;

          // Path starts with '/'
          Navigator.pop(currContext, uri.path.substring(1));

          return NavigationDecision.prevent;
        }
        return NavigationDecision.navigate;
      }))
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse('${widget.serverAddress}/login/flow'),
          headers: {"OCS-APIREQUEST": "true"});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Webview title"),
      ),
      body: WebViewWidget(
        controller: controller,
      ),
    );
  }
}
