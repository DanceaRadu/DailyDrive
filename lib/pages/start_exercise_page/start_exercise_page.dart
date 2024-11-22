import 'package:daily_drive/color_palette.dart';
import 'package:daily_drive/exercise_strategies/exercise_context.dart';
import 'package:daily_drive/widgets/main_button.dart';
import 'package:flutter/material.dart';

import '../../models/exercise_type.model.dart';

class StartExercisePage extends StatefulWidget {
  const StartExercisePage({super.key, required this.exerciseType});

  final ExerciseType exerciseType;

  @override
  State<StartExercisePage> createState() => _StartExercisePageState();
}

class _StartExercisePageState extends State<StartExercisePage> with TickerProviderStateMixin {

  late ExerciseContext _exerciseContext;
  int _repCount = 0;
  bool _isTracking = false;
  bool _isPaused = false;

  late AnimationController _animationController;
  late Animation<Offset> _buttonAnimation;
  late Animation<Offset> _textAnimation;
  late Animation<double> _textFadeAnimation;
  late Animation<double> _buttonFadeAnimation;

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
    _exerciseContext.stopRepDetection();
    _exerciseContext.reset();
    _exerciseContext.dispose();
    super.dispose();
  }

  void _onRepDetected(int repCount) {
    if(mounted) {
      setState(() {
        _repCount = repCount;
      });
    }
  }

  void _startTracking() {
    setState(() {
      _isTracking = true;
      _repCount = 0;
    });
    _animationController.forward();
    _exerciseContext.reset();
    _exerciseContext.startRepDetection();
  }

  void _stopTracking() {
    _exerciseContext.stopRepDetection();
    _animationController.reverse();
    setState(() {
      _isTracking = false;
    });
    //popup whatever else logic idk
  }

  void _submit() {

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
            'Are you sure you want to leave this page?',
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
              child: const Text('Leave'),
              onPressed: () {
                Navigator.pop(context, true);
              },
            ),
          ],
        );
      },
    );
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
                      Text(
                        'Reps: $_repCount',
                        style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Reps: $_repCount',
                        style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                      ),
                    ]
                  ),
                ),
              ),
              SizedBox(
                width: 220,
                child: MainButton(
                  onPressed: _isTracking ? _submit : _startTracking,
                  text: _isTracking ? 'Submit' : 'Start Exercise',
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
                          onPressed: _stopTracking,
                          icon: const Icon(Icons.restart_alt), // Replace with your desired icon
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
