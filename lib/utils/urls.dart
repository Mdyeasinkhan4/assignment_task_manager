class TMUrls {
  static String baseURL = 'https://task-manager-api.ostad.live/api/v1';
  static String SignUpURL = '$baseURL/Registration';
  static String SignInURL = '$baseURL/Login';
  static String getTaskCountURL = '$baseURL/taskStatusCount';
  static String  CreateTaskURL = '$baseURL/createTask';
  static String  updateProfileURL = '$baseURL/ProfileUpdate';
  static String getTaskByStatusURL(String status) => '$baseURL/listTaskByStatus/$status';
  static String deleteTaskURL(String id) => '$baseURL/deleteTask/$id';
  static String updateTaskStatusURL(String id,String Status) => '$baseURL/updateTaskStatus/$id/$Status';

  // password recovery
  // static String recoverVerifyEmailURL(String email) => '$baseURL/RecoverVerifyEmail/$email';
  // static String recoverVerifyOTPURL(String email, String otp) => '$baseURL/RecoverVerifyOTP/$email/$otp';
  // static String recoverResetPassURL = '$baseURL/RecoverResetPass';

  // password recovery
  static String recoverVerifyEmailURL(String email) => '$baseURL/RecoverVerifyEmail/$email';
  static String recoverVerifyOTPURL(String email, String otp) => '$baseURL/RecoverVerifyOtp/$email/$otp';
  static String recoverResetPassURL = '$baseURL/RecoverResetPassword';

}
