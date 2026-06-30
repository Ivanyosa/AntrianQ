import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/business_model.dart';

class BusinessService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Stream<List<BusinessModel>> watchBusinesses() {
    return _supabase
        .from('businesses')
        .stream(primaryKey: ['id'])
        .map((data) => data.map((e) => BusinessModel.fromMap(e)).toList());
  }
}
