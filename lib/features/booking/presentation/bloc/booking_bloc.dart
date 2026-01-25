import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'booking_event.dart';
part 'booking_state.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  BookingBloc({required String practitionerId})
      : super(BookingState(practitionerId: practitionerId)) {
    on<BookingReasonSelected>(_onReasonSelected);
    on<BookingPatientSelected>(_onPatientSelected);
    on<BookingInstructionsAccepted>(_onInstructionsAccepted);
    on<BookingSlotSelected>(_onSlotSelected);
    on<BookingAddressChanged>(_onAddressChanged);
    on<BookingZipCodeChanged>(_onZipChanged);
    on<BookingCityChanged>(_onCityChanged);
    on<BookingVisitedBeforeChanged>(_onVisitedChanged);
    on<BookingReset>(_onReset);
  }

  void _onReasonSelected(
    BookingReasonSelected event,
    Emitter<BookingState> emit,
  ) {
    emit(state.copyWith(reason: event.reason));
  }

  void _onPatientSelected(
    BookingPatientSelected event,
    Emitter<BookingState> emit,
  ) {
    emit(state.copyWith(patientLabel: event.patientLabel));
  }

  void _onInstructionsAccepted(
    BookingInstructionsAccepted event,
    Emitter<BookingState> emit,
  ) {
    emit(state.copyWith(instructionsAccepted: true));
  }

  void _onSlotSelected(
    BookingSlotSelected event,
    Emitter<BookingState> emit,
  ) {
    emit(state.copyWith(slotLabel: event.slotLabel));
  }

  void _onAddressChanged(BookingAddressChanged event, Emitter<BookingState> emit) {
    emit(state.copyWith(addressLine: event.addressLine));
  }

  void _onZipChanged(BookingZipCodeChanged event, Emitter<BookingState> emit) {
    emit(state.copyWith(zipCode: event.zipCode));
  }

  void _onCityChanged(BookingCityChanged event, Emitter<BookingState> emit) {
    emit(state.copyWith(city: event.city));
  }

  void _onVisitedChanged(
    BookingVisitedBeforeChanged event,
    Emitter<BookingState> emit,
  ) {
    emit(state.copyWith(visitedBefore: event.visitedBefore));
  }

  void _onReset(BookingReset event, Emitter<BookingState> emit) {
    emit(BookingState(practitionerId: state.practitionerId));
  }
}

