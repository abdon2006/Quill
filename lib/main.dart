import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quill/core/Obesrver/my_bloc_observer.dart';
import 'package:quill/core/di/injection_container.dart';
import 'package:quill/core/locale/cubit/locale_cubit.dart';
import 'package:quill/core/network/network_service.dart';
import 'package:quill/core/router/app_router.dart';
import 'package:quill/core/theme/app_theme.dart';
import 'package:quill/core/theme/cubit/theme_cubit.dart';
import 'package:quill/core/usecases/base_usecase.dart';
import 'package:quill/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:quill/features/auth/presentation/bloc/auth_event.dart';
import 'package:quill/features/reader/domain/usecases/fetch_local_book_usecase.dart';
import 'package:quill/features/reader/domain/usecases/fetch_local_books_usecase.dart';
import 'package:quill/features/reader/domain/usecases/remove_book_usecase.dart';
import 'package:quill/features/reader/domain/usecases/update_book_usecase.dart';
import 'package:quill/features/reader/domain/usecases/upload_book_usecase.dart';
import 'package:quill/features/reader/presentation/bloc/reader_bloc.dart';
import 'package:quill/features/reader/presentation/cubit/reader_preferences_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await setupDI();
  Bloc.observer = MyBlocObserver();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      
      fallbackLocale: const Locale('en'),
      path: 'assets/translations',
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) =>
                sl<AuthBloc>()..add(FetchUserDataEvent(params: NoParams())),
          ),
          BlocProvider(
            create: ((context) => ReaderBloc(
              uploadBookUsecase: sl<UploadBookUsecase>(),
              removeBookUsecase: sl<RemoveBookUsecase>(),
              fetchLocalBookUsecase: sl<FetchLocalBookUsecase>(),
              updateBookUsecase: sl<UpdateBookUsecase>(),
              fetchLocalBooksUsecase: sl<FetchLocalBooksUsecase>(),
              networkService: sl<NetworkService>(),
            )),
          ),
          BlocProvider(create: (_) => sl<ReaderPreferencesCubit>()),
          BlocProvider(create: (_) => sl<ThemeCubit>()),
          BlocProvider(create: (_) => sl<LocaleCubit>()),
        ],
        child: QuillApp(),
      ),
    ),
  );
}

class QuillApp extends StatelessWidget {
  const QuillApp({super.key});

  @override
  Widget build(BuildContext context) {
    
    final localeState = context.watch<LocaleCubit>().state;
    return ScreenUtilInit(
      designSize: const Size(390, 844),

      
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => MaterialApp.router(
        routerConfig: appRouter,
        title: 'Quill',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: context.watch<ThemeCubit>().state.flutterThemeMode,

        
        locale: localeState.locale,

        
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
      ),
    );
  }
}
