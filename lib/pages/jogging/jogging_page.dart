import 'dart:async';

import 'package:daily_drive/color_palette.dart';
import 'package:daily_drive/models/exercise_type.model.dart';
import 'package:daily_drive/styling_variables.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../models/exercise_session.model.dart';
import '../../services/exercise_session.service.dart';
import '../../widgets/main_button.dart';
import '../auth_pages/error_dialog.dart';
import '../start_exercise_page/submit_exercise_session_dialog.dart';

class JoggingPage extends StatefulWidget {

  final ExerciseType joggingExerciseType;

  const JoggingPage({
    super.key,
    required this.joggingExerciseType,
  });

  @override
  State<JoggingPage> createState() => _JoggingPageState();
}

class _JoggingPageState extends State<JoggingPage> with TickerProviderStateMixin {
  late GoogleMapController _mapController;
  Set<Polyline> _polylines = {};
  List<LatLng> _route = [];
  double _distanceTraveled = 0.0;
  StreamSubscription<Position >? _positionStream;
  LatLng? _lastPosition;

  late AnimationController _animationController;
  late Animation<Offset> _buttonAnimation;
  late Animation<Offset> _textAnimation;
  late Animation<double> _textFadeAnimation;
  late Animation<double> _buttonFadeAnimation;

  bool _isTracking = false;
  bool _isPaused = false;
  bool isSubmitting = false;

  late Timer _timer;
  int _elapsedTime = 0;
  final ExerciseSessionService _exerciseSessionService = ExerciseSessionService();

  @override
  void initState() {
    super.initState();

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
    _positionStream?.cancel();
    _timer.cancel();
    super.dispose();
  }

  Future<void> _startTracking() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if(!mounted) return;

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if(!mounted) return;
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Location permission is required to track jogging routes."),
          ),
        );
        return;
      }
    }

    setState(() {
      _isTracking = true;
      _isPaused = false;
      _elapsedTime = 0;
    });
    _animationController.forward();
    _startTimer();

    final geoLocator = Geolocator.getPositionStream();
    _positionStream = geoLocator.listen(handlePositionEvent);
  }

  void _pause() {
    _lastPosition = null;
    _positionStream?.cancel();
    setState(() {
      _isPaused = true;
    });
  }

  void _resume() {
    _positionStream = Geolocator.getPositionStream().listen(handlePositionEvent);
    setState(() {
      _isPaused = false;
    });
  }

  Future<void> _reset([bool? showDialog = true]) async {
    if(showDialog == true) {
      bool? result = await _showBackDialog(context);
      if (result == null || !result) return;
    }

    _timer.cancel();
    _animationController.reverse();
    _positionStream?.cancel();

    setState(() {
      _polylines = {};
      _route = [];
      _lastPosition = null;
      _isTracking = false;
      _isPaused = false;
      _elapsedTime = 0;
      _distanceTraveled = 0.0;
    });
  }

  void _submit(BuildContext context) async {
    _pause();
    setState(() {
      isSubmitting = true;
    });
    num? distance = await SubmitExerciseSessionDialog.show(
      context,
      repCount: _distanceTraveled,
      exerciseType: widget.joggingExerciseType,
      elapsedTime: _formatTime(_elapsedTime),
      isDecimal: true,
    );
    if(distance == null) {
      setState(() {
        isSubmitting = false;
      });
      return;
    }

    try {
      User? user = FirebaseAuth.instance.currentUser;
      if(user == null) {
        throw Exception('User not logged in');
      }
      await _exerciseSessionService.addSession(ExerciseSession(
        exerciseTypeId: widget.joggingExerciseType.exerciseTypeId!,
        userId: user.uid,
        units: distance,
        elapsedSeconds: _elapsedTime,
        createdAt: DateTime.now(),
        calories: distance * widget.joggingExerciseType.caloriesPerUnit,
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

  String _formatInformationString(int elapsed, double distance) {
    final minutes = elapsed ~/ 60;
    final seconds = elapsed % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')} | ${distance.toStringAsFixed(2)} km';
  }

  String _formatTime(int elapsed) {
    final minutes = elapsed ~/ 60;
    final seconds = elapsed % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
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

  void handlePositionEvent(Position position) {
    final currentLatLng = LatLng(position.latitude, position.longitude);

    if (_lastPosition != null) {
      final distance = Geolocator.distanceBetween(
        _lastPosition!.latitude,
        _lastPosition!.longitude,
        currentLatLng.latitude,
        currentLatLng.longitude,
      );
      setState(() {
        _distanceTraveled += distance / 1000;
        _route.add(currentLatLng);
        _polylines.add(
          Polyline(
            polylineId: const PolylineId("route"),
            points: _route,
            color: ColorPalette.accent,
            width: 5,
          ),
        );
      });
    }

    setState(() {
      _lastPosition = currentLatLng;
    });
    _mapController.animateCamera(
      CameraUpdate.newLatLng(currentLatLng),
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
          centerTitle: true,
          title: const Text('Jogging'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(StylingVariables.pagePadding),
          child: Column(
            children: [
              Flexible(
                flex: 2,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: GoogleMap(
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                    polylines: _polylines,
                    initialCameraPosition: const CameraPosition(
                      target: LatLng(45.756486613865576, 21.22874790717381),
                      zoom: 15,
                    ),
                    onMapCreated: (GoogleMapController controller) {
                      _mapController = controller;
                    },
                  ),
                ),
              ),
              Flexible(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SlideTransition(
                      position: _textAnimation,
                      child: FadeTransition(
                        opacity: _textFadeAnimation,
                        child: Text(
                          _formatInformationString(_elapsedTime, _distanceTraveled),
                          style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 220,
                      child: MainButton(
                        onPressed: _isTracking ? () { _submit(context); } : _startTracking,
                        text: _isTracking ? 'Submit' : 'Start Jogging',
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
            ],
          ),
        ),
      ),
    );
  }
}
