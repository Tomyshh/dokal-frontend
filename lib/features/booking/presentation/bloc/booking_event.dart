part of 'booking_bloc.dart';

sealed class BookingEvent extends Equatable {
  const BookingEvent();

  @override
  List<Object?> get props => [];
}

class BookingReasonSelected extends BookingEvent {
  const BookingReasonSelected(this.reason);
  final String reason;

  @override
  List<Object?> get props => [reason];
}

class BookingPatientSelected extends BookingEvent {
  const BookingPatientSelected(this.patientLabel);
  final String patientLabel;

  @override
  List<Object?> get props => [patientLabel];
}

class BookingInstructionsAccepted extends BookingEvent {
  const BookingInstructionsAccepted();
}

class BookingSlotSelected extends BookingEvent {
  const BookingSlotSelected(this.slotLabel);
  final String slotLabel;

  @override
  List<Object?> get props => [slotLabel];
}

class BookingAddressChanged extends BookingEvent {
  const BookingAddressChanged(this.addressLine);
  final String addressLine;

  @override
  List<Object?> get props => [addressLine];
}

class BookingZipCodeChanged extends BookingEvent {
  const BookingZipCodeChanged(this.zipCode);
  final String zipCode;

  @override
  List<Object?> get props => [zipCode];
}

class BookingCityChanged extends BookingEvent {
  const BookingCityChanged(this.city);
  final String city;

  @override
  List<Object?> get props => [city];
}

class BookingVisitedBeforeChanged extends BookingEvent {
  const BookingVisitedBeforeChanged(this.visitedBefore);
  final bool visitedBefore;

  @override
  List<Object?> get props => [visitedBefore];
}

class BookingReset extends BookingEvent {
  const BookingReset();
}

