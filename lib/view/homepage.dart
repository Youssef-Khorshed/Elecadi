import 'dart:io';

import 'package:elcadi/core/helpers/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final WebViewController _controller;
  List<String> container = [];
  bool isLoading = true; // Loading state
  double? startX;

  String jsString = '''
  document.addEventListener("contextmenu", event => event.preventDefault());
  document.addEventListener("selectstart", event => event.preventDefault());
''';
  @override
  void initState() {
    super.initState();
    _controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setNavigationDelegate(
            NavigationDelegate(
              onNavigationRequest: (NavigationRequest request) {
                return NavigationDecision.navigate;
              },
              onPageFinished: (item) async {
                setState(() {
                  if (container.isNotEmpty) {
                    if (container.last == item) {
                      container.removeLast();
                    }
                  }
                  container.add(item); // comment

                  isLoading = false;
                });
                await _controller.runJavaScript(jsString);
              },
            ),
          )
          ..loadRequest(Uri.parse('https://elecadi.com/'));
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const ShimmerLoadingPage()
        : PopScope(
          canPop: false,
          onPopInvokedWithResult: (bool didPop, result) async {
            if (!didPop) {
              if (container.length == 1) {
                await showExitConfirmationDialog();
              } else {
                backlogic();
              }
            }
          },

          child: Scaffold(
            backgroundColor: Colors.black,
            appBar: AppBar(
              backgroundColor: Colors.black,
              leading:
                  container.length - 1 <= 0
                      ? const SizedBox()
                      : Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: IconButton(
                          icon: const Icon(
                            Icons.arrow_back_ios,
                            size: 30,
                            color: Colors.white,
                          ),
                          onPressed: backlogic,
                        ),
                      ),
            ),
            body: Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: GestureDetector(
                onLongPress: () {},

                child: IOSPopDetector(
                  onSwipeDetected: () {
                    backlogic();
                  },
                  child: WebViewWidget(controller: _controller),
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
        _controller.loadRequest(Uri.parse(container[container.length - 2]));
        container.removeLast();
        isLoading = false;
      });
    }
  }

  Future<bool> showExitConfirmationDialog() async {
    return await showDialog<bool>(
          context: context,
          builder:
              (context) => AlertDialog(
                title: const Text('هل تريد الخروج؟'),
                actions: <Widget>[
                  TextButton(
                    onPressed:
                        () => Navigator.of(context).pop(false), // Cancel exit
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

class IOSPopDetector extends StatefulWidget {
  final Widget child;
  final VoidCallback? onSwipeDetected;

  const IOSPopDetector({Key? key, required this.child, this.onSwipeDetected})
    : super(key: key);

  @override
  _IOSPopDetectorState createState() => _IOSPopDetectorState();
}

class _IOSPopDetectorState extends State<IOSPopDetector> {
  double? startX;
  bool isSwiping = false;

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (PointerDownEvent event) {
        startX = event.position.dx;
      },
      onPointerMove: (PointerMoveEvent event) {
        if (startX != null && !isSwiping) {
          double currentX = event.position.dx;
          double deltaX = currentX - startX!;

          // Check if the gesture is a horizontal swipe
          if (deltaX.abs() > 50) {
            if (deltaX > 0) {
              print('Swipe Right Detected');
              widget.onSwipeDetected?.call(); // Trigger custom logic
            } else {
              print('Swipe Left Detected');
              widget.onSwipeDetected?.call(); // Trigger custom logic
            }
            isSwiping = true; // Prevent multiple triggers
          }
        }
      },
      onPointerUp: (PointerUpEvent event) {
        startX = null;
        isSwiping = false;
      },
      child: widget.child,
    );
  }
}
