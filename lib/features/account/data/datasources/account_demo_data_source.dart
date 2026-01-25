import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/payment_method.dart';
import '../../domain/entities/relative.dart';
import '../../domain/entities/user_profile.dart';

abstract class AccountDemoDataSource {
  UserProfile getProfile();

  List<Relative> listRelatives();
  void addRelativeDemo();

  List<PaymentMethod> listPaymentMethods();
  void addPaymentMethodDemo();
}

class AccountDemoDataSourceImpl implements AccountDemoDataSource {
  AccountDemoDataSourceImpl({required this.prefs});

  final SharedPreferences prefs;

  static const _kFullName = 'profile_full_name';
  static const _kEmail = 'profile_email';
  static const _kCity = 'profile_city';

  int _i = 0;

  final _relatives = <Relative>[
    const Relative(id: 'r1', name: 'Enfant', label: 'Proche • 2016'),
    const Relative(id: 'r2', name: 'Parent', label: 'Proche • 1960'),
  ];

  final _payments = <PaymentMethod>[];

  @override
  UserProfile getProfile() {
    final fullName = prefs.getString(_kFullName) ?? 'Tom Jami';
    final email = prefs.getString(_kEmail) ?? 'tom@domaine.com';
    final city = prefs.getString(_kCity) ?? '75019 Paris';
    return UserProfile(fullName: fullName, email: email, city: city);
  }

  @override
  List<Relative> listRelatives() => List.unmodifiable(_relatives);

  @override
  void addRelativeDemo() {
    _i++;
    _relatives.insert(
      0,
      Relative(
        id: 'r_demo_$_i',
        name: 'Proche $_i',
        label: 'Proche • 19${60 + (_i % 30)}',
      ),
    );
  }

  @override
  List<PaymentMethod> listPaymentMethods() => List.unmodifiable(_payments);

  @override
  void addPaymentMethodDemo() {
    _i++;
    _payments.insert(
      0,
      PaymentMethod(
        id: 'pm_$_i',
        brandLabel: 'Visa',
        last4: '${1000 + (_i % 8999)}',
        expiry: '12/2${6 + (_i % 3)}',
      ),
    );
  }
}

