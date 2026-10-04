import 'package:backend/config/database.dart';
import 'package:backend/repositories/food_repository.dart';
import 'package:backend/routes/food_routes.dart';
import 'package:backend/repositories/restaurant_repository.dart';
import 'package:backend/routes/restaurant_routes.dart';
import 'package:backend/repositories/phrase_repository.dart';
import 'package:backend/routes/phrase_routes.dart';
import 'package:backend/repositories/tourist_place_repository.dart';
import 'package:backend/routes/tourist_place_routes.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_cors_headers/shelf_cors_headers.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:backend/storage/rustfs_storage_service.dart';
import 'package:backend/routes/upload_routes.dart';

Future<void> main() async {
  final db = await Database.connect();

  final rustFs = RustFsStorageService();

  final bucketExists = await rustFs.bucketExists();

  print('RustFS bucket exists: $bucketExists');

  final uploadRoutes = UploadRoutes(rustFs);

  final foodRepository = FoodRepository(db);
  final foodRoutes = FoodRoutes(foodRepository);

  final restaurantRepository = RestaurantRepository(db);
  final restaurantRoutes = RestaurantRoutes(restaurantRepository);

  final touristPlaceRepository = TouristPlaceRepository(db);
  final touristPlaceRoutes = TouristPlaceRoutes(touristPlaceRepository);

  final phraseRepository = PhraseRepository(db);
  final phraseRoutes = PhraseRoutes(phraseRepository);

  final router = Router();

  router.mount('/', foodRoutes.router.call);
  router.mount('/', restaurantRoutes.router.call);
  router.mount('/', touristPlaceRoutes.router.call);
  router.mount('/', phraseRoutes.router.call);
  router.mount('/', uploadRoutes.router.call);

  final handler = const Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware(corsHeaders())
      .addHandler(router.call);

  final server = await shelf_io.serve(handler, 'localhost', 8080);

  print('Server listening on port ${server.port}');
}
