import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:flame/sprite.dart';
import 'package:testLast-runner-08/game_objects/obstacle.dart';
import 'package:testLast-runner-08/game_objects/collectable.dart';

/// The player character in the runner game.
class Player extends SpriteAnimationComponent with HasHitboxes, Collidable {
  static const double _playerSpeed = 200.0;
  static const double _jumpForce = 500.0;
  static const double _maxHealth = 100.0;

  double _health = _maxHealth;
  double _invulnerabilityTimer = 0.0;
  bool _isInvulnerable = false;

  /// Constructs a new [Player] instance.
  Player(Vector2 position)
      : super(
          position: position,
          size: Vector2.all(50.0),
          animation: SpriteAnimation.fromFrameData(
            Sprite('player.png'),
            SpriteAnimationData.sequenced(
              amount: 4,
              stepTime: 0.1,
              textureSize: Vector2.all(50.0),
            ),
          ),
        ) {
    addHitbox(Rect.fromLTWH(0, 0, 40, 50));
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Handle player movement
    if (isPressed(LogicalKeyboardKey.space)) {
      velocity.y = -_jumpForce;
    } else {
      velocity.y += 1200 * dt;
    }
    velocity.x = _playerSpeed;

    // Handle invulnerability frames
    if (_isInvulnerable) {
      _invulnerabilityTimer -= dt;
      if (_invulnerabilityTimer <= 0) {
        _isInvulnerable = false;
      }
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, Collidable other) {
    super.onCollision(intersectionPoints, other);

    // Handle collisions with obstacles and collectibles
    if (other is Obstacle) {
      _takeDamage(20.0);
    } else if (other is Collectable) {
      other.collect();
    }
  }

  /// Damages the player and applies invulnerability frames.
  void _takeDamage(double amount) {
    if (!_isInvulnerable) {
      _health = (_health - amount).clamp(0, _maxHealth);
      _isInvulnerable = true;
      _invulnerabilityTimer = 1.0;
    }
  }

  /// Returns the player's current health.
  double get health => _health;

  /// Returns whether the player is currently invulnerable.
  bool get isInvulnerable => _isInvulnerable;
}