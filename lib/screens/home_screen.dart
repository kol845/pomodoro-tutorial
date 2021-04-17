import 'dart:async';

import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:pomodoro/utils/constants.dart';
import 'package:pomodoro/widgets/custom_button.dart';
import 'package:pomodoro/widgets/progress_icons.dart';
import 'package:pomodoro/model/pomodoro_status.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

const _btnTextStart = "Start Pomodoro";
const _btnTextResumePomodoro = "Resume Pomodoro";
const _btntextResumeBreak = 'Resume Break';
const _btnTextStartShortBreak = "Take Short Break";
const _btnTextStartLongBreak = "Take Long Break";
const _btnTextStartNewSet = "Start New Set";
const _btnTextPause = "Pause";
const _btnTextReset = "Reset";

class _HomeState extends State<Home> {
  static AudioCache player = AudioCache();
  int remainingTime = pomodoroTotalTime;
  String mainBtnTxt = _btnTextStart;
  PomodoroStatus pomodoroStatus = PomodoroStatus.pausedPomodoro;
  Timer _timer;
  int pomodoroNum = 0;
  int setNum = 0;
  @override
  void dispose() {
    _cancelTimer();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    player.load('tomato_splat.mp3');
  }

  @override
  Widget build(BuildContext context) {
    // Build method is called whenever the widgets state is changed

    return Scaffold(
      backgroundColor: Colors.grey[800],
      body: SafeArea(
          // For displaying bellow phone top menu
          child: Center(
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Text(
              'Pomodoro number: $pomodoroNum',
              style: TextStyle(fontSize: 32, color: Colors.white),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Set: $setNum',
              style: TextStyle(fontSize: 22, color: Colors.white),
            ),
            Expanded(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                  CircularPercentIndicator(
                    radius: 220.0,
                    lineWidth: 15.0,
                    percent: _getPomodoroPercentage(),
                    circularStrokeCap: CircularStrokeCap.round,
                    center: Text(_secondsToFormatedString(remainingTime),
                        style: TextStyle(fontSize: 40, color: Colors.white)),
                    progressColor: statusColor[pomodoroStatus],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ProgressIcons(
                      total: pomodoriPerSet,
                      done: pomodoroNum - (setNum * pomodoriPerSet)),
                  SizedBox(
                    height: 10,
                  ),
                  Text(statusDescription[pomodoroStatus],
                      style: TextStyle(color: Colors.white)),
                  CustomButton(
                    onTap: _mainButtonPressed,
                    text: mainBtnTxt,
                  ),
                  CustomButton(
                    onTap: _resetButtonPressed,
                    text: "Reset",
                  )
                ])),
          ],
        ),
      )),
    );
  }

  _secondsToFormatedString(int seconds) {
    int roundedMinutes = seconds ~/ 60;
    int remainingSeconds = seconds - (roundedMinutes * 60);
    String remainingSecondsFormated;
    if (remainingSeconds < 10) {
      remainingSecondsFormated = '0$remainingSeconds';
    } else {
      remainingSecondsFormated = remainingSeconds.toString();
    }
    return '$roundedMinutes:$remainingSecondsFormated';
  }

  _mainButtonPressed() {
    switch (pomodoroStatus) {
      case PomodoroStatus.pausedPomodoro:
        _startPomodoroCountdown();
        break;
      case PomodoroStatus.runningPomodoro:
        _pausePomodoroCountdown();
        break;
      case PomodoroStatus.runningShortBreak:
        _pauseShortBreakCountdown();
        break;
      case PomodoroStatus.pausedShortBreak:
        _startShortBreakCountdown();
        break;
      case PomodoroStatus.runningLongBreak:
        _pauseLongBreakCountdown();
        break;
      case PomodoroStatus.pausedLongBreak:
        _startLongBreakCountdown();
        break;
      case PomodoroStatus.setFinished:
        setNum++;
        _startPomodoroCountdown();
        break;
    }
  }

  _startShortBreakCountdown() {
    pomodoroStatus = PomodoroStatus.runningShortBreak;
    _cancelTimer();
    setState(() {
      mainBtnTxt = _btnTextPause;
    });
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (remainingTime > 0) {
        setState(() {
          remainingTime--;
        });
      } else {
        _playSound();
        remainingTime = pomodoroTotalTime;
        _cancelTimer();
        pomodoroStatus = PomodoroStatus.pausedPomodoro;
        setState(() {
          mainBtnTxt = _btnTextStart;
        });
      }
    });
  }

  _startLongBreakCountdown() {
    pomodoroStatus = PomodoroStatus.runningLongBreak;
    _cancelTimer();
    setState(() {
      mainBtnTxt = _btnTextPause;
    });
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (remainingTime > 0) {
        setState(() {
          remainingTime--;
        });
      } else {
        _playSound();
        remainingTime = pomodoroTotalTime;
        _cancelTimer();
        pomodoroStatus = PomodoroStatus.setFinished;
        setState(() {
          mainBtnTxt = _btnTextStartNewSet;
        });
      }
    });
  }

  _pauseShortBreakCountdown() {
    pomodoroStatus = PomodoroStatus.pausedShortBreak;
    _pauseBreakCountdown();
  }

  _pauseLongBreakCountdown() {
    pomodoroStatus = PomodoroStatus.pausedLongBreak;
    _pauseBreakCountdown();
  }

  _pauseBreakCountdown() {
    _cancelTimer();
    setState(() {
      mainBtnTxt = _btntextResumeBreak;
    });
  }

  _pausePomodoroCountdown() {
    pomodoroStatus = PomodoroStatus.pausedPomodoro;
    _cancelTimer();
    setState(() {
      mainBtnTxt = _btnTextResumePomodoro;
    });
  }

  _resetButtonPressed() {
    pomodoroNum = 0;
    setNum = 0;
    _cancelTimer();
    _stopCountDown();
  }

  _stopCountDown() {
    pomodoroStatus = PomodoroStatus.pausedPomodoro;
    setState(() {
      mainBtnTxt = _btnTextStart;
      remainingTime = pomodoroTotalTime;
    });
  }

  _startPomodoroCountdown() {
    pomodoroStatus = PomodoroStatus.runningPomodoro;
    _cancelTimer();

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (remainingTime > 0) {
        // If time is not over
        setState(() {
          remainingTime--;
          mainBtnTxt = _btnTextPause;
        });
      } else {
        _playSound();
        pomodoroNum++;
        _cancelTimer();
        if (pomodoroNum % pomodoriPerSet == 0) {
          pomodoroStatus = PomodoroStatus.pausedLongBreak;
          setState(() {
            remainingTime = longBreakTime;
            mainBtnTxt = _btnTextStartLongBreak;
          });
        } else {
          pomodoroStatus = PomodoroStatus.pausedShortBreak;
          setState(() {
            remainingTime = shortBreakTime;
            mainBtnTxt = _btnTextStartShortBreak;
          });
        }
      }
    });
  }

  _cancelTimer() {
    if (_timer != null) {
      _timer.cancel();
    }
  }

  _getPomodoroPercentage() {
    int totalTime;
    switch (pomodoroStatus) {
      case PomodoroStatus.runningPomodoro:
        totalTime = pomodoroTotalTime;
        break;
      case PomodoroStatus.pausedPomodoro:
        totalTime = pomodoroTotalTime;
        break;
      case PomodoroStatus.runningShortBreak:
        totalTime = shortBreakTime;
        break;
      case PomodoroStatus.pausedShortBreak:
        totalTime = shortBreakTime;
        break;
      case PomodoroStatus.runningLongBreak:
        totalTime = longBreakTime;
        break;
      case PomodoroStatus.pausedLongBreak:
        totalTime = longBreakTime;
        break;
      case PomodoroStatus.setFinished:
        totalTime = pomodoroTotalTime;
        break;
    }
    double percentage = (totalTime - remainingTime) / totalTime;
    return percentage;
  }

  _playSound() {
    player.play('tomato_splat.mp3');
  }
}
