class Employee {
  int? _id;
  String? _employeeName;
  String? _employeeSalary;
  String? _employeeAge;
  String? _profileImage;

  Employee({
    int? id,
    String? employeeName,
    String? employeeSalary,
    String? employeeAge,
    String? profileImage,
  }) {
    if (id != null) {
      _id = id;
    }
    if (employeeName != null) {
      _employeeName = employeeName;
    }
    if (employeeSalary != null) {
      _employeeSalary = employeeSalary;
    }
    if (employeeAge != null) {
      _employeeAge = employeeAge;
    }
    if (profileImage != null) {
      _profileImage = profileImage;
    }
  }

  int? get id => _id;
  set id(int? id) => _id = id;
  String? get employeeName => _employeeName;
  set employeeName(String? employeeName) => _employeeName = employeeName;
  String? get employeeSalary => _employeeSalary;
  set employeeSalary(String? employeeSalary) =>
      _employeeSalary = employeeSalary;
  String? get employeeAge => _employeeAge;
  set employeeAge(String? employeeAge) => _employeeAge = employeeAge;
  String? get profileImage => _profileImage;
  set profileImage(String? profileImage) => _profileImage = profileImage;

  Employee.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _employeeName = json['employee_name'];
    _employeeSalary = json['employee_salary'];
    _employeeAge = json['employee_age'];
    _profileImage = json['profile_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _id;
    data['employee_name'] = _employeeName;
    data['employee_salary'] = _employeeSalary;
    data['employee_age'] = _employeeAge;
    data['profile_image'] = _profileImage;
    return data;
  }
}
