import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:testLast-runner-08/analytics_service.dart';
import 'package:testLast-runner-08/game_controller.dart';
import 'package:testLast-runner-08/level_config.dart';
import 'package:testLast-runner-08/player.dart';
import 'package:testLast-runner-08/obstacle.dart';
import 'package:testLast-runner-08/coin.dart';

/// The main FlameGame class for the 'testLast-runner-08' game.
class testLast-runner-08Game extends FlameGame with TapDetector {
  /// The current game state.
  GameState _gameState = GameState.playing;

  /// The player character.
  late Player _player;

  /// The list of obstacles in the current level.
  final List<Obstacle> _obstacles = [];

  /// The list of coins in the current level.
  final List<Coin> _coins = [];

  /// The current score.
  int _score = 0;

  /// The number of lives the player has.
  int _lives = 3;

  /// The GameController instance.
  late GameController _gameController;

  /// The AnalyticsService instance.
  late AnalyticsService _analyticsService;

  /// Initializes the game.
  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Set up the camera and world
    camera.viewport = FixedResolutionViewport(Vector2(720, 1280));
    camera.followComponent(_player);

    // Load the level configuration
    await _loadLevel(1);

    // Initialize the GameController and AnalyticsService
    _gameController = GameController(this);
    _analyticsService = AnalyticsService();
  }

  /// Loads a level from the configuration.
  Future<void> _loadLevel(int levelNumber) async {
    // Load the level configuration
    final levelConfig = await LevelConfig.load(levelNumber);

    // Create the player
    _player = Player(levelConfig.playerStartPosition);
    add(_player);

    // Create the obstacles
    _obstacles.clear();
    for (final obstacleConfig in levelConfig.obstacles) {
      final obstacle = Obstacle(obstacleConfig.position, obstacleConfig.size);
      _obstacles.add(obstacle);
      add(obstacle);
    }

    // Create the coins
    _coins.clear();
    for (final coinConfig in levelConfig.coins) {
      final coin = Coin(coinConfig.position);
      _coins.add(coin);
      add(coin);
    }
  }

  /// Handles the game logic.
  @override
  void update(double dt) {
    super.update(dt);

    switch (_gameState) {
      case GameState.playing:
        _updatePlaying(dt);
        break;
      case GameState.paused:
        // Handle paused state
        break;
      case GameState.gameOver:
        // Handle game over state
        break;
      case GameState.levelComplete:
        // Handle level complete state
        break;
    }
  }

  /// Updates the game state when the player is playing.
  void _updatePlaying(double dt) {
    // Update the player
    _player.update(dt);

    // Check for collisions with obstacles
    for (final obstacle in _obstacles) {
      if (_player.isColliding(obstacle)) {
        _handlePlayerHit();
      }
    }

    // Check for collisions with coins
    for (final coin in _coins) {
      if (_player.isColliding(coin)) {
        _collectCoin(coin);
      }
    }

    // Update the score
    _updateScore(dt);
  }

  /// Handles the player being hit by an obstacle.
  void _handlePlayerHit() {
    _lives--;
    if (_lives <= 0) {
      _gameState = GameState.gameOver;
      _analyticsService.logEvent('level_fail');
    } else {
      // Reset the player's position and continue the game
    }
  }

  /// Collects a coin and updates the score.
  void _collectCoin(Coin coin) {
    _score += coin.value;
    _coins.remove(coin);
    remove(coin);
    _analyticsService.logEvent('coin_collected');
  }

  /// Updates the score based on the game time.
  void _updateScore(double dt) {
    _score += (dt * 10).toInt();
  }

  /// Handles a tap input.
  @override
  void onTapDown(TapDownInfo info) {
    super.onTapDown(info);
    _gameController.handleTap();
  }
}

/// The possible game states.
enum GameState {
  playing,
  paused,
  gameOver,
  levelComplete,
}