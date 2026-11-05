import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uts_2415051051_juberta/providers/book_provider.dart';
import 'package:uts_2415051051_juberta/repositories/book_repository.dart';
import 'package:uts_2415051051_juberta/services/api_service.dart';
import 'package:uts_2415051051_juberta/screens/main_navigation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://dkelpevifjphgljjpncg.supabase.co',
    publishableKey: 'sb_publishable_eQ-qTdSpIGbQzUMy4RtEdA_PRPpmR-y',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => BookProvider(
            BookRepository(ApiService()),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'BookFinder UTS',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        home: const MainNavigation(),
      ),
    );
  }
}