import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:flame/sprite.dart';
import 'package:testLast-runner-08/player.dart';

/// Represents an obstacle in the runner game.
class Obstacle extends PositionComponent with Hitbox, Collidable {
  final Sprite _sprite;
  final double _speed;

  /// Creates a new instance of the Obstacle component.
  Obstacle({
    required Vector2 position,
    required this._sprite,
    required this._speed,
  }) : super(position: position, size: _sprite.originalSize) {
    addShape(HitboxRectangle());
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.x -= _speed * dt;

    // Respawn the obstacle if it goes off-screen
    if (position.x < -size.x) {
      position.x = size.x + 500;
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, Collidable other) {
    super.onCollision(intersectionPoints, other);
    if (other is Player) {
      other.takeDamage();
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    _sprite.render(canvas, position: position, size: size);
  }
}