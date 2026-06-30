import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/queue_provider.dart';

import 'dart:io';
import 'package:image_picker/image_picker.dart';

class OwnerRegistrationPage extends ConsumerStatefulWidget {
  const OwnerRegistrationPage({super.key});

  @override
  ConsumerState<OwnerRegistrationPage> createState() =>
      _OwnerRegistrationPageState();
}

class _OwnerRegistrationPageState extends ConsumerState<OwnerRegistrationPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _durationController = TextEditingController();
  final _maxQueueController = TextEditingController();

  XFile? selectedImage;

  bool isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    _durationController.dispose();
    _maxQueueController.dispose();
    super.dispose();
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();

    final image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        selectedImage = image;
      });
    }
  }

  Future<void> submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
    });

    try {
      await ref
          .read(queueProvider)
          .registerBusiness(
            name: _nameController.text.trim(),
            location: _locationController.text.trim(),
            description: _descriptionController.text.trim(),
            serviceDuration: int.parse(_durationController.text),
            maxDailyQueue: int.parse(_maxQueueController.text),
            image: selectedImage,
          );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Pengajuan berhasil dikirim")),
        );

        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Jadi Owner")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              GestureDetector(
                onTap: pickImage,
                child: Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: selectedImage == null
                      ? const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add_a_photo, size: 42),
                              SizedBox(height: 8),
                              Text("Upload Logo Usaha"),
                            ],
                          ),
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(18),
                          child: Image.file(
                            File(selectedImage!.path),
                            fit: BoxFit.cover,
                          ),
                        ),
                ),
              ),
              TextFormField(
                controller: _nameController,

                decoration: const InputDecoration(labelText: "Nama Usaha"),
                validator: (value) => value!.isEmpty ? "Wajib diisi" : null,
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(labelText: "Lokasi"),
                validator: (value) => value!.isEmpty ? "Wajib diisi" : null,
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: "Deskripsi"),
                maxLines: 3,
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _durationController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Estimasi Layanan (menit)",
                ),
                validator: (value) => value!.isEmpty ? "Wajib diisi" : null,
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _maxQueueController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Maksimal Antrian Harian",
                ),
                validator: (value) => value!.isEmpty ? "Wajib diisi" : null,
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading ? null : submit,
                  child: isLoading
                      ? const CircularProgressIndicator()
                      : const Text("Ajukan Menjadi Owner"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
