//+------------------------------------------------------------------+
//|                      Utils.mqh                                   |
//| Shared constants and utility functions                           |
//+------------------------------------------------------------------+
#ifndef __UTILS_MQH__
#define __UTILS_MQH__

// Determine pip factor for symbol
double PipFactor() {
    int digits = (int)SymbolInfoInteger(_Symbol, SYMBOL_DIGITS);
    return _Point * (digits == 3 || digits == 5 ? 10 : 1);
}

// Get current spread in pips
double CurrentSpreadPips() {
    double ask = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
    double bid = SymbolInfoDouble(_Symbol, SYMBOL_BID);
    return (ask - bid) / PipFactor();
}

#endif
