import 'package:daily_drive/exercise_strategies/rep_detection.strategy.dart';

class PullupDetectionStrategy extends RepDetectionStrategy {

  @override
  bool detectRep(double x, double y, double z, DateTime? lastRepTime) {
    if(lastRepTime != null && DateTime.now().difference(lastRepTime) < const Duration(seconds: 1)) {
      return false;
    }
    if(y.abs() > 1) {
      return true;
    }
    return false;
  }
}