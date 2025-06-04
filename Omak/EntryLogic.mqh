//+------------------------------------------------------------------+
//|                    EntryLogic.mqh                                |
//| Enhanced entry logic for confluence and smart money concepts    |
//+------------------------------------------------------------------+
#ifndef __ENTRYLOGIC_MQH__
#define __ENTRYLOGIC_MQH__

#include "FVGDetector.mqh"
#include "SignalScoreboard.mqh"
#include "TradeManager.mqh"
#include "OrderBlockDetector.mqh"

// Use ATR-based SL/TP instead of static 50/100 pips
double GetATR(int period = 14) {
    int handle = iATR(_Symbol, Period(), period);
    double atr[];
    ArraySetAsSeries(atr, true);
    if (CopyBuffer(handle, 0, 0, 1, atr) <= 0) {
        IndicatorRelease(handle);
        return 50 * _Point;
    }
    IndicatorRelease(handle);
    return atr[0];
}

double CalculateEntryPrice(int tradeDirection) {
    return (tradeDirection == ORDER_TYPE_BUY)
        ? SymbolInfoDouble(_Symbol, SYMBOL_ASK)
        : SymbolInfoDouble(_Symbol, SYMBOL_BID);
}

double CalculateStopLoss(double entryPrice, int tradeDirection) {
    double atr = GetATR();
    double slDistance = atr * 2;
    return (tradeDirection == ORDER_TYPE_BUY) ? entryPrice - slDistance : entryPrice + slDistance;
}

double CalculateTakeProfit(double entryPrice, int tradeDirection) {
    double atr = GetATR();
    double tpDistance = atr * 4;
    return (tradeDirection == ORDER_TYPE_BUY) ? entryPrice + tpDistance : entryPrice - tpDistance;
}

#endif
