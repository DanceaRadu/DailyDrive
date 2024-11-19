import 'package:daily_drive/color_palette.dart';
import 'package:daily_drive/exercise_strategies/exercise_context.dart';
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

  late AnimationController _animationController;
  late Animation<Offset> _buttonAnimation;
  late Animation<Offset> _textAnimation;
  late Animation<double> _textFadeAnimation;

  @override
  void initState() {
    super.initState();
    _exerciseContext = ExerciseContext(widget.exerciseType, _onRepDetected);

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _buttonAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, 1),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _textAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: const Offset(0, -0.5),
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
          child: Stack(
            alignment: Alignment.center,
            children: [
              SlideTransition(
                position: _textAnimation,
                child: FadeTransition(
                  opacity: _textFadeAnimation,
                  child: Text(
                    'Reps: $_repCount',
                    style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SlideTransition(
                position: _buttonAnimation,
                child: ElevatedButton(
                  onPressed: _isTracking ? _stopTracking : _startTracking,
                  child: Text(_isTracking ? 'Stop Exercise' : 'Start Exercise'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
