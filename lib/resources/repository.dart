import 'package:tabee/resources/api_provider.dart';

class Repository {
  ApiProvider apiProvider = new ApiProvider();

  Repository();

  Future<Map<String, dynamic>> getVersion() => apiProvider.getVersion();

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

  Future<Map<String, dynamic>> readMessages(Map<String, dynamic> request) =>
      apiProvider.readMessages(request);

  Future<Map<String, dynamic>> sendMessage(Map<String, dynamic> request) =>
      apiProvider.sendMessage(request);

  Future<Map<String, dynamic>> getThread(int customerId) =>
      apiProvider.getThread(customerId);

  Future<Map<String, dynamic>> markAsRead(int customerId, int threadId,
          [List msgsId]) =>
      apiProvider.markAsRead(customerId, threadId, msgsId);

  Future<Map<String, dynamic>> getStudents(int customerId) =>
      apiProvider.getStudents(customerId);

  Future<Map<String, dynamic>> getContacts(int customerId) =>
      apiProvider.getContacts(customerId);

  Future<Map<String, dynamic>> getExams(int studentId) =>
      apiProvider.getExams(studentId);

  Future<Map<String, dynamic>> getResult(int examId, int studentId) =>
      apiProvider.getResult(examId, studentId);

  Future<Map<String, dynamic>> getNews(int studentId) =>
      apiProvider.getNews(studentId);

  Future<Map<String, dynamic>> getTimeTable(int studentId) =>
      apiProvider.getTimeTable(studentId);

  Future<Map<String, dynamic>> getAttendance(int studentId) =>
      apiProvider.getAttendance(studentId);

  Future<Map<String, dynamic>> registerStudent(Map<String, dynamic> student) =>
      apiProvider.registerStudent(student);

  Future<Map<String, dynamic>> getRegisterStudent(int customerId) =>
      apiProvider.getRegisterStudent(customerId);

  Future<Map<String, dynamic>> getPayslips(int studentId) =>
      apiProvider.getPayslips(studentId);

  Future<Map<String, dynamic>> getPayslipLines(int payslipId) =>
      apiProvider.getPayslipLines(payslipId);

  Future<Map<String, dynamic>> confirmLinesPayment(List<int> payslipLineIds) =>
      apiProvider.confirmLinesPayment(payslipLineIds);

  Future<Map<String, dynamic>> getClasses() => apiProvider.getClasses();

  Future<Map<String, dynamic>> getClassStudents(int classId) =>
      apiProvider.getClassStudents(classId);
}
