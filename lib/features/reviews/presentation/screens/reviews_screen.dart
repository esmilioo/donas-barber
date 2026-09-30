import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';

class ReviewsScreen extends StatelessWidget {
  const ReviewsScreen({super.key});

  static const _reviews = [
    {
      'name': 'Raffaele Buonarilli',
      'initials': 'RB',
      'date': '24 Aprile 2025',
      'stars': 5,
      'text':
          'Professionalità e cortesia unica, sono andato con un\'idea ben precisa in mente e più che soddisfatto del risultato finale del mio taglio.',
      'photos': 2,
    },
    {
      'name': 'Michele di Marzio',
      'initials': 'MD',
      'date': '5 Aprile 2025',
      'stars': 5,
      'text':
          'Servizio impeccabile, i ragazzi sono molto gentili ma il fatto di aver aspettato un minuto prima di sedermi, nonostante avessi prenotato.',
      'photos': 0,
    },
    {
      'name': 'Stefano Rosari',
      'initials': 'SR',
      'date': '7 Aprile 2025',
      'stars': 4,
      'text':
          'Ottima esperienza, ambiente curato e personale professionale. Tornerò sicuramente.',
      'photos': 0,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.textPrimary, // sfondo Milk
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: GestureDetector(
                  onTap: () => context.pop(),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.onAccent.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.close_rounded,
                        color: AppColors.onAccent, size: 20),
                  ),
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 8),
                    const Text(
                      'Fai sapere al tuo\nbarber quanto è\nstato bravo',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 30,
                        height: 1.15,
                        fontWeight: FontWeight.w900,
                        color: AppColors.onAccent,
                        letterSpacing: -0.8,
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'Recensisci il tuo barbiere, e supportalo\nnella crescita del suo salone',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.5,
                        color: AppColors.onAccent,
                      ),
                    ),
                    const SizedBox(height: 28),
                    ..._reviews.map(_reviewCard).toList(),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _reviewCard(Map<String, dynamic> r) {
    final stars = r['stars'] as int;
    final photos = r['photos'] as int;
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.onAccent,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: AppColors.cardElevated,
                child: Text(
                  r['initials'] as String,
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    color: AppColors.textPrimary,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      r['name'] as String,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      r['date'] as String,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: List.generate(
              5,
              (i) => Icon(
                i < stars ? Icons.star_rounded : Icons.star_border_rounded,
                size: 16,
                color: AppColors.accent,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            r['text'] as String,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 13,
              height: 1.45,
              color: AppColors.textSecondary,
            ),
          ),
          if (photos > 0) ...[
            const SizedBox(height: 12),
            Row(
              children: List.generate(
                photos,
                (i) => Container(
                  margin: const EdgeInsets.only(right: 8),
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: AppColors.cardElevated,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.image_rounded,
                      color: AppColors.textMuted, size: 24),
                ),
              ),
            ),
          ],
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () {},
            child: const Text(
              'Continua a leggere ›',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}