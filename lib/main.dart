import 'package:fbasedbtuto/services/firebase.dart';
import 'package:fbasedbtuto/views/homepage.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends HookConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final firebaseAppW = ref.watch(firebaseApp);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter CURD App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: firebaseAppW.when(
        data: (data) => const HomePage(),
        error: (err, stack) => Center(
          child: Center(child: Text("Error: $err")),
        ),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
      ),
      // home: const HomePage(),
    );
  }
}
