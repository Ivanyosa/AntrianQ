import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../auth/pages/login_page.dart';
import '../../owner/pages/owner_dashboard_page.dart';
import '../providers/queue_provider.dart';
import 'owner_registration_page.dart';

import 'package:url_launcher/url_launcher.dart';

class ProfileTab extends ConsumerWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = Supabase.instance.client.auth.currentUser;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const CircleAvatar(radius: 40, child: Icon(Icons.person, size: 40)),

          const SizedBox(height: 16),

          Center(
            child: Text(
              user?.email ?? 'User',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),

          const SizedBox(height: 32),

          FutureBuilder<bool>(
            future: ref.read(queueProvider).isOwner(),
            builder: (context, snapshot) {
              final isOwner = snapshot.data ?? false;

              return Card(
                child: ListTile(
                  leading: Icon(isOwner ? Icons.dashboard : Icons.store),

                  title: Text(isOwner ? "Dashboard Owner" : "Jadi Owner"),

                  subtitle: Text(
                    isOwner ? "Kelola usaha Anda" : "Daftarkan usaha Anda",
                  ),

                  trailing: const Icon(Icons.chevron_right),

                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => isOwner
                            ? const OwnerDashboardPage()
                            : const OwnerRegistrationPage(),
                      ),
                    );
                  },
                ),
              );
            },
          ),

          Card(
            child: ListTile(
              leading: const Icon(Icons.bug_report),

              title: const Text("Lapor Bug"),

              subtitle: const Text("Kirim laporan masalah"),

              trailing: const Icon(Icons.open_in_new),

              onTap: () async {
                final url = Uri.parse(
                  'https://docs.google.com/forms/d/e/1FAIpQLSdfX7UBErdInazEQ_-U998S2jglpxUt9WPvt6FAcdALVCCpZw/viewform?usp=publish-editor',
                );

                if (await canLaunchUrl(url)) {
                  await launchUrl(url, mode: LaunchMode.externalApplication);
                }
              },
            ),
          ),

          Card(
            child: ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),

              title: const Text("Logout", style: TextStyle(color: Colors.red)),

              onTap: () async {
                await Supabase.instance.client.auth.signOut();

                if (context.mounted) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginPage()),
                    (route) => false,
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
