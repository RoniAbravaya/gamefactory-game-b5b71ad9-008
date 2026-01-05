import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:testLast-runner-08/components/player.dart';
import 'package:testLast-runner-08/components/obstacle.dart';
import 'package:testLast-runner-08/components/collectible.dart';
import 'package:testLast-runner-08/services/analytics.dart';
import 'package:testLast-runner-08/services/ads.dart';
import 'package:testLast-runner-08/services/storage.dart';

/// The main game class for the 'testLast-runner-08' game.
class testLast-runner-08Game extends FlameGame with TapDetector {
  /// The current game state.
  GameState _gameState = GameState.playing;

  /// The current level being played.
  int _currentLevel = 1;

  /// The player's score.
  int _score = 0;

  /// The player character.
  late Player _player;

  /// The list of obstacles in the current level.
  final List<Obstacle> _obstacles = [];

  /// The list of collectibles in the current level.
  final List<Collectible> _collectibles = [];

  /// The analytics service.
  final AnalyticsService _analyticsService = AnalyticsService();

  /// The ads service.
  final AdsService _adsService = AdsService();

  /// The storage service.
  final StorageService _storageService = StorageService();

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    _loadLevel(_currentLevel);
  }

  /// Loads the specified level.
  void _loadLevel(int level) {
    // Load level data from storage or other source
    // Create player, obstacles, and collectibles
    _player = Player();
    _obstacles.addAll(_createObstacles());
    _collectibles.addAll(_createCollectibles());

    // Add components to the game world
    add(_player);
    _obstacles.forEach(add);
    _collectibles.forEach(add);

    // Reset game state
    _gameState = GameState.playing;
    _score = 0;

    // Log level start event
    _analyticsService.logLevelStart(level);
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Update game components
    _player.update(dt);
    _obstacles.forEach((obstacle) => obstacle.update(dt));
    _collectibles.forEach((collectible) => collectible.update(dt));

    // Check for collisions
    _checkCollisions();

    // Check for level completion
    if (_isLevelComplete()) {
      _gameState = GameState.levelComplete;
      _analyticsService.logLevelComplete(_currentLevel, _score);
      // Unlock next level or show ad prompt
    }

    // Check for game over
    if (_isGameOver()) {
      _gameState = GameState.gameOver;
      _analyticsService.logLevelFail(_currentLevel, _score);
      // Show game over UI and prompt for retry or ad
    }
  }

  @override
  void onTapDown(TapDownInfo info) {
    super.onTapDown(info);
    if (_gameState == GameState.playing) {
      _player.jump();
    }
  }

  /// Checks for collisions between the player, obstacles, and collectibles.
  void _checkCollisions() {
    // Check player collision with obstacles
    for (final obstacle in _obstacles) {
      if (_player.isColliding(obstacle)) {
        _gameState = GameState.gameOver;
        _analyticsService.logLevelFail(_currentLevel, _score);
        // Handle game over logic
        return;
      }
    }

    // Check player collision with collectibles
    for (final collectible in _collectibles) {
      if (_player.isColliding(collectible)) {
        _collectibles.remove(collectible);
        _score += collectible.value;
        _analyticsService.logCollectibleCollected(collectible.value);
        // Handle collectible collection logic
      }
    }
  }

  /// Checks if the current level is complete.
  bool _isLevelComplete() {
    // Implement level completion logic based on your game design
    return _obstacles.isEmpty && _collectibles.isEmpty;
  }

  /// Checks if the game is over.
  bool _isGameOver() {
    // Implement game over logic based on your game design
    return _gameState == GameState.gameOver;
  }

  /// Creates the obstacles for the current level.
  List<Obstacle> _createObstacles() {
    // Implement obstacle creation logic based on your game design
    return [
      Obstacle(),
      Obstacle(),
      Obstacle(),
    ];
  }

  /// Creates the collectibles for the current level.
  List<Collectible> _createCollectibles() {
    // Implement collectible creation logic based on your game design
    return [
      Collectible(),
      Collectible(),
      Collectible(),
    ];
  }
}

/// The possible game states.
enum GameState {
  playing,
  paused,
  gameOver,
  levelComplete,
}