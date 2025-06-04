//+------------------------------------------------------------------+
//|                       CRTBias.mqh                                |
//|           Enhanced Candle Reversal Trend bias detection            |
//+------------------------------------------------------------------+

#ifndef __CRTBIAS_MQH__
#define __CRTBIAS_MQH__

input double CRT_Body_Threshold = 0.40;  
input int CRT_Lookback = 3;
input double CRT_Confirmation_Threshold = 0.60;

struct CRTAnalysis {
    bool bullish;
    double strength;
    bool confirmed;
};

void GetCandleData(int shift, double &body, double &range, bool &bullish, double &high, double &low) {
    double open = iOpen(NULL, PERIOD_D1, shift);
    double close = iClose(NULL, PERIOD_D1, shift);
    high = iHigh(NULL, PERIOD_D1, shift);
    low = iLow(NULL, PERIOD_D1, shift);
    
    body = MathAbs(close - open);
    range = high - low;
    bullish = (close > open);
}

CRTAnalysis AnalyzeCandlePattern(int shift) {
    double body, range, high, low;
    bool bullish;
    
    GetCandleData(shift, body, range, bullish, high, low);
    
    CRTAnalysis result;
    result.bullish = bullish;
    
    if (range == 0) {
        result.strength = 0;
        result.confirmed = false;
        return result;
    }
    
    result.strength = body / range;

    double prevHigh = iHigh(NULL, PERIOD_D1, shift+1);
    double prevLow = iLow(NULL, PERIOD_D1, shift+1);
    
    if (bullish) {
        result.confirmed = (high > prevHigh && low > prevLow);
    } else {
        result.confirmed = (high < prevHigh && low < prevLow);
    }
    
    return result;
}

int GetCRTBias() {
    int bullishCount = 0;
    int bearishCount = 0;
    double totalStrength = 0;
    
    for (int i = 0; i < CRT_Lookback; i++) {
        CRTAnalysis analysis = AnalyzeCandlePattern(i);
        
        if (analysis.strength >= CRT_Body_Threshold) {
            totalStrength += analysis.strength;
            
            if (analysis.bullish) {
                bullishCount++;
                if (analysis.confirmed) bullishCount++;
            } else {
                bearishCount++;
                if (analysis.confirmed) bearishCount++;
            }
        }
    }
    
    double totalPatterns = bullishCount + bearishCount;
    if (totalPatterns == 0) return 0;
    
    double biasStrength = MathAbs(bullishCount - bearishCount) / totalPatterns;
    
    if (biasStrength < CRT_Confirmation_Threshold) return 0;
    
    return (bullishCount > bearishCount) ? 2 : -2;
}

#endif // __CRTBIAS_MQH__
