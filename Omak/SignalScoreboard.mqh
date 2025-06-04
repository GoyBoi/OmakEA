//+------------------------------------------------------------------+
//|                    SignalScoreboard.mqh                          |
//|              Centralized signal scoring system                   |
//+------------------------------------------------------------------+

#ifndef __SIGNALSCOREBOARD_MQH__
#define __SIGNALSCOREBOARD_MQH__

int signalScore = 0;

void ResetSignalScore() { signalScore = 0; }

void AddScore(string reason, int points) {
    signalScore += points;
    
    Print("[OMAK][SCORE] +", points, " -> ", reason, "| Total Score: ", signalScore);
}

int GetSignalScore() { return signalScore; }

#endif // __SIGNALSCOREBOARD_MQH__