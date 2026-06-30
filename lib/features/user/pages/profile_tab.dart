import 'package:antrianq/features/auth/providers/profile_provider.dart';
import 'package:antrianq/features/user/widgets/profile/avatar_picker.dart';
import 'package:antrianq/features/user/widgets/profile/profile_avatar.dart';
import 'package:antrianq/features/user/widgets/profile/profile_header.dart';
import 'package:antrianq/features/user/widgets/profile/profile_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../auth/pages/login_page.dart';
import '../../owner/pages/owner_dashboard_page.dart';
import '../providers/queue_provider.dart';
import 'owner_registration_page.dart';

class ProfileTab extends ConsumerWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = Supabase.instance.client.auth.currentUser;
    final profile = ref.watch(profileProvider);

    return profile.when(
      loading: () => const Center(child: CircularProgressIndicator()),

      error: (e, _) => Center(child: Text(e.toString())),

      data: (data) {
        final avatarIndex = data['avatar_index'] ?? 1;

        return SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Center(
                child: ProfileAvatar(
                  avatarIndex: avatarIndex,
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (_) => AvatarPicker(
                        onSelected: (avatar) async {
                          await ref.read(queueProvider).updateAvatar(avatar);
                          ref.invalidate(profileProvider);
                        },
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 16),

              ProfileHeader(
                name: data['username'] ?? "Pengguna",
                email: user?.email ?? "",
              ),

              const SizedBox(height: 32),

              FutureBuilder<bool>(
                future: ref.read(queueProvider).isOwner(),
                builder: (context, snapshot) {
                  final isOwner = snapshot.data ?? false;

                  return ProfileTile(
                    icon: isOwner ? Icons.dashboard : Icons.storefront,
                    title: isOwner ? "Dashboard Owner" : "Daftar Menjadi Owner",
                    subtitle: isOwner
                        ? "Kelola usaha Anda"
                        : "Daftarkan usaha Anda",
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
                  );
                },
              ),

              ProfileTile(
                icon: Icons.bug_report_outlined,
                title: "Bantuan & Lapor Bug",
                subtitle: "Laporkan masalah aplikasi",
                onTap: () async {
                  final url = Uri.parse(
                    "https://docs.google.com/forms/d/e/1FAIpQLSdfX7UBErdInazEQ_-U998S2jglpxUt9WPvt6FAcdALVCCpZw/viewform?usp=publish-editor",
                  );

                  if (await canLaunchUrl(url)) {
                    await launchUrl(url, mode: LaunchMode.externalApplication);
                  }
                },
              ),

              ProfileTile(
                icon: Icons.logout,
                iconColor: Colors.red,
                title: "Keluar",
                subtitle: "Keluar dari akun",
                onTap: () {
                  showLogoutDialog(context, ref);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> showLogoutDialog(BuildContext context, WidgetRef ref) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),

          title: Row(
            children: const [
              Icon(Icons.logout_rounded, color: Colors.red),

              SizedBox(width: 10),

              Text("Keluar Akun"),
            ],
          ),

          content: const Text("Apakah Anda yakin ingin keluar dari akun ini?"),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text("Batal"),
            ),

            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text("Keluar"),
            ),
          ],
        );
      },
    );

    if (result == true) {
      await Supabase.instance.client.auth.signOut();

      ref.invalidate(profileProvider);

      if (context.mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const LoginPage()),
          (route) => false,
        );
      }
    }
  }
}
