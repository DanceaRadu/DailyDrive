import 'package:daily_drive/exercise_strategies/rep_detection.strategy.dart';

class SquatDetectionStrategy extends RepDetectionStrategy {
  @override
  bool detectRep(double x, double y, double z, DateTime? lastRepTime) {
    if(x.abs() > 1.0) {
      return true;
    }
    return false;
  }
}