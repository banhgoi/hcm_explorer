import 'dart:convert';
import 'dart:typed_data';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_multipart/shelf_multipart.dart';

import 'package:backend/storage/rustfs_storage_service.dart';

class UploadRoutes {
  final RustFsStorageService storageService;

  UploadRoutes(this.storageService);

  Router get router {
    final router = Router();

    router.post('/api/uploads', (Request request) async {
      final folder =
          request.url.queryParameters['folder'] ?? 'foods';

      const allowedFolders = [
        'foods',
        'restaurants',
        'tourist-places',
      ];

      if (!allowedFolders.contains(folder)) {
        return Response.badRequest(
          body: jsonEncode({
            'message': 'Invalid upload folder.',
          }),
          headers: {
            'Content-Type': 'application/json',
          },
        );
      }

      final form = request.formData();

      if (form == null) {
        return Response.badRequest(
          body: jsonEncode({
            'message':
            'Request must be multipart/form-data',
          }),
          headers: {
            'Content-Type': 'application/json',
          },
        );
      }

      Uint8List? fileBytes;
      String? fileName;

      await for (final formData in form.formData) {
        if (formData.name == 'file') {
          fileBytes = await formData.part.readBytes();
          fileName = formData.filename;
        }
      }

      if (fileBytes == null || fileName == null) {
        return Response.badRequest(
          body: jsonEncode({
            'message': 'File is required',
          }),
          headers: {
            'Content-Type': 'application/json',
          },
        );
      }

      final extension = fileName!.contains('.')
          ? fileName!.split('.').last.toLowerCase()
          : 'jpg';

      final objectPath =
          '$folder/${DateTime.now().millisecondsSinceEpoch}.$extension';

      await storageService.uploadBytes(
        objectPath: objectPath,
        bytes: fileBytes!,
      );

      return Response.ok(
        jsonEncode({
          'path': objectPath,
        }),
        headers: {
          'Content-Type': 'application/json',
        },
      );
    });

    router.get(
      '/api/images/<path|.*>',
          (Request request, String path) async {
        try {
          final object =
          await storageService.getObject(
            objectPath: path,
          );

          final extension =
          path.split('.').last.toLowerCase();

          String contentType;

          switch (extension) {
            case 'png':
              contentType = 'image/png';
              break;
            case 'webp':
              contentType = 'image/webp';
              break;
            case 'gif':
              contentType = 'image/gif';
              break;
            case 'jpg':
            case 'jpeg':
            default:
              contentType = 'image/jpeg';
              break;
          }

          return Response.ok(
            object,
            headers: {
              'Content-Type': contentType,
            },
          );
        } catch (e) {
          return Response.notFound(
            jsonEncode({
              'message': 'Image not found',
            }),
            headers: {
              'Content-Type': 'application/json',
            },
          );
        }
      },
    );

    return router;
  }
}