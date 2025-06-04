//+------------------------------------------------------------------+
//|                  TradeHealthMonitor.mqh                          |
//|  Logs trade outcomes and detects prolonged underperformance      |
//+------------------------------------------------------------------+
#ifndef __TRADEHEALTHMONITOR_MQH__
#define __TRADEHEALTHMONITOR_MQH__

int totalTrades = 0;
int wins = 0;
int losses = 0;

void TradeHealthLog(bool win) {
    totalTrades++;
    if (win) wins++;
    else losses++;

    double winRate = totalTrades > 0 ? (double)wins / totalTrades * 100.0 : 0.0;
    Print("[OMAK][HEALTH] Trades: ", totalTrades, " | Wins: ", wins, " | Losses: ", losses,
          " | Win Rate: ", DoubleToString(winRate, 2), "%");

    // Example logic: if win rate < 40%, reduce lot size or pause
    if (totalTrades >= 10 && winRate < 40.0) {
        Print("[OMAK][HEALTH][WARN] Win rate below 40%. Consider reducing lot size or pausing.");
    }
}

#endif
