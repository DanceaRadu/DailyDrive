import 'package:daily_drive/exercise_strategies/rep_detection.strategy.dart';

class PushupDetectionStrategy extends RepDetectionStrategy {
  @override
  bool detectRep(double x, double y, double z, DateTime? lastRepTime) {
    if(lastRepTime != null && DateTime.now().difference(lastRepTime) < const Duration(milliseconds: 400)) {
      return false;
    }
    if(x.abs() > 0.8) {
      return true;
    }
    return false;
  }
}