import 'package:elcadi/core/helpers/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  late WebViewController controller;
  bool isLoading = true; // Loading state
  String? currentLink;
  String? previousLink;
  List<String> container = [];
  String jsString = '''
  document.addEventListener("contextmenu", event => event.preventDefault());
  document.addEventListener("selectstart", event => event.preventDefault());
''';
  @override
  void initState() {
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(onNavigationRequest: (NavigationRequest request) {
          return NavigationDecision.navigate;
        }, onPageFinished: (item) async {
          setState(() {
            if (container.isNotEmpty) {
              if (container.last == item) {
                container.removeLast();
              }
            }
            container.add(item); // comment

            isLoading = false;
          });
          await controller.runJavaScript(jsString);
        }),
      )
      ..loadRequest(Uri.parse('https://elecadi.com/'));

    super.initState();
  }

  Future<void> _onRefresh() async {
    setState(() {
      isLoading = true;
      controller.reload();
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const ShimmerLoadingPage() // Show loader while initializing
        : PopScope(
            canPop: false,
            onPopInvokedWithResult: (pop, item) {
              if (!pop && container.length == 1) {
                _showExitConfirmationDialog();
              }
            },
            child: GestureDetector(
              onHorizontalDragEnd: (details) {
                backlogic();
              },
              child: Scaffold(
                backgroundColor: Colors.black,
                appBar: AppBar(
                  backgroundColor: Colors.black,
                  leading: container.length - 1 <= 0 // previousLink == null
                      ? const SizedBox()
                      : Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: IconButton(
                              icon: const Icon(
                                Icons.arrow_back_ios,
                                size: 30,
                                color: Colors.white,
                              ),
                              onPressed: backlogic),
                        ),
                ),
                body: GestureDetector(
                  onLongPress: () {},
                  child: RefreshIndicator(
                    onRefresh: _onRefresh,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: WebViewWidget(
                        controller: controller,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
  }

  void backlogic() {
    if (container.length > 1) {
      setState(() {
        isLoading = true;
        controller.loadRequest(Uri.parse(container[container.length - 2]));
        container.removeLast();
        isLoading = false;
      });
    }
  }

  /// Show exit confirmation dialog
  Future<bool> _showExitConfirmationDialog() async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('هل تريد الخروج؟'),
            actions: <Widget>[
//           AppTextButton(buttonText: 'No' ,textStyle:const TextStyle(fontSize: 14,color: Colors.black), onPressed: () { Navigator.of(context).pop(false); },)
// ,
//           AppTextButton(buttonText: 'YES', textStyle:const TextStyle(fontSize: 14,color: Colors.black), onPressed: () { SystemNavigator.pop(); },)

              TextButton(
                onPressed: () =>
                    Navigator.of(context).pop(false), // Cancel exit
                child: const Text('إلغاء'),
              ),
              TextButton(
                onPressed: () => SystemNavigator.pop(), // Confirm exit
                child: const Text('نعم'),
              ),
            ],
          ),
        ) ??
        false; // Default to false if dialog is dismissed
  }
}
