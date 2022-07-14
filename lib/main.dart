import 'package:we_map/blocs/auth_bloc/auth_bloc.dart';
import 'package:we_map/router/router.dart';
import 'package:we_map/services/firebase_auth_service.dart';
import 'package:we_map/services/firebase_firestore_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<FirebaseFirestoreService>(
          create: (context) => FirebaseFirestoreService(),
        ),
        RepositoryProvider<FirebaseAuthService>(
          create: (context) => FirebaseAuthService(),
        ),
      ],
      child: BlocProvider(
        create: (context) => AuthBloc(authService: RepositoryProvider.of<FirebaseAuthService>(context))..add(AuthInitializeEvent()),
        child: MaterialApp(
          builder: (context, child) {
            return MediaQuery(data: MediaQuery.of(context).copyWith(
                alwaysUse24HourFormat: true), child: child!);
          },
          title: 'Fire Hydrant Mapper',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          navigatorKey: AppRouter.navigatorKey,
          initialRoute: '/',
          onGenerateRoute: AppRouter().onGenerate,
        ),
      ),
    );
  }
}


