import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/sprite.dart';

/// The player character in the runner game.
class Player extends SpriteAnimationComponent with HasGameRef, Collidable {
  /// The player's current health or lives.
  int _health = 3;

  /// The player's current score.
  int _score = 0;

  /// The player's current animation state.
  PlayerState _state = PlayerState.idle;

  /// Constructs a new [Player] instance.
  Player({
    required Vector2 position,
    required Vector2 size,
  }) : super(
          position: position,
          size: size,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Load the player's sprite animation
    animation = await gameRef.loadSpriteAnimation(
      'player.png',
      SpriteAnimationData.sequenced(
        amount: 4,
        stepTime: 0.15,
        textureSize: Vector2.all(32),
      ),
    );
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Update the player's position and animation based on input
    switch (_state) {
      case PlayerState.idle:
        // Handle idle state
        break;
      case PlayerState.moving:
        // Handle moving state
        break;
      case PlayerState.jumping:
        // Handle jumping state
        break;
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, Collidable other) {
    super.onCollision(intersectionPoints, other);

    // Handle collisions with obstacles
    if (other is Obstacle) {
      _health--;
      if (_health <= 0) {
        // Player has died, handle game over
      }
    }
  }

  /// Handles input events for the player.
  void handleInput(TapDownInfo event) {
    // Handle player input, such as jumping
    switch (_state) {
      case PlayerState.idle:
        _state = PlayerState.jumping;
        break;
      case PlayerState.moving:
        // Handle other player actions
        break;
      case PlayerState.jumping:
        // Handle jumping input
        break;
    }
  }

  /// Increases the player's score.
  void increaseScore(int points) {
    _score += points;
  }
}

/// Represents the different states the player can be in.
enum PlayerState {
  idle,
  moving,
  jumping,
}