abstract class BookingDemoDataSource {
  Future<String> confirm({
    required String practitionerId,
    required String reason,
    required String patientLabel,
    required String slotLabel,
    required String addressLine,
    required String zipCode,
    required String city,
    required bool visitedBefore,
  });
}

class BookingDemoDataSourceImpl implements BookingDemoDataSource {
  @override
  Future<String> confirm({
    required String practitionerId,
    required String reason,
    required String patientLabel,
    required String slotLabel,
    required String addressLine,
    required String zipCode,
    required String city,
    required bool visitedBefore,
  }) async {
    // Démo: simule un call réseau.
    await Future<void>.delayed(const Duration(milliseconds: 450));
    return 'appt_demo_${DateTime.now().millisecondsSinceEpoch}';
  }
}

