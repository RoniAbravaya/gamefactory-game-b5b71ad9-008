import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';

/// The main menu scene for the runner game.
class MenuScene extends Component with TapDetector {
  /// The game instance.
  final FlameGame game;

  /// The title text.
  late final TextComponent _titleText;

  /// The play button.
  late final ButtonComponent _playButton;

  /// The level select button.
  late final ButtonComponent _levelSelectButton;

  /// The settings button.
  late final ButtonComponent _settingsButton;

  /// The background animation.
  late final SpriteAnimationComponent _backgroundAnimation;

  /// Creates a new instance of the [MenuScene].
  MenuScene(this.game) {
    _createTitle();
    _createPlayButton();
    _createLevelSelectButton();
    _createSettingsButton();
    _createBackgroundAnimation();
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(_titleText);
    add(_playButton);
    add(_levelSelectButton);
    add(_settingsButton);
    add(_backgroundAnimation);
  }

  /// Creates the title text.
  void _createTitle() {
    _titleText = TextComponent(
      text: 'testLast-runner-08',
      position: Vector2(game.size.x / 2, game.size.y * 0.2),
      anchor: Anchor.center,
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.white,
          fontSize: 48,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  /// Creates the play button.
  void _createPlayButton() {
    _playButton = ButtonComponent(
      position: Vector2(game.size.x / 2, game.size.y * 0.4),
      size: Vector2(200, 60),
      anchor: Anchor.center,
      child: TextComponent(
        text: 'Play',
        textRenderer: TextPaint(
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      onPressed: () {
        // Navigate to the game scene
      },
    );
  }

  /// Creates the level select button.
  void _createLevelSelectButton() {
    _levelSelectButton = ButtonComponent(
      position: Vector2(game.size.x / 2, game.size.y * 0.5),
      size: Vector2(200, 60),
      anchor: Anchor.center,
      child: TextComponent(
        text: 'Level Select',
        textRenderer: TextPaint(
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      onPressed: () {
        // Navigate to the level select scene
      },
    );
  }

  /// Creates the settings button.
  void _createSettingsButton() {
    _settingsButton = ButtonComponent(
      position: Vector2(game.size.x / 2, game.size.y * 0.6),
      size: Vector2(200, 60),
      anchor: Anchor.center,
      child: TextComponent(
        text: 'Settings',
        textRenderer: TextPaint(
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      onPressed: () {
        // Navigate to the settings scene
      },
    );
  }

  /// Creates the background animation.
  void _createBackgroundAnimation() {
    _backgroundAnimation = SpriteAnimationComponent(
      animation: SpriteAnimation.spriteList([
        // Add your background sprites here
      ], stepTime: 0.1),
      position: Vector2.zero(),
      size: game.size,
    );
  }

  @override
  void onTapDown(TapDownInfo info) {
    super.onTapDown(info);
    // Handle tap events on the menu buttons
  }
}