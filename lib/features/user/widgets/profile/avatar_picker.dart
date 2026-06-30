import 'package:flutter/material.dart';

class AvatarPicker extends StatelessWidget {
  final Function(int) onSelected;

  const AvatarPicker({super.key, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        height: 260,
        child: GridView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: 5,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemBuilder: (_, index) {
            final avatar = index + 1;

            return InkWell(
              borderRadius: BorderRadius.circular(50),
              onTap: () {
                onSelected(avatar);
                Navigator.pop(context);
              },
              child: CircleAvatar(
                radius: 35,
                backgroundImage: AssetImage(
                  "assets/profile/avatar$avatar.webp",
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
