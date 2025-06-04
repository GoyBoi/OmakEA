//+------------------------------------------------------------------+
//|                    ExecutionFilter.mqh                           |
//|   Prevents overtrading and enforces trade spacing and filters    |
//+------------------------------------------------------------------+
#ifndef __EXECUTIONFILTER_MQH__
#define __EXECUTIONFILTER_MQH__

datetime lastTradeTime = 0;
input int MinTradeIntervalMinutes = 30; // Minimum time between trades
input bool EnableTimeFilter = true;
input int BlockStartHour = 0;   // e.g., 0 = 00:00
input int BlockEndHour = 5;     // e.g., 5 = 05:00

// Determines if current time is in a blocked session
bool IsInBlockedTimeWindow() {
    if (!EnableTimeFilter) return false;
    MqlDateTime dt; TimeToStruct(TimeCurrent(), dt);
    int currentHour = dt.hour;
    return (currentHour >= BlockStartHour && currentHour < BlockEndHour);
}

// Checks if the system is allowed to trade at the moment
bool CanExecuteTrade() {
    datetime now = TimeCurrent();

    // Time filter
    if (IsInBlockedTimeWindow()) {
        Print("[OMAK][FILTER] Blocked due to time window: ", BlockStartHour, "h to ", BlockEndHour, "h");
        return false;
    }

    // Trade spacing filter
    int minutesSinceLastTrade = (int)((now - lastTradeTime) / 60);
    if (minutesSinceLastTrade < MinTradeIntervalMinutes) {
        Print("[OMAK][FILTER] Trade blocked — last trade was ", minutesSinceLastTrade, " minutes ago.");
        return false;
    }

    return true;
}

// Register a trade execution timestamp
void RecordTradeExecuted() {
    lastTradeTime = TimeCurrent();
    Print("[OMAK][FILTER] Trade timestamp recorded: ", TimeToString(lastTradeTime, TIME_DATE | TIME_MINUTES));
}

#endif