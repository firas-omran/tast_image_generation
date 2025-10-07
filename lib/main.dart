import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'data/repositories/image_repository.dart';
import 'domain/usecases/generate_image_usecase.dart';
import 'presentation/bloc/generator_bloc.dart';
import 'presentation/router/app_router_delegate.dart';
import 'presentation/router/app_route_parser.dart';
import 'presentation/router/app_state.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => AppState(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    final repo = MockImageRepository();
    final useCase = GenerateImageUseCase(repository: repo);
    final appState = context.read<AppState>();

    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (_, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => GeneratorBloc(useCase: useCase)),
          ],
          child: MaterialApp.router(
            title: 'AI Mock Generator',
            theme: ThemeData(primarySwatch: Colors.indigo),
            routerDelegate: AppRouterDelegate(appState),
            debugShowCheckedModeBanner: false,
            routeInformationParser: const AppRouteParser(),
          ),
        );
      },
    );
  }
}
