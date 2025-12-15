# CACHE HTTP

A Flutter project to test http cache with dio and dio_http_cache.  
Cache in Flutter is useful to retrieve data when network goes down and to access some data in offline mode.

## Getting Started

To setup application implement these 2 libraries into pubspec.yaml :

- dio_http_cache: ^0.3.0
- dio: ^5.9.0

> Check updated version form `pub.dev` website.

---

## Set the api call

This test will make a call to https://dummy.restapiexample.com/api/v1/employees to get a simple list of employees.
Open endpoint to get json response, then copy json list inside **data** node → [{"id":1...}]

To create a model based on employees list open website https://javiercbk.github.io/json_to_dart/

- In JSON TextArea paste the list and type the classname → **Employee**
- Select "use private fields"
- Click to **Generate Dart** button

Copy the generated class to the right then open Flutter project.  
Create a new file in `lib/models/employee.dart` then paste the generated class.

Save file.

---

## Fetching data

In a new file in `lib/views/home_page.dart` create a new stateless widget with a sample scaffold.

Now in the same fie implement the cache system with the API Call as follow:

```dart
class EmployeesController {
  static Future<List?> fetchEmployees() async {
    String url = 'https://dummy.restapiexample.com/api/v1/employees';
    List result = [];
    try {
      //
      Dio dio = Dio();
      // create an object to manage cache
      DioCacheManager dioCacheManager = DioCacheManager(
        CacheConfig(baseUrl: url),
      );
      // add option to set cache info
      Options options = buildCacheOptions(
        const Duration(days: 7),
        forceRefresh: true,
      );

      // link cache by interceptors
      dio.interceptors.add(dioCacheManager.interceptor);
      // make api request implementing cache options (to check validity duration)
      var res = await dio.get(url, options: options);
      result = getList(res.data);
      return result;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  // Extract list from JSON
  static getList(body) {
    List emp = [];
    for (var e in body['data']) {
      emp.add(e);
    }
    return emp;
  }
}
```

This is the core snippet wich manage caching in the API call.  
> You can see the rest of code by downloading full project.