import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/game.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

/// A collectible item component for a runner game.
class Collectible extends SpriteComponent with HasGameRef {
  /// The score value of the collectible.
  final int scoreValue;

  /// The audio player for the collection sound effect.
  final AudioPlayer _audioPlayer = AudioPlayer();

  /// The sprite for the collectible.
  late Sprite _sprite;

  /// The animation effect for the collectible.
  late EffectController _effectController;

  /// Creates a new instance of the [Collectible] component.
  ///
  /// [scoreValue] is the score value of the collectible.
  Collectible({required this.scoreValue}) {
    _sprite = Sprite('collectible.png');
    _effectController = EffectController(
      duration: 2.0,
      curve: Curves.easeInOut,
      loop: true,
    );
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();

    size = Vector2(32, 32);
    position = Vector2(gameRef.size.x, gameRef.size.y - height);
    anchor = Anchor.center;

    add(RotateEffect.by(
      _effectController,
      rotationSpeed: 2 * pi,
    ));
    add(MoveEffect.by(
      _effectController,
      offset: Vector2(0, 10),
    ));
  }

  @override
  void update(double dt) {
    super.update(dt);
    _effectController.update(dt);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    _sprite.render(canvas, position: position, size: size);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    if (other is Player) {
      gameRef.score += scoreValue;
      _audioPlayer.play('collect_sound.mp3');
      removeFromParent();
    }
  }
}