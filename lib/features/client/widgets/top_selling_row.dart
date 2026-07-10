import 'package:flutter/material.dart';
import 'package:smartware/features/client/widgets/product_card.dart';

class TopSellingRow extends StatelessWidget {
  const TopSellingRow({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final media = MediaQuery.of(context).size;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header Row
        Padding(
          padding: EdgeInsets.symmetric(horizontal: media.width * 0.05, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Top Selling",
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              TextButton(
                onPressed: () {
                  // TODO: Navigate to a dedicated "See All" grid view page
                },
                child: const Text("See All"),
              ),
            ],
          ),
        ),

        // Horizontal Free-Flowing Product List Container
        SizedBox(
          height: 240, // Fixed height keeps product card bounds stable
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 5, // Replace with your controller data length later
            padding: EdgeInsets.only(left: media.width * 0.05, right: 8),
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return const ProductCard();
            },
          ),
        ),
      ],
    );
  }
}