import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:go_router/go_router.dart";
import "package:capital_commons/features/user/user_cubit.dart";
import "package:capital_commons/core/service_locator.dart";

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool notificationsEnabled = true;
  bool darkModeEnabled = true;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 1024;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white70),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () {
            context.go(
              "/investor/dashboard",
            ); // Always go back to investor dashboard
          },
        ),
        title: const Text(
          "Settings",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
      ),
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0A1628), Color(0xFF1A2E4A), Color(0xFF0D3B66)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isDesktop ? 64 : 24,
              vertical: 24,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Account Settings",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),

                ListTile(
                  leading: const Icon(
                    Icons.person_outline,
                    color: Colors.white70,
                  ),
                  title: const Text(
                    "Profile",
                    style: TextStyle(color: Colors.white),
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white70,
                    size: 16,
                  ),
                  onTap: () {},
                ),
                const Divider(color: Colors.white24),

                ListTile(
                  leading: const Icon(
                    Icons.lock_outline,
                    color: Colors.white70,
                  ),
                  title: const Text(
                    "Change Password",
                    style: TextStyle(color: Colors.white),
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white70,
                    size: 16,
                  ),
                  onTap: () {},
                ),
                const Divider(color: Colors.white24),

                ListTile(
                  leading: const Icon(
                    Icons.notifications_none,
                    color: Colors.white70,
                  ),
                  title: const Text(
                    "Notifications",
                    style: TextStyle(color: Colors.white),
                  ),
                  trailing: Switch(
                    value: notificationsEnabled,
                    onChanged: (val) {
                      setState(() {
                        notificationsEnabled = val;
                      });
                    },
                    activeColor: Colors.blueAccent,
                  ),
                ),
                const Divider(color: Colors.white24),

                ListTile(
                  leading: const Icon(
                    Icons.dark_mode_outlined,
                    color: Colors.white70,
                  ),
                  title: const Text(
                    "Dark Mode",
                    style: TextStyle(color: Colors.white),
                  ),
                  trailing: Switch(
                    value: darkModeEnabled,
                    onChanged: (val) {
                      setState(() {
                        darkModeEnabled = val;
                      });
                    },
                    activeColor: Colors.blueAccent,
                  ),
                ),
                const Divider(color: Colors.white24),

                // Logout
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.white70),
                  title: const Text(
                    "Logout",
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () async {
                    // Call the UserCubit to log out
                    await getIt<UserCubit>().logout();

                    // Navigate to landing page
                    context.go("/");
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
