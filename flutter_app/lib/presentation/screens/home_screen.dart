import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/datasources/venue_remote_datasource.dart';
import '../../data/datasources/booking_remote_datasource.dart';
import '../../data/repositories/venue_repository.dart';
import '../../data/repositories/booking_repository.dart';
import '../blocs/venue/venue_bloc.dart';
import '../blocs/booking/booking_bloc.dart';
import 'venue_list_screen.dart';
import 'my_bookings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (ctx) => VenueRepository(
            VenueRemoteDataSource(ctx.read()),
          ),
        ),
        RepositoryProvider(
          create: (ctx) => BookingRepository(
            BookingRemoteDataSource(ctx.read()),
          ),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (ctx) => VenueBloc(ctx.read<VenueRepository>()),
          ),
          BlocProvider(
            create: (ctx) => BookingBloc(ctx.read<BookingRepository>()),
          ),
        ],
        child: Builder(
          builder: (context) => Scaffold(
            body: IndexedStack(
              index: _currentIndex,
              children: [
                const VenueListScreen(),
                MyBookingsScreen(
                  onBrowseVenues: () => setState(() => _currentIndex = 0),
                ),
              ],
            ),
            bottomNavigationBar: Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.white.withAlpha(13)),
                ),
              ),
              child: BottomNavigationBar(
                currentIndex: _currentIndex,
                onTap: (index) => setState(() => _currentIndex = index),
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.sports_rounded),
                    label: 'Venues',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.event_note_rounded),
                    label: 'My Bookings',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
