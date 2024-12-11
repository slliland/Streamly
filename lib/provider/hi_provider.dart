import 'package:nested/nested.dart';
import 'package:provider/provider.dart';
import 'package:streamly/provider/theme_provider.dart';

List<SingleChildWidget> topProviders = [
  ChangeNotifierProvider(create: (_) => ThemeProvider())
];
