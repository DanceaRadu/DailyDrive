import 'dart:async';

import 'package:daily_drive/color_palette.dart';
import 'package:daily_drive/exercise_strategies/exercise_context.dart';
import 'package:daily_drive/models/exercise_session.model.dart';
import 'package:daily_drive/pages/start_exercise_page/submit_exercise_session_dialog.dart';
import 'package:daily_drive/services/exercise_session.service.dart';
import 'package:daily_drive/widgets/main_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../models/exercise_type.model.dart';
import '../auth_pages/error_dialog.dart';

class StartExercisePage extends StatefulWidget {
  const StartExercisePage({super.key, required this.exerciseType});

  final ExerciseType exerciseType;

  @override
  State<StartExercisePage> createState() => _StartExercisePageState();
}

class _StartExercisePageState extends State<StartExercisePage> with TickerProviderStateMixin {

  late ExerciseContext _exerciseContext;
  final ExerciseSessionService _exerciseSessionService = ExerciseSessionService();
  int _repCount = 0;
  bool _isTracking = false;
  bool _isPaused = false;
  bool isSubmitting = false;

  late AnimationController _animationController;
  late Animation<Offset> _buttonAnimation;
  late Animation<Offset> _textAnimation;
  late Animation<double> _textFadeAnimation;
  late Animation<double> _buttonFadeAnimation;

  late Timer _timer;
  int _elapsedTime = 0;

  @override
  void initState() {
    super.initState();
    _exerciseContext = ExerciseContext(widget.exerciseType, _onRepDetected);

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _buttonAnimation = Tween<Offset>(
      begin: const Offset(0, -0.5),
      end: const Offset(0, 0.25),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _buttonFadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );

    _textAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: const Offset(0, -0.4),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _textFadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _exerciseContext.reset();
    _exerciseContext.dispose();
    super.dispose();
  }

  void _onRepDetected(int repCount) {
    if(mounted) {
      setState(() {
        _repCount = (repCount / 2).floor();
      });
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_isPaused) {
        setState(() {
          _elapsedTime++;
        });
      }
    });
  }

  void _startTracking() {
    setState(() {
      _isTracking = true;
      _isPaused = false;
      _repCount = 0;
      _elapsedTime = 0;
    });
    _animationController.forward();
    _exerciseContext.reset();
    _startTimer();
    _exerciseContext.startRepDetection();
  }

  Future<void> _reset([bool? showDialog = true]) async {
    if(showDialog == true) {
      bool? result = await _showBackDialog(context);
      if (result == null || !result) return;
    }

    _timer.cancel();
    _exerciseContext.reset();
    _animationController.reverse();
    setState(() {
      _isTracking = false;
      _isPaused = false;
    });
  }

  void _submit(BuildContext context) async {
    _pause();
    setState(() {
      isSubmitting = true;
    });
    num? repCountNum = await SubmitExerciseSessionDialog.show(
        context,
        repCount: _repCount,
        exerciseType: widget.exerciseType,
        elapsedTime: _formatTime(_elapsedTime),
    );
    if(repCountNum == null) {
      setState(() {
        isSubmitting = false;
      });
      return;
    }
    int repCount = repCountNum.toInt();

    try {
      User? user = FirebaseAuth.instance.currentUser;
      if(user == null) {
        throw Exception('User not logged in');
      }
      await _exerciseSessionService.addSession(ExerciseSession(
        exerciseTypeId: widget.exerciseType.exerciseTypeId!,
        userId: user.uid,
        units: repCount,
        elapsedSeconds: _elapsedTime,
        createdAt: DateTime.now(),
        calories: repCount * widget.exerciseType.caloriesPerUnit,
      ));
      _reset(false);
    } catch(e) {
      _showErrorDialog('Error submitting.', 'Please try again.');
    } finally {
      setState(() {
        isSubmitting = false;
      });
    }
  }

  void _pause() {
    _exerciseContext.pauseRepDetection();
    setState(() {
      _isPaused = true;
    });
  }
  
  void _resume() {
    _exerciseContext.resumeRepDetection();
    setState(() {
      _isPaused = false;
    });
  }

  Future<bool?> _showBackDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you sure?'),
          backgroundColor: ColorPalette.darkerSurface,
          content: const Text(
            'Doing this will reset your progress. Continue?',
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Never mind'),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Yes'),
              onPressed: () {
                Navigator.pop(context, true);
              },
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return ErrorDialog(title: title, message: message);
        }
    );
  }

  String _formatTime(int elapsed) {
    final minutes = elapsed ~/ 60;
    final seconds = elapsed % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_isTracking,
      onPopInvokedWithResult: (bool dipPop, dynamic result) async {
        if(dipPop) return;
        final bool shouldPop = await _showBackDialog(context) ?? false;
        if (context.mounted && shouldPop) {
          Navigator.pop(context, result);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(widget.exerciseType.namePlural),
        ),
        body: SizedBox.expand(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SlideTransition(
                position: _textAnimation,
                child: FadeTransition(
                  opacity: _textFadeAnimation,
                  child: Column(
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '$_repCount',
                              style: const TextStyle(
                                fontSize: 72,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            TextSpan(
                              text: ' ${widget.exerciseType.suffix.toUpperCase()}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _formatTime(_elapsedTime),
                        style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                      ),
                    ]
                  ),
                ),
              ),
              SizedBox(
                width: 220,
                child: MainButton(
                  onPressed: _isTracking ? () { _submit(context); } : _startTracking,
                  text: _isTracking ? 'Submit' : 'Start Exercise',
                  isLoading: isSubmitting,
                ),
              ),
              SizedBox(
                width: 220,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SlideTransition(
                      position: _buttonAnimation,
                      child: FadeTransition(
                        opacity: _buttonFadeAnimation,
                        child: TextButton.icon(
                          onPressed: _reset,
                          icon: const Icon(Icons.restart_alt),
                          label: const Text('Reset'),
                        ),
                      ),
                    ),
                    SlideTransition(
                      position: _buttonAnimation,
                      child: FadeTransition(
                        opacity: _buttonFadeAnimation,
                        child: TextButton.icon(
                          onPressed: _isPaused ? _resume : _pause,
                          icon: _isPaused ? const Icon(Icons.play_arrow) : const Icon(Icons.pause),
                          label: _isPaused ? const Text('Resume') : const Text('Pause'),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
