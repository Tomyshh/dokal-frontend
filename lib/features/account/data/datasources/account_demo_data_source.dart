import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/payment_method.dart';
import '../../domain/entities/relative.dart';
import '../../domain/entities/user_profile.dart';
import '../../../../l10n/l10n_static.dart';

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

  final _relatives = <Relative>[];

  final _payments = <PaymentMethod>[];

  void _ensureSeeded() {
    if (_relatives.isNotEmpty) return;
    final l10n = l10nStatic;
    _relatives.addAll([
      Relative(
        id: 'r1',
        name: l10n.relativeChild,
        label: l10n.relativeLabel(l10n.relativeRelation, 2016),
      ),
      Relative(
        id: 'r2',
        name: l10n.relativeParent,
        label: l10n.relativeLabel(l10n.relativeRelation, 1960),
      ),
    ]);
  }

  @override
  UserProfile getProfile() {
    final l10n = l10nStatic;
    final fullName = prefs.getString(_kFullName) ?? l10n.demoProfileFullName;
    final email = prefs.getString(_kEmail) ?? l10n.demoProfileEmail;
    final city = prefs.getString(_kCity) ?? l10n.demoProfileCity;
    return UserProfile(fullName: fullName, email: email, city: city);
  }

  @override
  List<Relative> listRelatives() {
    _ensureSeeded();
    return List.unmodifiable(_relatives);
  }

  @override
  void addRelativeDemo() {
    _ensureSeeded();
    _i++;
    final l10n = l10nStatic;
    _relatives.insert(
      0,
      Relative(
        id: 'r_demo_$_i',
        name: l10n.relativeDemoName(_i),
        label: l10n.relativeLabel(l10n.relativeRelation, 1960 + (_i % 30)),
      ),
    );
  }

  @override
  List<PaymentMethod> listPaymentMethods() => List.unmodifiable(_payments);

  @override
  void addPaymentMethodDemo() {
    _i++;
    final l10n = l10nStatic;
    _payments.insert(
      0,
      PaymentMethod(
        id: 'pm_$_i',
        brandLabel: l10n.demoPaymentBrandVisa,
        last4: '${1000 + (_i % 8999)}',
        expiry: '12/2${6 + (_i % 3)}',
      ),
    );
  }
}
