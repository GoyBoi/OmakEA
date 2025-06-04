//+------------------------------------------------------------------+
//|                      MAAnalyzer.mqh                              |
//|              Enhanced Moving Average analysis                    |
//+------------------------------------------------------------------+

#ifndef __MAANALYZER_MQH__
#define __MAANALYZER_MQH__

#define TF_COUNT 4
const ENUM_TIMEFRAMES timeframes[TF_COUNT] = { PERIOD_M15, PERIOD_M30, PERIOD_H1, PERIOD_H4 };

input int MA_Period_21 = 21;
input int MA_Period_200 = 200;
input double MA_Alignment_Threshold = 0.75; // Percentage of timeframes that must align

// Helper function to get MA value at a shift
double GetMAValue(ENUM_TIMEFRAMES tf, int period, int shift) {
    int handle = iMA(_Symbol, tf, period, 0, MODE_EMA, PRICE_CLOSE);
    if (handle == INVALID_HANDLE) {
        Print("Failed to create MA handle for tf: ", tf, " period: ", period);
        return 0;
    }
    
    double buffer[];
    if (CopyBuffer(handle, 0, shift, 1, buffer) != 1) {
        Print("Failed to copy buffer for MA at shift ", shift);
        return 0;
    }
    
    return buffer[0];
}

// Returns true if sufficient 21-period MAs are aligned in same direction
bool Are21MAsAligned(bool bullish = true) {
    int alignedCount = 0;
    
    for (int i = 0; i < TF_COUNT; i++) {
        ENUM_TIMEFRAMES tf = timeframes[i];
        double current = GetMAValue(tf, MA_Period_21, 0);
        double previous = GetMAValue(tf, MA_Period_21, 1);
        
        if ((bullish && current > previous) || (!bullish && current < previous)) {
            alignedCount++;
        }
    }
    
    return ((double)alignedCount / TF_COUNT) >= MA_Alignment_Threshold;
}

// Checks if 200 EMA confirms the trend on the specified timeframe
bool Is200MAConfirmingTrend(bool bullish, ENUM_TIMEFRAMES tf) {
    double currentPrice = iClose(NULL, 0, 0);
    double ma200 = GetMAValue(tf, MA_Period_200, 0);
    
    if (bullish) {
        return currentPrice > ma200 && 
               GetMAValue(tf, MA_Period_200, 0) > GetMAValue(tf, MA_Period_200, 1);
    } else {
        return currentPrice < ma200 && 
               GetMAValue(tf, MA_Period_200, 0) < GetMAValue(tf, MA_Period_200, 1);
    }
}

#endif // __MAANALYZER_MQH__