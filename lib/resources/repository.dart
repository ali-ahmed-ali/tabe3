import 'package:tabee/resources/api_provider.dart';

class Repository {
  ApiProvider apiProvider = new ApiProvider();

  Repository();

  Future<Map<String, dynamic>> getCountryAndState() =>
      apiProvider.getCountryAndState();

  Future<Map<String, dynamic>> registerCustomer(Map<String, dynamic> request) =>
      apiProvider.registerCustomer(request);

  Future<Map<String, dynamic>> loginCustomer(
          String phoneNumber, String password) =>
      apiProvider.loginCustomer(phoneNumber, password);

  Future<Map<String, dynamic>> sendVerifyPin(String mobile) =>
      apiProvider.sendVerifyPin(mobile);

  Future<Map<String, dynamic>> updatePassword(
          String mobile, String password, String pin) =>
      apiProvider.updatePassword(mobile, password, pin);

  Future<Map<String, dynamic>> verifyPin(String mobile, String pin) =>
      apiProvider.verifyPin(mobile, pin);

  Future<Map<String, dynamic>> updateToken(
          String customerId, String newToken) =>
      apiProvider.updateToken(customerId, newToken);
}
