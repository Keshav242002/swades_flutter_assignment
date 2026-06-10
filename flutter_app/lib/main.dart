import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/theme/app_theme.dart';
import 'firebase_options.dart';
import 'core/network/api_client.dart';
import 'data/datasources/auth_remote_datasource.dart';
import 'data/datasources/venue_remote_datasource.dart';
import 'data/datasources/booking_remote_datasource.dart';
import 'data/datasources/booking_local_datasource.dart';
import 'data/repositories/auth_repository.dart';
import 'data/repositories/venue_repository.dart';
import 'data/repositories/booking_repository.dart';
import 'presentation/blocs/auth/auth_bloc.dart';
import 'presentation/screens/login_screen.dart';
import 'presentation/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const QuickSlotApp());
}

class QuickSlotApp extends StatelessWidget {
  const QuickSlotApp({super.key});

  @override
  Widget build(BuildContext context) {
    final apiClient = ApiClient();

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<ApiClient>(create: (_) => apiClient),
        RepositoryProvider(
          create: (_) => AuthRepository(AuthRemoteDataSource(apiClient)),
        ),
        RepositoryProvider(
          create: (_) => VenueRepository(VenueRemoteDataSource(apiClient)),
        ),
        RepositoryProvider(
          create: (_) => BookingRepository(
            BookingRemoteDataSource(apiClient),
            BookingLocalDataSource(),
          ),
        ),
      ],
      child: BlocProvider(
        create: (ctx) => AuthBloc(ctx.read<AuthRepository>())
          ..add(const AuthCheckStatus()),
        child: MaterialApp(
          title: 'QuickSlot',
          theme: AppTheme.darkTheme,
          debugShowCheckedModeBanner: false,
          home: const _AuthGate(),
        ),
      ),
    );
  }
}

class _AuthGate extends StatelessWidget {
  const _AuthGate();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      // Only rebuild for top-level navigation transitions.
      // Keeping AuthLoading and AuthError out of buildWhen means LoginScreen
      // stays mounted during a login attempt, so its BlocListener receives
      // the AuthError state transition and can show the error SnackBar.
      buildWhen: (_, current) =>
          current is AuthInitial ||
          current is AuthAuthenticated ||
          current is AuthUnauthenticated,
      builder: (context, state) {
        if (state is AuthAuthenticated) return const HomeScreen();
        if (state is AuthUnauthenticated) return const LoginScreen();
        // AuthInitial — show splash while checking persisted session
        return const Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('⚡', style: TextStyle(fontSize: 64)),
                SizedBox(height: 16),
                Text(
                  'QuickSlot',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.accentGreen,
                  ),
                ),
                SizedBox(height: 32),
                CircularProgressIndicator(color: AppTheme.accentGreen),
              ],
            ),
          ),
        );
      },
    );
  }
}
