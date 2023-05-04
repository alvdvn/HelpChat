import 'package:equatable/equatable.dart';

class AppConfig extends Equatable {
  final String apiUrl;
  final String pusherAPIKey;
  final String pusherCluster;

  const AppConfig({
    required this.apiUrl,
    required this.pusherAPIKey,
    required this.pusherCluster,
  });

  @override
  List<Object?> get props => [apiUrl, pusherAPIKey, pusherCluster];

  @override
  bool? get stringify => true;
}
