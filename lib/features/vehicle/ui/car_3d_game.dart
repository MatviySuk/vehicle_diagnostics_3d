import 'dart:async';
import 'dart:math' as math;

import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_3d/camera.dart';
import 'package:flame_3d/components.dart';
import 'package:flame_3d/game.dart';
import 'package:flame_3d/model.dart';
import 'package:flame_3d/parser.dart';
import 'package:flame_3d/resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final car3dGameProvider = Provider<SimpleGame3D>((ref) {
  throw UnimplementedError('car3dGameProvider must be overridden in main');
});

class _PivotComponent extends Component3D {
  _PivotComponent({super.position});
}

// --- Jogo do carro completo ---
class SimpleGame3D extends FlameGame3D<World3D, CameraComponent3D>
    with PanDetector {
  late ModelComponent _car;
  Model? _carModel;
  Model? headlightModel;
  Model? wheelsModel;
  Future<void>? _preloadFuture;
  double _rotationY = -0.64159;
  final modelReady = ValueNotifier<bool>(false);

  SimpleGame3D()
    : super(
        world: World3D(clearColor: const Color(0x00000000)),
        camera: CameraComponent3D(
          position: Vector3(0, 1.5, 1.5),
          target: Vector3(0, 1, 0),
        ),
      );

  // inicia o parse dos modelos em background — chamar em main() logo após criar o jogo
  void startPreloading() {
    _preloadFuture = _loadModels();
  }

  Future<void> _loadModels() async {
    _carModel = await ModelParser.parse('models/Untitled4.gltf');
    headlightModel = await ModelParser.parse('models/headlight-front-right-1.gltf');
    wheelsModel = await ModelParser.parse('models/Untitled-wheels7.gltf');
  }

  @override
  Color backgroundColor() => const Color(0x00000000);

  @override
  FutureOr<void> onLoad() async {
    if (_preloadFuture != null) {
      await _preloadFuture; // modelos já a carregar — aguarda apenas o que falta
    } else {
      await _loadModels();
    }
    final model = _carModel!;

    _car = ModelComponent(
      model: model,
      rotation: Quaternion.axisAngle(Vector3(0, 1, 0), _rotationY),
      position: Vector3(0, 1, 0),
      scale: Vector3.all(15.0),
    );

    // cubo invisível que marca a posição do farol no modelo
    final headlightCube = MeshComponent(
      position: Vector3(0.008, 0.007, 0.024),
      mesh: CuboidMesh(
        size: Vector3(0.003, 0.002, 0.001),
        material: SpatialMaterial(albedoColor: const Color(0x88FF0000)),
      ),
    );

    // cubo invisível que marca a posição das rodas no modelo
    final wheelsCube = MeshComponent(
      position: Vector3(0.009, 0.007, 0.016),
      rotation: Quaternion.axisAngle(Vector3(0, 1, 0), math.pi / 2),
      mesh: CuboidMesh(
        size: Vector3(0.003, 0.002, 0.001),
        material: SpatialMaterial(albedoColor: const Color(0x880000FF)),
      ),
    );

    _car.add(headlightCube);
    _car.add(wheelsCube);

    world.addAll([
      LightComponent.ambient(intensity: 10.0),
      LightComponent.point(position: Vector3(0, 10, 0), intensity: 20.0),
      LightComponent.point(position: Vector3(10, 5, 10), intensity: 15.0),
      LightComponent.point(position: Vector3(-10, 5, 10), intensity: 15.0),
      LightComponent.point(position: Vector3(0, 5, -10), intensity: 15.0),
      _car,
    ]);

    modelReady.value = true;
  }

  Offset? _projectToScreen(Vector3 localPos) {
    final worldPos = _car.transformMatrix.transform3(localPos);
    final vp = camera.viewProjectionMatrix;
    final clip = vp.transform3(worldPos);
    if (clip.z <= 0) return null;
    final sx = (clip.x * 0.5 + 0.5) * size.x;
    final sy = (1 - (clip.y * 0.5 + 0.5)) * size.y;
    return Offset(sx, sy);
  }

  Offset? headlightScreenPosition() =>
      _projectToScreen(Vector3(0.008, 0.007, 0.024));

  Offset? wheelsScreenPosition() =>
      _projectToScreen(Vector3(0.009, 0.007, 0.016));

  void resetRotation() {
    _rotationY = -0.64159;
    _car.rotation.setFrom(Quaternion.axisAngle(Vector3(0, 1, 0), _rotationY));
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    _rotationY += info.delta.global.x * 0.01;
    _car.rotation.setFrom(Quaternion.axisAngle(Vector3(0, 1, 0), _rotationY));
  }
}

// --- Jogo do farol (painel popup) ---
class HeadlightGame extends FlameGame3D<World3D, CameraComponent3D> {
  final Model? preloadedModel;
  double _angle = 0;
  late _PivotComponent _pivot;

  HeadlightGame({this.preloadedModel})
    : super(
        world: World3D(clearColor: const Color(0x00000000)),
        camera: CameraComponent3D(
          position: Vector3(0, 0, 0.3),
          target: Vector3(0, 0, 0),
        ),
      );

  @override
  Color backgroundColor() => const Color(0x00000000);

  @override
  FutureOr<void> onLoad() async {
    final model = preloadedModel ??
        await ModelParser.parse('models/headlight-front-right-1.gltf');

    final headlight = ModelComponent(
      model: model,
      position: Vector3(0, 0, 0),
      scale: Vector3.all(30.0),
    );

    _pivot = _PivotComponent(position: Vector3(0, 0, 0));
    _pivot.add(headlight);

    world.addAll([
      LightComponent.ambient(intensity: 10.0),
      LightComponent.point(position: Vector3(0.5, 1, 1), intensity: 40.0),
      LightComponent.point(position: Vector3(-0.5, 0.2, -1), intensity: 20.0),
      LightComponent.point(position: Vector3(0, 2, 0), intensity: 30.0),
      _pivot,
    ]);
  }

  @override
  void update(double dt) {
    super.update(dt);
    _angle += dt * 0.8;
    _pivot.rotation.setFrom(
      Quaternion.axisAngle(Vector3(0, 1, 0), _angle),
    );
  }
}

// --- Jogo das rodas (painel popup) ---
class WheelsGame extends FlameGame3D<World3D, CameraComponent3D> {
  final Model? preloadedModel;
  double _angle = 0;
  late _PivotComponent _pivot;

  WheelsGame({this.preloadedModel})
    : super(
        world: World3D(clearColor: const Color(0x00000000)),
        camera: CameraComponent3D(
          position: Vector3(0, 0, 0.3),
          target: Vector3(0, 0, 0),
        ),
      );

  @override
  Color backgroundColor() => const Color(0x00000000);

  @override
  FutureOr<void> onLoad() async {
    final model = preloadedModel ??
        await ModelParser.parse('models/Untitled-wheels7.gltf');

    final wheel = ModelComponent(
      model: model,
      position: Vector3(0, 0, 0),
      scale: Vector3.all(15.0),
    );

    _pivot = _PivotComponent(position: Vector3(0, -0.05, 0));
    _pivot.add(wheel);

    world.addAll([
      LightComponent.ambient(intensity: 10.0),
      LightComponent.point(position: Vector3(0.5, 1, 1), intensity: 40.0),
      LightComponent.point(position: Vector3(-0.5, 0.2, -1), intensity: 20.0),
      LightComponent.point(position: Vector3(0, 2, 0), intensity: 30.0),
      _pivot,
    ]);
  }

  @override
  void update(double dt) {
    super.update(dt);
    _angle += dt * 1.5;
    _pivot.rotation.setFrom(
      Quaternion.axisAngle(Vector3(0, 1, 0), _angle),
    );
  }
}
