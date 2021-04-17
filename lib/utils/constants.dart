import 'package:flutter/material.dart';
import 'package:pomodoro/model/pomodoro_status.dart';

const pomodoroTotalTime = 6;
const shortBreakTime = 3;
const longBreakTime = 15 * 60;
const pomodoriPerSet = 4;

const Map<PomodoroStatus, String> statusDescription = {
  PomodoroStatus.runningPomodoro: 'Pomodoro is running, time to be focused',
  PomodoroStatus.pausedPomodoro: 'Ready for a focused pomodoro?',
  PomodoroStatus.pausedShortBreak: 'Short break paused',
  PomodoroStatus.runningShortBreak: 'Enjoy your short break',
  PomodoroStatus.pausedLongBreak: 'Long break paused',
  PomodoroStatus.runningLongBreak: 'Long break running',
  PomodoroStatus.setFinished:
      'Congradulations! You made it! Enjoy your long break',
};
const Map<PomodoroStatus, MaterialColor> statusColor = {
  PomodoroStatus.runningPomodoro: Colors.green,
  PomodoroStatus.pausedPomodoro: Colors.orange,
  PomodoroStatus.runningShortBreak: Colors.red,
  PomodoroStatus.pausedShortBreak: Colors.orange,
  PomodoroStatus.runningLongBreak: Colors.red,
  PomodoroStatus.pausedLongBreak: Colors.orange,
  PomodoroStatus.setFinished: Colors.orange,
};
