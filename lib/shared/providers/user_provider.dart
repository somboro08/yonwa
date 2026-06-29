import 'package:flutter_riverpod/legacy.dart';
import '../../providers/user_provider.dart';

final userProviderRef = ChangeNotifierProvider<UserProvider>((ref) {
  return UserProvider();
});
