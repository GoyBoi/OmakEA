//+------------------------------------------------------------------+
//|                       BacktestHelper.mqh                         |
//|      Helper for tracking and profiling backtest stats            |
//+------------------------------------------------------------------+
#ifndef __BACKTESTHELPER_MQH__
#define __BACKTESTHELPER_MQH__

datetime sessionStart;
int totalTrades = 0;
int wins = 0;
int losses = 0;

void StartSession() {
    sessionStart = TimeCurrent();
    totalTrades = wins = losses = 0;
    Print("[OMAK][BT] Backtest session started.");
}

void LogTradeResult(bool win) {
    totalTrades++;
    if (win) wins++;
    else losses++;
}

void EndSession() {
    double winRate = totalTrades > 0 ? (double)wins / totalTrades * 100.0 : 0.0;
    Print("[OMAK][BT] Session Summary — Total Trades: ", totalTrades,
          " | Wins: ", wins, " | Losses: ", losses,
          " | Win Rate: ", DoubleToString(winRate, 2), "%");
}

#endif