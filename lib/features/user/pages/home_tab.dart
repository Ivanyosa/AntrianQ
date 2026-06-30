import 'package:antrianq/features/auth/providers/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/home/home_header.dart';
import '../widgets/home/home_search.dart';
import '../widgets/home/home_slider.dart';
import '../widgets/home/status_filter.dart';
import '../widgets/home/business_list.dart';

class HomeTab extends ConsumerStatefulWidget {
  const HomeTab({super.key});

  @override
  ConsumerState<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends ConsumerState<HomeTab> {
  final searchController = TextEditingController();

  String selectedStatus = 'all';
  String search = "";

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Consumer(
                builder: (context, ref, _) {
                  final profile = ref.watch(profileProvider);

                  return profile.when(
                    loading: () =>
                        const HomeHeader(username: "...", avatarIndex: 1),

                    error: (_, __) =>
                        const HomeHeader(username: "User", avatarIndex: 1),

                    data: (data) => HomeHeader(
                      username: data['username'] ?? 'User',
                      avatarIndex: data['avatar_index'] ?? 1,
                    ),
                  );
                },
              ),

              const SizedBox(height: 20),

              HomeSearch(
                controller: searchController,
                onChanged: (value) {
                  setState(() {
                    search = value;
                  });
                },
              ),

              const SizedBox(height: 20),

              const HomeSlider(),

              const SizedBox(height: 20),

              StatusFilter(
                selectedStatus: selectedStatus,
                onChanged: (value) {
                  setState(() {
                    selectedStatus = value;
                  });
                },
              ),

              const SizedBox(height: 20),

              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Usaha Tersedia",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),

              const SizedBox(height: 16),

              BusinessList(selectedStatus: selectedStatus, keyword: search),
            ],
          ),
        ),
      ),
    );
  }
}
