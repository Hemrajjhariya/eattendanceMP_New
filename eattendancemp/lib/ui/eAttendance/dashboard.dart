import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

const Color primary = Color(0xFF603D9D);

class dashboard extends StatefulWidget {
  final String url;
  const dashboard(this.url, {super.key});

  @override
  State<dashboard> createState() => _WebViewContainerState();
}

class _WebViewContainerState extends State<dashboard> {
  late final WebViewController _controller;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initWebView();
  }

  void _initWebView() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.transparent)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) {
            setState(() => isLoading = true);
          },
          onPageFinished: (_) {
            setState(() => isLoading = false);
          },
          onWebResourceError: (_) {
            setState(() => isLoading = false);
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      /// 🌈 GRADIENT APPBAR
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          "Dashboard",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF7F53AC),
                Color(0xFF647DEE),
              ],
            ),
          ),
        ),
      ),

      /// 🌐 WEBVIEW + LOADER
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (isLoading)
            Container(
              color: Colors.white.withOpacity(0.6),
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(color: primary),
                    SizedBox(height: 12),
                    Text(
                      "Loading dashboard...",
                      style: TextStyle(
                        color: primary,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  ],
                ),
              ),
            ),
        ],
      ),

      /// 🏛️ NIC BRANDING FOOTER
      bottomNavigationBar: Container(
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF647DEE),
              Color(0xFF7F53AC),
            ],
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Image.asset(
              'lib/assets/images/niclogo.png',
              height: 28,
              fit: BoxFit.contain,
            ),
          ],
        ),
      ),
    );
  }
}
