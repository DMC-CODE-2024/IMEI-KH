import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../helper/app_states_notifier.dart';
import '../../component/app_bar_with_title.dart';
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
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    labelDetails = Provider.of<AppStatesNotifier>(context).value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWithTitleOnly(title: widget.title),
        body: Stack(
          children: [
            (isLoading)
                ? const Center(
                    child: CircularProgressIndicator(
                      color: Colors.orange,
                    ),
                  )
                : WebViewWidget(controller: webViewController),
            Padding(
                padding: const EdgeInsets.only(left: 10, top: 10),
                child: (canGoBack)
                    ? ClipOval(
                        child: Material(
                          color: Colors.white, // Button color
                          child: InkWell(
                            splashColor: Colors.orange, // Splash color
                            onTap: () {
                              webViewController.goBack();
                            },
                            child: const SizedBox(
                                width: 36,
                                height: 36,
                                child: Icon(Icons.arrow_back)),
                          ),
                        ),
                      )
                    : Container())
          ],
        ));
  }
}
