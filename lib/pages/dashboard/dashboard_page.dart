import 'package:daily_drive/pages/dashboard/day_summary.dart';
import 'package:daily_drive/styling_variables.dart';
import 'package:flutter/cupertino.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(StylingVariables.pagePadding),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            DaySummary(),
          ],
        ),
      ),
    );
  }
}
