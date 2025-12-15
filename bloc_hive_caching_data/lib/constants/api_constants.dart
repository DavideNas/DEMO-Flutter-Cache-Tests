class EnvironmentVariables {
  EnvironmentVariables._();

  // API base URL
  static String get baseUrl => 'https://api.slingacademy.com';
  // get products
  static String get getProducts => '$baseUrl/v1/sample-data/products?&limit=30';
}
