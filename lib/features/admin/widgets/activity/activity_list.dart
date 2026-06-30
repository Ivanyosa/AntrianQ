import 'package:flutter/material.dart';

import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_shadow.dart';
import '../../../../core/theme/app_text_style.dart';

import 'activity_tile.dart';

class ActivityList extends StatelessWidget {
  const ActivityList({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: AppShadow.soft,
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Text("Aktivitas Terbaru", style: AppTextStyles.heading3),

          const SizedBox(height: 18),

          const ActivityTile(
            icon: Icons.person_add,
            color: Colors.blue,
            title: "User baru mendaftar",
            subtitle: "Akun baru berhasil dibuat",
            time: "2 menit",
          ),

          Divider(),

          const ActivityTile(
            icon: Icons.store,
            color: Colors.green,
            title: "Usaha disetujui",
            subtitle: "Barbershop A",
            time: "12 menit",
          ),

          Divider(),

          const ActivityTile(
            icon: Icons.edit_document,
            color: Colors.orange,
            title: "Request perubahan",
            subtitle: "Klinik Sehat",
            time: "35 menit",
          ),

          Divider(),

          const ActivityTile(
            icon: Icons.groups,
            color: Colors.purple,
            title: "Owner baru",
            subtitle: "Owner berhasil mendaftar",
            time: "1 jam",
          ),
        ],
      ),
    );
  }
}
