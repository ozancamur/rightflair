import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

/// Yüz tespit edilen bölgeleri bulanıklaştırır
///
/// [imageFile]: İşlenecek orijinal fotoğraf
/// [blurRadius]: Blur gücü (varsayılan: 100). Daha yüksek değer = daha güçlü blur
///   - 50-80: Orta blur
///   - 80-120: Güçlü blur
///   - 120+: Ultra güçlü blur
///
/// Returns: Yüzleri bulanıklaştırılmış yeni dosya.
/// Yüz bulunamazsa orijinal dosyayı döndürür.
Future<File> blurFacesInImage(File imageFile, {int blurRadius = 100}) async {
  debugPrint('🎭 [Face Blur] Başlıyor: ${imageFile.path}');
  debugPrint('⚙️ [Face Blur] Blur Radius: $blurRadius');
  try {
    // 1. Yüz tespiti için ML Kit hazırlığı
    debugPrint('🤖 [Face Blur] ML Kit FaceDetector oluşturuluyor...');
    final faceDetector = FaceDetector(
      options: FaceDetectorOptions(
        enableContours: false,
        enableLandmarks: false,
        enableClassification: false,
        enableTracking: false,
        performanceMode: FaceDetectorMode.accurate,
      ),
    );

    // 2. Görüntüyü ML Kit için hazırla
    debugPrint('📸 [Face Blur] InputImage hazırlanıyor...');
    final inputImage = InputImage.fromFile(imageFile);

    // 3. Yüzleri tespit et
    debugPrint('🔍 [Face Blur] Yüz tespiti yapılıyor...');
    final List<Face> faces = await faceDetector.processImage(inputImage);
    debugPrint('👤 [Face Blur] ${faces.length} yüz tespit edildi!');

    // 4. Cleanup
    await faceDetector.close();

    // 5. Yüz bulunamadıysa orijinal dosyayı döndür
    if (faces.isEmpty) {
      debugPrint('⚠️ [Face Blur] Yüz bulunamadı, orijinal dosya döndürülüyor');
      return imageFile;
    }

    // Log face details
    for (var i = 0; i < faces.length; i++) {
      final face = faces[i];
      debugPrint(
        '   Face $i: (${face.boundingBox.left}, ${face.boundingBox.top}) '
        '${face.boundingBox.width}x${face.boundingBox.height}',
      );
    }

    // 6. Görüntü işleme parametrelerini hazırla
    debugPrint('📦 [Face Blur] Blur parametreleri hazırlanıyor...');
    final blurParams = _BlurProcessParams(
      imagePath: imageFile.path,
      blurRadius: blurRadius,
      faces: faces.map((face) {
        // Yüz bölgesini %50 genişlet - sadece kafa ve saç (boyun/omuz değil)
        final expandRatio = 0.5;
        final expandWidth = (face.boundingBox.width * expandRatio).toInt();
        final expandHeight = (face.boundingBox.height * expandRatio).toInt();

        return _FaceBox(
          left: (face.boundingBox.left - expandWidth ~/ 2).toInt(),
          top: (face.boundingBox.top - expandHeight ~/ 2).toInt(),
          width: (face.boundingBox.width + expandWidth).toInt(),
          height: (face.boundingBox.height + expandHeight).toInt(),
        );
      }).toList(),
    );

    // 7. Isolate'te blur işlemini yap (performans için)
    debugPrint('⚙️ [Face Blur] Isolate\'te blur işlemi başlatılıyor...');
    final blurredImageBytes = await compute(_blurFacesIsolate, blurParams);
    debugPrint('✨ [Face Blur] Blur işlemi tamamlandı!');

    // 8. Yeni dosyayı kaydet
    final tempDir = await getTemporaryDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final originalFileName = path.basenameWithoutExtension(imageFile.path);
    final newFilePath = path.join(
      tempDir.path,
      '${originalFileName}_blurred_$timestamp.jpg',
    );

    final blurredFile = File(newFilePath);
    await blurredFile.writeAsBytes(blurredImageBytes);

    debugPrint('💾 [Face Blur] Dosya kaydedildi: $newFilePath');
    debugPrint('✅ [Face Blur] Tamamlandı!');

    return blurredFile;
  } catch (e, stackTrace) {
    debugPrint('❌ [Face Blur] HATA: $e');
    debugPrint('Stack trace: $stackTrace');
    // Hata durumunda orijinal dosyayı döndür
    return imageFile;
  }
}

/// Isolate'te çalışan blur işlemi
/// Bu fonksiyon ana thread'i bloke etmeden ağır görüntü işleme yapar
Uint8List _blurFacesIsolate(_BlurProcessParams params) {
  // 1. Görüntüyü yükle
  final imageBytes = File(params.imagePath).readAsBytesSync();
  img.Image? originalImage = img.decodeImage(imageBytes);

  if (originalImage == null) {
    return imageBytes;
  }

  // 2. Her yüz için blur uygula
  for (final faceBox in params.faces) {
    // Görüntü sınırları içinde kalmasını sağla
    final left = faceBox.left.clamp(100, originalImage.width - 1);
    final top = faceBox.top.clamp(100, originalImage.height - 1);
    final right = (faceBox.left + faceBox.width).clamp(0, originalImage.width);
    final bottom = (faceBox.top + faceBox.height).clamp(
      0,
      originalImage.height,
    );

    final width = right - left;
    final height = bottom - top;

    if (width <= 0 || height <= 0) continue;

    // 3. Yüz bölgesini kırp
    final faceRegion = img.copyCrop(
      originalImage,
      x: left,
      y: top,
      width: width,
      height: height,
    );

    // 4. ULTRA GÜÇLÜ blur uygula - surat hiç belli olmayacak
    var blurredFace = faceRegion;

    // 1. Pass - Ağır Pixelate (mozaik efekti)
    final pixelSize = (width / 8).round().clamp(8, 30);
    blurredFace = img.copyResize(blurredFace, width: width ~/ pixelSize);
    blurredFace = img.copyResize(
      blurredFace,
      width: width,
      height: height,
      interpolation: img.Interpolation.nearest,
    );

    // 2. Pass - Ayarlanabilir Gaussian blur (params'tan gelen radius)
    blurredFace = img.gaussianBlur(blurredFace, radius: params.blurRadius);

    // 5. Blurlanmış bölgeyi orijinal görüntüye yapıştır
    img.compositeImage(originalImage, blurredFace, dstX: left, dstY: top);
  }

  // 6. İşlenmiş görüntüyü JPEG olarak encode et
  return Uint8List.fromList(img.encodeJpg(originalImage, quality: 95));
}

/// Isolate'e gönderilecek parametreler
/// Isolate'ler sadece primitive ve serializable veriler kabul eder
class _BlurProcessParams {
  final String imagePath;
  final int blurRadius;
  final List<_FaceBox> faces;

  _BlurProcessParams({
    required this.imagePath,
    required this.blurRadius,
    required this.faces,
  });
}

/// Yüz koordinatlarını temsil eden basit model
/// ML Kit'in Face nesnesinin boundingBox'ını serializable hale getirir
class _FaceBox {
  final int left;
  final int top;
  final int width;
  final int height;

  _FaceBox({
    required this.left,
    required this.top,
    required this.width,
    required this.height,
  });
}
