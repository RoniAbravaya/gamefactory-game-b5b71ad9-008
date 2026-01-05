import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

/// The main game scene that handles the core game loop and logic.
class GameScene extends Component with HasGameRef {
  /// The player component.
  late Player player;

  /// The list of obstacle components.
  final List<Obstacle> obstacles = [];

  /// The list of collectable components.
  final List<Collectable> collectables = [];

  /// The current score.
  int score = 0;

  /// Whether the game is currently paused.
  bool isPaused = false;

  @override
  Future<void> onLoad() async {
    /// Load and set up the level.
    await _loadLevel();
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (!isPaused) {
      /// Update the player.
      player.update(dt);

      /// Update the obstacles.
      for (final obstacle in obstacles) {
        obstacle.update(dt);
      }

      /// Update the collectables.
      for (final collectable in collectables) {
        collectable.update(dt);
      }

      /// Check for collisions and update the score.
      _handleCollisions();
      _updateScore();

      /// Check for win/lose conditions.
      _checkGameState();
    }
  }

  /// Loads and sets up the current level.
  Future<void> _loadLevel() async {
    try {
      /// Load the player, obstacles, and collectables.
      player = await Player.load();
      obstacles.addAll(await Obstacle.loadMultiple());
      collectables.addAll(await Collectable.loadMultiple());

      /// Add the components to the game world.
      add(player);
      for (final obstacle in obstacles) {
        add(obstacle);
      }
      for (final collectable in collectables) {
        add(collectable);
      }
    } catch (e) {
      /// Handle any errors that occur during level loading.
      debugPrint('Error loading level: $e');
    }
  }

  /// Handles collisions between the player, obstacles, and collectables.
  void _handleCollisions() {
    /// Check for collisions between the player and obstacles.
    for (final obstacle in obstacles) {
      if (player.isColliding(obstacle)) {
        _handlePlayerDeath();
        return;
      }
    }

    /// Check for collisions between the player and collectables.
    for (final collectable in collectables) {
      if (player.isColliding(collectable)) {
        _collectCollectable(collectable);
      }
    }
  }

  /// Handles the player's death.
  void _handlePlayerDeath() {
    /// Implement game over logic here.
    debugPrint('Player has died!');
  }

  /// Collects a collectable and updates the score.
  void _collectCollectable(Collectable collectable) {
    /// Implement score update logic here.
    score += collectable.value;
    debugPrint('Collected a collectable! Score: $score');

    /// Remove the collectable from the game world.
    remove(collectable);
  }

  /// Updates the score display.
  void _updateScore() {
    /// Implement score display logic here.
    debugPrint('Current score: $score');
  }

  /// Checks the game state and handles win/lose conditions.
  void _checkGameState() {
    /// Implement win/lose condition logic here.
    if (score >= 1000) {
      debugPrint('You win!');
    }
  }

  /// Pauses the game.
  void pauseGame() {
    isPaused = true;
  }

  /// Resumes the game.
  void resumeGame() {
    isPaused = false;
  }
}