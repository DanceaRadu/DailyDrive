import 'package:daily_drive/exercise_strategies/rep_detection.strategy.dart';

class SitupDetectionStrategy extends RepDetectionStrategy {
  @override
  bool detectRep(double x, double y, double z, DateTime? lastRepTime) {
    if(lastRepTime != null && DateTime.now().difference(lastRepTime) < const Duration(milliseconds : 800)) {
      return false;
    }
    if(z.abs() > 1) {
      return true;
    }
    return false;
  }
}