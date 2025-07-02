import '../core.dart';
import '../features/main_page/view_model/main_view_model.dart';

class Providers {
  static List<SingleChildWidget> getAllProviders() {
    return [ChangeNotifierProvider(create: (context) => MainViewModel())];
  }
}
