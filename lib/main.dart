import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quill/core/di/injection_container.dart';
import 'package:quill/core/locale/cubit/locale_cubit.dart';
import 'package:quill/core/router/app_router.dart';
import 'package:quill/core/theme/app_theme.dart';
import 'package:quill/core/theme/cubit/theme_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await setupDI();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      // دي لغة الطوارئ، لو حصلت مشكلة أو النظام شغال بلغة تالتة خالص، افتح التطبيق بالإنجليزي
      fallbackLocale: const Locale('en'),
      path: 'assets/translations',
      child: MultiBlocProvider(
        providers: [
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
    /// عشان يسمعو لاي تغيير في الحالة سواء اللغو او الثيم context.watch() هنا احنا خليناهم
    final localeState = context.watch<LocaleCubit>().state;
    return ScreenUtilInit(
      designSize: const Size(390, 844),

      /// بتخلي الخطوط تظبط نفسها لو اليوزر غير حجم خط النظام، وبتدعم الشاشة المقسومة.
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => MaterialApp.router(
        routerConfig: appRouter,
        title: 'Quill',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: ThemeMode.system,

        /// Locale State بياخد اللغة الحالية من ال
        locale: localeState.locale,

        /// اللي اتظبط فوق context بياخدو القيم بتاعتهم من ال
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
      ),
    );
  }
}
