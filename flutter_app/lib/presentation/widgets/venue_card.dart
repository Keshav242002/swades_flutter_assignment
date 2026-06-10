import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/venue_model.dart';

class VenueCard extends StatelessWidget {
  final VenueModel venue;
  final VoidCallback onTap;

  const VenueCard({super.key, required this.venue, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withAlpha(13)),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImage(),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(venue.sportEmoji, style: const TextStyle(fontSize: 16)),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          venue.name,
                          style: Theme.of(context).textTheme.titleMedium,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on_rounded, size: 14, color: AppTheme.textSecondary),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          venue.location,
                          style: Theme.of(context).textTheme.bodyMedium,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppTheme.accentGreen.withAlpha(26),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppTheme.accentGreen.withAlpha(77)),
                        ),
                        child: Text(
                          '₹${venue.pricePerHour.toStringAsFixed(0)}/hr',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppTheme.accentGreen,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    if (venue.imageUrl.isEmpty) {
      return Container(
        height: 120,
        color: AppTheme.surfaceColor,
        child: Center(
          child: Text(venue.sportEmoji, style: const TextStyle(fontSize: 48)),
        ),
      );
    }
    return CachedNetworkImage(
      imageUrl: venue.imageUrl,
      height: 120,
      width: double.infinity,
      fit: BoxFit.cover,
      placeholder: (_, __) => Container(
        height: 120,
        color: AppTheme.surfaceColor,
        child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
      ),
      errorWidget: (_, __, ___) => Container(
        height: 120,
        color: AppTheme.surfaceColor,
        child: Center(child: Text(venue.sportEmoji, style: const TextStyle(fontSize: 48))),
      ),
    );
  }
}
