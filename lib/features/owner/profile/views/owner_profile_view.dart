import 'package:flutter/material.dart';
import 'package:smartware/features/owner/profile/widgets/owner_logout_tile.dart';
import 'package:smartware/features/owner/profile/widgets/owner_profile_account_management.dart';
import 'package:smartware/features/owner/profile/widgets/owner_profile_completion_card.dart';
import 'package:smartware/features/owner/profile/widgets/owner_profile_header.dart';


class OwnerProfileView extends StatelessWidget {
  const OwnerProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final isTablet = media.size.width > 600;

    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: media.size.width * 0.05,
                vertical: 20,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: isTablet ? 520 : double.infinity,
                  ),
                  child: const Column(
                    children: [
                      SizedBox(height: 24),

                      OwnerProfileHeader(),

                      SizedBox(height: 32),

                      OwnerProfileCompletionCard(),

                      SizedBox(height: 28),

                      OwnerProfileAccountManagement(),

                      SizedBox(height: 16),

                      OwnerLogoutTile(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
