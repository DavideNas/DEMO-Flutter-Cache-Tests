import 'di_ex.dart';

GetIt di = GetIt.instance;

Future<void> setupDi() async {
  // Network Services
  di.registerSingleton<Dio>(Dio());

  // Helper
  di.registerSingleton(InternetConnectionHelper());

  // Hive DataBase
  await Hive.initFlutter();

  // DB Services
  // Home DataBase Service
  di.registerSingleton<HomeDataBaseService>(HomeDataBaseService());
  await di<HomeDataBaseService>().initDataBase();

  // DB Provider
  di.registerSingleton(
    HomeDbProvider(homeDatabaseService: di<HomeDataBaseService>()),
  );

  // Api Provider
  // Home Provider
  di.registerSingleton(HomeApiProvider(di<Dio>()));

  // Repository
  // Home Repository
  di.registerSingleton(
    HomeRepository(di<HomeApiProvider>(), di<HomeDbProvider>()),
  );

  // Blocs
  // Home Blocs
  di.registerFactory(() => HomeBloc(di<HomeRepository>()));
}
