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
  // Disable context menu
  document.addEventListener("contextmenu", event => event.preventDefault());

  // Disable text selection
  document.addEventListener("selectstart", event => event.preventDefault());

  // Disable long-press actions
  document.addEventListener("touchstart", event => {
    if (event.touches.length > 1) {
      event.preventDefault(); // Prevent multi-touch gestures
    }
  }, { passive: false });

  document.addEventListener("touchmove", event => {
    if (event.touches.length > 1) {
      event.preventDefault(); // Prevent multi-touch gestures
    }
  }, { passive: false });
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
              onPageStarted: (url) {},
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

  const IOSPopDetector({super.key, required this.child, this.onSwipeDetected});

  @override
  _IOSPopDetectorState createState() => _IOSPopDetectorState();
}

class _IOSPopDetectorState extends State<IOSPopDetector> {
  double? startX;
  double? startY; // Track vertical position
  bool isSwiping = false;

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (PointerDownEvent event) {
        // Only start tracking if the touch begins near the left edge
        if (event.position.dx < 50) {
          // Swipe only from the left edge (first 50px)
          startX = event.position.dx;
          startY = event.position.dy; // Initialize vertical position
        }
      },
      onPointerMove: (PointerMoveEvent event) {
        if (startX != null && startY != null && !isSwiping) {
          double currentX = event.position.dx;
          double currentY = event.position.dy;
          double deltaX = currentX - startX!;
          double deltaY = currentY - startY!;

          // Check if the gesture is primarily horizontal (ignore vertical scrolling)
          if (deltaX.abs() > 50 && deltaX.abs() > deltaY.abs()) {
            if (deltaX > 0) {
              widget.onSwipeDetected?.call(); // Trigger custom logic
            }
            isSwiping = true; // Prevent multiple triggers
          }
        }
      },
      onPointerUp: (PointerUpEvent event) {
        startX = null;
        startY = null;
        isSwiping = false;
      },
      child: widget.child,
    );
  }
}
