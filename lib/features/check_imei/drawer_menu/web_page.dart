import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
// ignore: depend_on_referenced_packages
import 'package:webview_flutter_android/webview_flutter_android.dart'
    as webview_flutter_android;

import '../../../helper/app_states_notifier.dart';
import '../../launcher/data/models/device_details_res.dart';

class WebPage extends StatefulWidget {
  const WebPage({super.key, required this.title, required this.url});

  final String title;
  final String url;

  @override
  createState() => _WebPageState();
}

class _WebPageState extends State<WebPage> {
  late WebViewController webViewController;
  bool isLoading = true;
  bool isLoadingFirstTime = true;
  LabelDetails? labelDetails;
  bool canGoBack = false;

  @override
  void initState() {
    super.initState();
    webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
            if (isLoadingFirstTime) {
              setState(() {
                isLoading = true;
                isLoadingFirstTime = false;
              });
            }
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) async {
            canGoBack = await webViewController.canGoBack();
            setState(() {
              isLoading = false;
            });
          },
          onWebResourceError: (WebResourceError error) {
            setState(() {
              isLoading = false;
            });
          },
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
    initFilePicker();
  }

  /// handle attachments
  initFilePicker() async {
    if (Platform.isAndroid) {
      final androidController = (webViewController.platform
          as webview_flutter_android.AndroidWebViewController);
      await androidController.setOnShowFileSelector(_androidFilePicker);
    }
  }

  Future<List<String>> _androidFilePicker(
      webview_flutter_android.FileSelectorParams params) async {
    try {
      if (params.mode ==
          webview_flutter_android.FileSelectorMode.openMultiple) {
        final attachments =
            await FilePicker.platform.pickFiles(allowMultiple: true);
        if (attachments == null) return [];

        return attachments.files
            .where((element) => element.path != null)
            .map((e) => File(e.path!).uri.toString())
            .toList();
      } else {
        final attachment = await FilePicker.platform.pickFiles();
        if (attachment == null) return [];
        File file = File(attachment.files.single.path!);
        return [file.uri.toString()];
      }
    } catch (e) {
      return [];
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    labelDetails = Provider.of<AppStatesNotifier>(context).value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBarWithTitleOnly(title: widget.title),
      body: PopScope(
        canPop: false,
        onPopInvoked: (bool didPop) async {
          if (didPop) return;
          await _canPop();
        },
        child: Stack(
          children: [
            (isLoading)
                ? const Center(
                    child: CircularProgressIndicator(
                      color: Colors.orange,
                    ),
                  )
                : WebViewWidget(controller: webViewController),
          ],
        ),
      ),
    );
  }

  Future<void> _canPop() async {
    final NavigatorState navigator = Navigator.of(context);
    if (await webViewController.canGoBack()) {
      webViewController.goBack();
    } else {
      navigator.pop();
    }
  }
}
