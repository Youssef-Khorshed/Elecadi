import 'package:bloc/bloc.dart';

part 'webview_state.dart';

class WebViewCubit extends Cubit<WebViewState> {
  WebViewCubit() : super(WebViewInitial());
}
