import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ca\$h with Dio', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: FutureBuilder(
        future: EmployeesController.fetchEmployees(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('No data found'));
          } else {
            List employees = snapshot.data;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                itemCount: employees.length,
                itemBuilder: (context, index) {
                  var employee = employees[index];
                  return Card(
                    color: Colors.grey[200],
                    child: ListTile(
                      title: Text(employee['employee_name']),
                      subtitle: Text('Salary: ${employee['employee_salary']}'),
                      trailing: Text('Age: ${employee['employee_age']}'),
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}

class EmployeesController {
  static Future<List?> fetchEmployees() async {
    String url = 'https://dummy.restapiexample.com/api/v1/employees';
    List result = [];
    try {
      // Your Dio request and caching logic here
      Dio dio = Dio();
      DioCacheManager dioCacheManager = DioCacheManager(
        CacheConfig(baseUrl: url),
      );
      Options options = buildCacheOptions(
        const Duration(days: 7),
        forceRefresh: true,
      );

      dio.interceptors.add(dioCacheManager.interceptor);
      var res = await dio.get(url, options: options);
      result = getList(res.data);
      return result;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  static getList(body) {
    List emp = [];
    for (var e in body['data']) {
      emp.add(e);
    }
    return emp;
  }
}
