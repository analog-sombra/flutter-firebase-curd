import 'package:firebase_core/firebase_core.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../firebase_options.dart';

final firebaseApp = FutureProvider.autoDispose(
  (ref) => initFirebase(),
);

Future<FirebaseApp> initFirebase() async {
  return Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}
