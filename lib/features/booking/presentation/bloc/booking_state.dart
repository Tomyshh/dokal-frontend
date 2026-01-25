part of 'booking_bloc.dart';

class BookingState extends Equatable {
  const BookingState({
    required this.practitionerId,
    this.reason,
    this.patientLabel,
    this.instructionsAccepted = false,
    this.slotLabel,
    this.addressLine,
    this.zipCode,
    this.city,
    this.visitedBefore,
  });

  final String practitionerId;
  final String? reason;
  final String? patientLabel;
  final bool instructionsAccepted;
  final String? slotLabel;
  final String? addressLine;
  final String? zipCode;
  final String? city;
  final bool? visitedBefore;

  bool get isReadyToConfirm =>
      reason != null &&
      patientLabel != null &&
      instructionsAccepted &&
      slotLabel != null &&
      (addressLine ?? '').trim().isNotEmpty &&
      (zipCode ?? '').trim().isNotEmpty &&
      (city ?? '').trim().isNotEmpty &&
      visitedBefore != null;

  BookingState copyWith({
    String? reason,
    String? patientLabel,
    bool? instructionsAccepted,
    String? slotLabel,
    String? addressLine,
    String? zipCode,
    String? city,
    bool? visitedBefore,
  }) {
    return BookingState(
      practitionerId: practitionerId,
      reason: reason ?? this.reason,
      patientLabel: patientLabel ?? this.patientLabel,
      instructionsAccepted: instructionsAccepted ?? this.instructionsAccepted,
      slotLabel: slotLabel ?? this.slotLabel,
      addressLine: addressLine ?? this.addressLine,
      zipCode: zipCode ?? this.zipCode,
      city: city ?? this.city,
      visitedBefore: visitedBefore ?? this.visitedBefore,
    );
  }

  @override
  List<Object?> get props => [
        practitionerId,
        reason,
        patientLabel,
        instructionsAccepted,
        slotLabel,
        addressLine,
        zipCode,
        city,
        visitedBefore,
      ];
}

