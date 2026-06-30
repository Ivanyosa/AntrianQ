import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../user/providers/queue_provider.dart';

import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_shadow.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_style.dart';

class OwnerEditBusinessPage extends ConsumerStatefulWidget {
  final Map<String, dynamic> business;

  const OwnerEditBusinessPage({super.key, required this.business});

  @override
  ConsumerState<OwnerEditBusinessPage> createState() =>
      _OwnerEditBusinessPageState();
}

class _OwnerEditBusinessPageState extends ConsumerState<OwnerEditBusinessPage> {
  late final TextEditingController nameController;
  late final TextEditingController locationController;
  late final TextEditingController descriptionController;
  late final TextEditingController durationController;
  late final TextEditingController maxQueueController;

  bool loading = false;

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController(text: widget.business['name']);

    locationController = TextEditingController(
      text: widget.business['location'],
    );

    descriptionController = TextEditingController(
      text: widget.business['description'],
    );

    durationController = TextEditingController(
      text: widget.business['service_duration'].toString(),
    );

    maxQueueController = TextEditingController(
      text: widget.business['max_daily_queue'].toString(),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    locationController.dispose();
    descriptionController.dispose();
    durationController.dispose();
    maxQueueController.dispose();
    super.dispose();
  }

  Future<void> submit() async {
    setState(() {
      loading = true;
    });

    try {
      await ref
          .read(queueProvider)
          .submitBusinessUpdate(
            businessId: widget.business['id'],
            payload: {
              'name': nameController.text,
              'location': locationController.text,
              'description': descriptionController.text,
              'service_duration': int.parse(durationController.text),
              'max_daily_queue': int.parse(maxQueueController.text),
            },
          );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Perubahan berhasil diajukan")),
        );

        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Usaha"), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: .08),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.storefront,
                    color: AppColors.primary,
                    size: 34,
                  ),
                ),

                const SizedBox(width: 16),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.business['name'],
                        style: AppTextStyles.heading2,
                      ),

                      const SizedBox(height: 4),

                      Text(
                        widget.business['status'].toUpperCase(),
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(AppRadius.lg),
              ),
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.info_outline, color: Colors.blue),

                  SizedBox(width: 12),

                  Expanded(
                    child: Text(
                      "Perubahan data usaha akan ditinjau admin sebelum diterapkan.",
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppRadius.xl),
                boxShadow: AppShadow.soft,
              ),
              child: Column(
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: "Nama Usaha"),
                  ),

                  const SizedBox(height: 12),

                  TextField(
                    controller: locationController,
                    decoration: const InputDecoration(labelText: "Lokasi"),
                  ),

                  const SizedBox(height: 12),

                  TextField(
                    controller: descriptionController,
                    maxLines: 3,
                    decoration: const InputDecoration(labelText: "Deskripsi"),
                  ),

                  const SizedBox(height: 12),

                  TextField(
                    controller: durationController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Estimasi (menit)",
                    ),
                  ),

                  const SizedBox(height: 12),

                  TextField(
                    controller: maxQueueController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: "Max Antrian"),
                  ),

                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: loading ? null : submit,
                      child: Text(
                        loading ? "Menyimpan..." : "AJUKAN PERUBAHAN",
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
