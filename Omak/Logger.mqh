//+------------------------------------------------------------------+
//|                          Logger.mqh                              |
//|     Custom logging utility for Omak strategy debugging           |
//+------------------------------------------------------------------+
#ifndef __LOGGER_MQH__
#define __LOGGER_MQH__

enum LogLevel { LOG_INFO, LOG_WARN, LOG_ERROR };

// Logs a message to Experts tab with level tag
void Log(string msg, LogLevel level = LOG_INFO) {
    string prefix = "[OMAK] ";
    switch(level) {
        case LOG_INFO:  Print(prefix + "[INFO] " + msg); break;
        case LOG_WARN:  Print(prefix + "[WARN] " + msg); break;
        case LOG_ERROR: Print(prefix + "[ERROR] " + msg); break;
    }
}

// Convenience stub for info-level log
void LogInfo(string msg) {
    Log(msg, LOG_INFO);
}

// Logs key decision points
void LogSignal(string context, string signal, double value = 0.0) {
    Print("[OMAK][SIGNAL] " + context + ": " + signal + " | Value: ", DoubleToString(value, 5));
}

// Logs risk and entry logic
void LogTradeDecision(double lotSize, double slPips, double rr, bool buy) {
    string dir = buy ? "BUY" : "SELL";
    Print("[OMAK][TRADE] Direction: " + dir +
          " | Lot: " + DoubleToString(lotSize, 2) +
          " | SL (pips): " + DoubleToString(slPips, 1) +
          " | R:R: " + DoubleToString(rr, 2));
}

// Logs trade details when executed
void LogTrade(double entryPrice, double sl, double tp, int tradeDirection) {
    string dir = (tradeDirection == ORDER_TYPE_BUY) ? "Buy" : "Sell";
    PrintFormat("[OMAK][TRADE] Executed %s | Entry: %.5f | SL: %.5f | TP: %.5f",
                 dir, entryPrice, sl, tp);
}


// Optional: Deinitialization log stub
void LogDeinit(string msg) {
    Print("[OMAK][INFO] EA Deinitialized: " + msg);
}

#endif // __LOGGER_MQH__

