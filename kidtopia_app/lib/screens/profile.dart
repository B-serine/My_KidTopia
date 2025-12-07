import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../assets/app_colors/app_colors.dart';
import '../logic/cubits/auth_cubit.dart';
import '../l10n/app_localizations.dart';
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _selectedIndex = 2;

  void _onBottomNavTap(int index) {
    if (index == _selectedIndex) return;
    setState(() => _selectedIndex = index);

    if (index == 0) {
      Navigator.pushReplacementNamed(context, '/');
    } else if (index == 1) {
      Navigator.pushReplacementNamed(context, '/categories');
    }
  }

  void _handleLogout() {
    context.read<AuthCubit>().signOut();
    Navigator.pushReplacementNamed(context, '/sign_in');
  }

  void _handleUpgradeToPremium() {
    context.read<AuthCubit>().upgradeToPremium();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated && state.user.isPremium) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.nowPremium), backgroundColor: brandYellow),
          );
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: brandRed),
          );
        }
      },
      builder: (context, state) {
        String username = l10n.guest;
        int totalScore = 0;
        bool isPremium = false;

        if (state is AuthAuthenticated) {
          username = state.user.name;
          totalScore = state.user.totalScore;
          isPremium = state.user.isPremium;
        }

        return Scaffold(
          appBar: AppBar(
            leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
            title: Text(l10n.profile),
            backgroundColor: brandPurple,
            foregroundColor: brandWhite,
            elevation: 0,
          ),
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [brandPurple.withOpacity(0.05), brandBackground],
              ),
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: brandPurple.withOpacity(0.2),
                          child: Icon(Icons.person, size: 60, color: brandPurple),
                        ),
                        if (isPremium)
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(color: brandYellow, shape: BoxShape.circle),
                              child: const Icon(Icons.star, color: Colors.white, size: 20),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    
                    Text(username, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, fontSize: 22)),
                    const SizedBox(height: 4),
                    
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                      decoration: BoxDecoration(
                        color: isPremium ? brandYellow.withOpacity(0.2) : brandPurple.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        isPremium ? l10n.premiumMember : l10n.freeMember,
                        style: TextStyle(color: isPremium ? brandYellow : brandPurple.withOpacity(0.9), fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _StatCard('$totalScore', l10n.points, Icons.stars),
                        _StatCard('${(totalScore / 100).floor()}', l10n.bestGames, Icons.emoji_events),
                        _StatCard('${isPremium ? 8 : 2}', l10n.unlocked, Icons.lock_open),
                      ],
                    ),
                    const SizedBox(height: 24),

                    _buildListTile(Icons.emoji_events, brandPurple, l10n.myScore, l10n.scorePoints(totalScore), () => Navigator.pushNamed(context, '/score')),
                    _buildListTile(Icons.payment, brandYellow, l10n.paymentSettings, null, () {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.paymentComingSoon)));
                    }),

                    const SizedBox(height: 24),

                    if (!isPremium)
                      ElevatedButton.icon(
                        onPressed: _handleUpgradeToPremium,
                        icon: const Icon(Icons.star, size: 22),
                        label: Text(l10n.becomePro, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: brandPurple,
                          foregroundColor: brandWhite,
                          minimumSize: const Size(double.infinity, 52),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          elevation: 2,
                        ),
                      ),

                    if (isPremium)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: brandYellow.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: brandYellow, width: 2),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.workspace_premium, color: brandYellow),
                            const SizedBox(width: 8),
                            Text(l10n.premiumMember, style: TextStyle(color: brandYellow, fontWeight: FontWeight.bold, fontSize: 16)),
                          ],
                        ),
                      ),

                    const SizedBox(height: 10),

                    OutlinedButton.icon(
                      onPressed: _handleLogout,
                      icon: const Icon(Icons.logout, size: 22),
                      label: Text(l10n.logout, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: brandRed,
                        minimumSize: const Size(double.infinity, 52),
                        side: BorderSide(color: brandTextLight.withOpacity(0.5), width: 2),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _selectedIndex,
            backgroundColor: brandWhite,
            selectedItemColor: brandPurple,
            unselectedItemColor: brandTextLight,
            onTap: _onBottomNavTap,
            items: [
              BottomNavigationBarItem(icon: const Icon(Icons.home_outlined), label: l10n.home),
              BottomNavigationBarItem(icon: const Icon(Icons.grid_view_rounded), label: l10n.categories),
              BottomNavigationBarItem(icon: const Icon(Icons.person_outline), label: l10n.profile),
            ],
          ),
        );
      },
    );
  }

  Widget _buildListTile(IconData icon, Color iconColor, String title, String? subtitle, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: brandWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: brandTextLight.withOpacity(0.1), spreadRadius: 1, blurRadius: 10, offset: const Offset(0, 2))],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: iconColor.withOpacity(0.08), borderRadius: BorderRadius.circular(12)),
          child: Icon(icon, color: iconColor, size: 28),
        ),
        title: Text(title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
        subtitle: subtitle != null ? Text(subtitle, style: TextStyle(color: brandTextLight)) : null,
        trailing: const Icon(Icons.arrow_forward_ios, color: brandTextLight, size: 18),
        onTap: onTap,
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String count;
  final String label;
  final IconData icon;
  const _StatCard(this.count, this.label, this.icon);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: brandWhite,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: brandTextLight.withOpacity(0.1), spreadRadius: 1, blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(
        children: [
          Icon(icon, color: brandPurple, size: 28),
          const SizedBox(height: 6),
          Text(count, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: brandTextDark)),
          const SizedBox(height: 2),
          Text(label, style: TextStyle(color: brandTextLight, fontSize: 11)),
        ],
      ),
    );
  }
}