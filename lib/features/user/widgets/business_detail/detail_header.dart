import 'package:flutter/material.dart';

import 'detail_banner.dart';

class DetailHeader extends StatelessWidget {
  final Map<String, dynamic> business;

  const DetailHeader({super.key, required this.business});

  @override
  Widget build(BuildContext context) {
    return DetailBanner(
      name: business['name'],
      status: business['status'],
      logoUrl: business['logo_url'],
    );
  }
}
