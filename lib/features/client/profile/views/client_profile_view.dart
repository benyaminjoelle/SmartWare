import 'package:flutter/material.dart';
import 'package:smartware/features/client/profile/widgets/profile_acount_management.dart';
import 'package:smartware/features/client/profile/widgets/profile_completion.dart';
import '../widgets/logout_tile.dart';
import '../widgets/profile_header.dart';

class ClientProfileView extends StatelessWidget {
  const ClientProfileView({super.key});

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

                      ProfileHeader(),

                      SizedBox(height: 32),

                      ProfileCompletionCard(),

                      SizedBox(height: 28),

                      AccountManagementSection(),

                      SizedBox(height: 16),

                      LogoutTile(),
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
