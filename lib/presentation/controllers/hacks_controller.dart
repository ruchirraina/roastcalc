import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/constants/app_config.dart';
import '../../data/repositories/hacks_repository.dart';
import '../../data/repositories/history_repository.dart';
import '../../data/services/gemini_service.dart';
import '../../domain/models/history_entry.dart';

enum HacksState {
  initializing,
  loadingChips,
  showingChips,
  loadingExplanation,
  showingExplanation,
  cooldown,
  error,
}

class HacksController extends ChangeNotifier {
  final HistoryRepository _historyRepository;
  final HacksRepository _hacksRepository;
  final GeminiService _geminiService;

  HacksState currentState = HacksState.initializing;
  List<HistoryEntry> history = [];
  List<String> chips = [];
  String explanation = '';
  Duration remainingTime = Duration.zero;

  Timer? _timer;
  bool _isDisposed = false;

  HacksController(
    this._historyRepository,
    this._hacksRepository,
    this._geminiService,
  ) {
    _initializeFlow();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _isDisposed = true;
    super.dispose();
  }

  void _safeNotify() {
    if (!_isDisposed) notifyListeners();
  }

  Future<void> _initializeFlow() async {
    final int? lastGenTime = await _hacksRepository.getCooldownTimestamp();

    if (lastGenTime != null) {
      final int elapsed = DateTime.now().millisecondsSinceEpoch - lastGenTime;
      final int cooldownMs = AppConfig.hacksCooldown.inMilliseconds;

      if (elapsed < cooldownMs) {
        _startTimer(cooldownMs - elapsed);
        currentState = HacksState.cooldown;
        _safeNotify();
        return;
      } else {
        await _hacksRepository.clearCooldown();
      }
    }

    history = await _historyRepository.loadHistory();
    loadChips();
  }

  void _startTimer(int remainingMs) {
    _timer?.cancel();
    remainingTime = Duration(milliseconds: remainingMs);

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingTime.inSeconds > 0) {
        remainingTime -= const Duration(seconds: 1);
      } else {
        _timer?.cancel();
        _hacksRepository.clearCooldown();
        if (currentState == HacksState.cooldown) {
          loadChips();
        }
      }
      _safeNotify();
    });
  }

  Future<void> loadChips() async {
    currentState = HacksState.loadingChips;
    _safeNotify();

    final futures = await Future.wait([
      _geminiService.fetchHackChips(history),
      Future.delayed(AppConfig.minimumLoadingDelay),
    ]);

    final fetchedChips = futures[0] as List<String>?;

    if (fetchedChips != null && fetchedChips.isNotEmpty) {
      chips = fetchedChips;
      currentState = HacksState.showingChips;
    } else {
      currentState = HacksState.error;
    }
    _safeNotify();
  }

  Future<void> loadExplanation(String topic) async {
    currentState = HacksState.loadingExplanation;
    _safeNotify();

    final futures = await Future.wait([
      _geminiService.fetchHackExplanation(history, topic),
      Future.delayed(AppConfig.minimumLoadingDelay),
    ]);

    final fetchedExplanation = futures[0] as String?;

    if (fetchedExplanation != null) {
      await _hacksRepository.startCooldown();
      _startTimer(AppConfig.hacksCooldown.inMilliseconds);

      explanation = fetchedExplanation;
      currentState = HacksState.showingExplanation;
    } else {
      currentState = HacksState.error;
    }
    _safeNotify();
  }

  void retry() {
    currentState = HacksState.initializing;
    _safeNotify();
    _initializeFlow();
  }
}
