// lib/domain/entities/prediction_details.dart
class PredictionDetails {
  final String formattedAddress;
  final String? formattedPhoneNumber;
  final String? url;

  PredictionDetails({
    required this.formattedAddress,
    this.formattedPhoneNumber,
    this.url,
  });
}
