import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:quill/core/constants/app_constants.dart';
import 'package:quill/core/di/injection_container.dart';
import 'package:quill/core/router/main_shell.dart';
import 'package:quill/core/storage/app_storage.dart';
import 'package:quill/core/usecases/base_usecase.dart';
import 'package:quill/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:quill/features/auth/presentation/bloc/auth_event.dart';
import 'package:quill/features/auth/presentation/screens/auth_choose_screen.dart';
import 'package:quill/features/auth/presentation/screens/login/login_screen.dart';
import 'package:quill/features/auth/presentation/screens/signup/signup_screen.dart';
import 'package:quill/features/home/domain/entities/book_entity.dart';
import 'package:quill/features/home/domain/repositories/book_repository.dart';
import 'package:quill/features/home/domain/usecases/fetch_books_usecase.dart';
import 'package:quill/features/home/domain/usecases/get_book_by_id_usecase.dart';
import 'package:quill/features/home/presentation/bloc/home_bloc.dart';
import 'package:quill/features/home/presentation/bloc/home_event.dart';
import 'package:quill/features/home/presentation/screens/book_details_screen.dart';
import 'package:quill/features/home/presentation/screens/home_screen.dart';
import 'package:quill/features/library/domain/UseCases/add_to_wishlist.dart';
import 'package:quill/features/library/domain/UseCases/fetch_wishlist.dart';
import 'package:quill/features/library/domain/UseCases/remove_from_wishlist.dart';
import 'package:quill/features/library/presentation/bloc/library_bloc.dart';
import 'package:quill/features/library/presentation/bloc/library_event.dart';
import 'package:quill/features/library/presentation/screens/library_screen.dart';
import 'package:quill/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'app_routes.dart';

final appRouter = GoRouter(
  debugLogDiagnostics: true,

  routes: [
    ShellRoute(
      routes: [
        /// Home
        GoRoute(
          path: AppRoutes.home,
          name: AppRoutes.home,
          builder: (context, state) => BlocProvider(
            create: (context) => sl<HomeBloc>()..add(FetchHomeBooksEvent()),
            child: HomeScreen(),
          ),
        ),

        /// Library
        GoRoute(
          path: AppRoutes.library,
          name: AppRoutes.library,
          builder: (context, state) => LibraryScreen(),
        ),

        /// Discover
        GoRoute(
          path: AppRoutes.discover,
          name: AppRoutes.discover,
          builder: (context, state) =>
              const Scaffold(body: Center(child: Text('Discover'))),
        ),

        /// Profile
        GoRoute(
          path: AppRoutes.profile,
          name: AppRoutes.profile,
          builder: (context, state) =>
              const Scaffold(body: Center(child: Text('Profile'))),
        ),
      ],

      builder: (context, state, child) => MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => LibraryBloc(
              addToWishlistUsecase: sl<AddToWishlistUsecase>(),
              removeFromWishlistUsecase: sl<RemoveFromWishlistUsecase>(),
              fetchWishlistUsecase: sl<FetchWishlistUsecase>(),
            )..add(FetchWishlistEvent()),
          ),

          BlocProvider(
            create: (context) =>
                sl<AuthBloc>()..add(FetchUserDataEvent(params: NoParams())),
          ),
        ],
        child: MainShell(state: state, child: child),
      ),
    ),

    /// Book Details
    GoRoute(
      path: AppRoutes.bookDeatails,
      name: AppRoutes.bookDeatails,
      builder: (context, state) {
        final extra = state.extra;
        final book = extra is BookEntity ? extra : null;
        final bookId = extra is String ? extra : null;
        return BlocProvider(
          create: (context) => HomeBloc(
            fetchBooksUsecase: sl<FetchBooksUsecase>(),
            bookRepository: sl<BookRepository>(),
            getBookByIdUsecase: sl<GetBookByIdUsecase>(),
          ),
          child: BookDetailsScreen(book: book, bookId: bookId),
        );
      },
    ),

    /// OnBoarding
    GoRoute(
      path: AppRoutes.onboarding,
      name: AppRoutes.onboarding,
      builder: (context, state) => OnboardingPage(),
    ),

    /// Signup
    GoRoute(
      path: AppRoutes.signup,
      name: AppRoutes.signup,
      builder: (context, state) => BlocProvider(
        create: (context) => sl<AuthBloc>(),
        child: SignupScreen(),
      ),
    ),

    /// choose
    GoRoute(
      path: AppRoutes.choose,
      name: AppRoutes.choose,
      builder: (context, state) => AuthChooseScreen(),
    ),

    /// login
    GoRoute(
      path: AppRoutes.login,
      name: AppRoutes.login,
      builder: (context, state) => BlocProvider(
        create: (context) => sl<AuthBloc>(),
        child: LoginScreen(),
      ),
    ),
  ],

  redirect: (context, state) async {
    final storage = sl<AppStorage>();
    final prefs = await SharedPreferences.getInstance();
    final String? token = await storage.readAccessToken();
    final bool? seenOnboarding = prefs.getBool(AppConstants.seenOnboarding);

    final currentLocation = state.uri.toString();
    final List<String> authRoutes = [
      AppRoutes.choose,
      AppRoutes.signup,
      AppRoutes.login,
      AppRoutes.onboarding,
    ];

    if (seenOnboarding == true) {
      if (token != null) {
        if (authRoutes.contains(currentLocation)) {
          return AppRoutes.home;
        } else {
          return null;
        }
      } else {
        if (authRoutes.contains(currentLocation)) {
          return null;
        } else {
          return AppRoutes.choose;
        }
      }
    } else {
      return AppRoutes.onboarding;
    }
  },
);
