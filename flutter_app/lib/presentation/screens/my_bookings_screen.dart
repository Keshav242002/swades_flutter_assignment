import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../core/theme/app_theme.dart';
import '../blocs/booking/booking_bloc.dart';
import '../widgets/booking_card.dart';
import '../widgets/loading_widget.dart';
import '../widgets/error_widget.dart';
import '../widgets/empty_state_widget.dart';

class MyBookingsScreen extends StatefulWidget {
  final VoidCallback onBrowseVenues;
  const MyBookingsScreen({super.key, required this.onBrowseVenues});

  @override
  State<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<BookingBloc>().add(const BookingFetchRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Bookings')),
      body: BlocBuilder<BookingBloc, BookingState>(
        builder: (context, state) {
          if (state is BookingLoading || state is BookingInitial) {
            return const AppLoadingWidget(type: LoadingType.bookingList);
          }
          if (state is BookingError) {
            return AppErrorWidget(
              message: state.message,
              onRetry: () =>
                  context.read<BookingBloc>().add(const BookingFetchRequested()),
            );
          }
          if (state is BookingEmpty) {
            return AppEmptyWidget(
              title: 'No bookings yet!',
              subtitle: 'Browse venues and book your first slot.',
              icon: Icons.event_note_rounded,
              actionLabel: 'Browse Venues →',
              onAction: widget.onBrowseVenues,
            );
          }

          final bookings = switch (state) {
            BookingLoaded(:final bookings) => bookings,
            BookingCancelling(:final bookings) => bookings,
            _ => <dynamic>[],
          };

          final cancellingId = state is BookingCancelling ? state.cancellingId : null;
          final isFromCache = state is BookingLoaded && state.fromCache;

          return Column(
            children: [
              if (isFromCache)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  color: AppTheme.accentGreen.withAlpha(30),
                  child: Row(children: [
                    const Icon(Icons.offline_bolt_rounded,
                        size: 16, color: AppTheme.accentGreen),
                    const SizedBox(width: 8),
                    Text(
                      'Showing cached data — pull to refresh',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.accentGreen,
                          ),
                    ),
                  ]),
                ),
              Expanded(
                child: RefreshIndicator(
            color: AppTheme.accentGreen,
            backgroundColor: AppTheme.surfaceColor,
            onRefresh: () async {
              context.read<BookingBloc>().add(const BookingFetchRequested());
              await context.read<BookingBloc>().stream.firstWhere(
                    (s) => s is BookingLoaded || s is BookingError || s is BookingEmpty,
                  );
            },
            child: AnimationLimiter(
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: bookings.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final booking = bookings[index];
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 375),
                    child: SlideAnimation(
                      verticalOffset: 50,
                      child: FadeInAnimation(
                        child: BookingCard(
                          booking: booking,
                          isCancelling: cancellingId == booking.id,
                          onCancel: () => _confirmCancel(context, booking.id),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _confirmCancel(BuildContext context, int bookingId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.surfaceColor,
        title: const Text('Cancel Booking'),
        content: const Text('Are you sure you want to cancel this booking?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Keep'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context
                  .read<BookingBloc>()
                  .add(BookingCancelRequested(bookingId: bookingId));
            },
            child: const Text('Cancel Booking',
                style: TextStyle(color: AppTheme.errorColor)),
          ),
        ],
      ),
    );
  }
}
