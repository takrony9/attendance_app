import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:flutter/foundation.dart';

class TimerLogic with ChangeNotifier {
  final isHours = true;
  var status;
  bool start = false;
  final StopWatchTimer stopWatchTimer = StopWatchTimer(
    mode: StopWatchMode.countUp,
  );
  void timerCount() async {
    if (start) {
      status = StopWatchExecute.start;
      stopWatchTimer.onExecute.add(status);
    } else {
      status = StopWatchExecute.reset;
      stopWatchTimer.onExecute.add(status);
    }
  }
}
