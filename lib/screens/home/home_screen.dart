import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import '../../utils/routes.dart';
import '../../utils/constants.dart';
import '../../providers/auth_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  late Timer _timer;
  DateTime _currentTime = DateTime.now();

  @override
  void initState() {
    super.initState();

    /// Live clock updating every second
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _currentTime = DateTime.now();
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String getFormattedTime() {
    final time = TimeOfDay.fromDateTime(_currentTime).format(context);
    final date =
        "${_currentTime.day}/${_currentTime.month}/${_currentTime.year}";
    return "$date  |  $time";
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text(""),
        elevation: 0,
      ),

      /// Drawer Menu
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [

            Container(
              padding: const EdgeInsets.fromLTRB(20, 54, 20, 20),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF0B4F4B), AppColors.primary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  CircleAvatar(
                    radius: 26,
                    backgroundColor: Color(0x33FFFFFF),
                    child: Icon(Icons.drive_eta_rounded,
                        color: Colors.white, size: 28),
                  ),

                  SizedBox(height: 12),

                  Text(
                    'Driver Menu',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),

            _DrawerItem(
              icon: Icons.history,
              title: 'Trip History',
              onTap: () => Navigator.pushNamed(context, AppRoutes.tripHistory),
            ),

            _DrawerItem(
              icon: Icons.local_parking,
              title: 'Parking',
              onTap: () => Navigator.pushNamed(context, AppRoutes.parking),
            ),

            _DrawerItem(
              icon: Icons.warning_rounded,
              title: 'Accidents',
              onTap: () =>
                  Navigator.pushNamed(context, AppRoutes.accidentDetection),
            ),

            _DrawerItem(
              icon: Icons.gavel_rounded,
              title: 'Violations',
              onTap: () =>
                  Navigator.pushNamed(context, AppRoutes.ruleViolation),
            ),

            _DrawerItem(
              icon: Icons.map_rounded,
              title: 'Simulate Reroute',
              onTap: () => Navigator.pushNamed(context, AppRoutes.rerouting),
            ),
          ],
        ),
      ),

      body: LayoutBuilder(
        builder: (context, constraints) {

          final wide = constraints.maxWidth > 820;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// DATE + TIME
                Text(
                  getFormattedTime(),
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.mutedText,
                  ),
                ),

                const SizedBox(height: 6),

                /// WELCOME TEXT
                Consumer<AuthProvider>(
                  builder: (context, authProvider, _) {
                    return Text(
                      "Welcome ${authProvider.userName} 👋",
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: AppColors.text,
                      ),
                    );
                  },
                ),

                const SizedBox(height: 18),

                /// SEARCH BAR
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.circular(AppConstants.borderRadius),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),

                  child: const TextField(
                    decoration: InputDecoration(
                      hintText: "Search trips, parking, violations...",
                      prefixIcon: Icon(Icons.search),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),

                const SizedBox(height: 22),

                /// DASHBOARD GRID
                GridView.count(
                  crossAxisCount: wide ? 3 : 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  childAspectRatio: wide ? 1.5 : 1.1,
                  children: [

                    _AnimatedCard(
                      child: _ActionCard(
                        icon: Icons.history_toggle_off_rounded,
                        title: 'Trip History',
                        subtitle: 'Review completed drives',
                        onTap: () => Navigator.pushNamed(
                            context, AppRoutes.tripHistory),
                      ),
                    ),

                    _AnimatedCard(
                      child: _ActionCard(
                        icon: Icons.local_parking_rounded,
                        title: 'Parking',
                        subtitle: 'Find nearby parking',
                        onTap: () =>
                            Navigator.pushNamed(context, AppRoutes.parking),
                      ),
                    ),

                    _AnimatedCard(
                      child: _ActionCard(
                        icon: Icons.warning_amber_rounded,
                        title: 'Accidents',
                        subtitle: 'Report incidents',
                        onTap: () => Navigator.pushNamed(
                            context, AppRoutes.accidentDetection),
                      ),
                    ),

                    _AnimatedCard(
                      child: _ActionCard(
                        icon: Icons.gavel_rounded,
                        title: 'Violations',
                        subtitle: 'Check rule violations',
                        onTap: () =>
                            Navigator.pushNamed(context, AppRoutes.ruleViolation),
                      ),
                    ),

                    _AnimatedCard(
                      child: _ActionCard(
                        icon: Icons.route_rounded,
                        title: 'Rerouting',
                        subtitle: 'Simulate alternate routes',
                        onTap: () =>
                            Navigator.pushNamed(context, AppRoutes.rerouting),
                      ),
                    ),

                    _AnimatedCard(
                      child: _ActionCard(
                        icon: Icons.account_circle_rounded,
                        title: 'Profile',
                        subtitle: 'Manage account',
                        onTap: () =>
                            Navigator.pushNamed(context, AppRoutes.profile),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _AnimatedCard extends StatefulWidget {

  final Widget child;

  const _AnimatedCard({required this.child});

  @override
  State<_AnimatedCard> createState() => _AnimatedCardState();
}

class _AnimatedCardState extends State<_AnimatedCard>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _scale = Tween<double>(begin: 1, end: 0.96).animate(_controller);
  }

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),

      child: ScaleTransition(
        scale: Tween(begin: 1.0, end: 0.96).animate(
          CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
        ),
        child: widget.child,
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {

  const _DrawerItem({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {

    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title),
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
    );
  }
}

class _ActionCard extends StatelessWidget {

  const _ActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {

    return InkWell(
      borderRadius: BorderRadius.circular(AppConstants.borderRadius),
      onTap: onTap,

      child: Card(
        elevation: 2,

        child: Padding(
          padding: const EdgeInsets.all(18),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [

              Icon(icon, size: 30, color: AppColors.primary),

              const SizedBox(height: 12),

              Text(
                title,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: AppColors.text,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                subtitle,
                style: AppStyles.caption,
              ),
            ],
          ),
        ),
      ),
    );
  }
}