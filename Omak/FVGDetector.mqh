//+------------------------------------------------------------------+
//|                      FVGDetector.mqh                             |
//|              Enhanced FVG detection with quality filtering         |
//+------------------------------------------------------------------+

#ifndef __FVGMQH__
#define __FVGMQH__

#include "Utils.mqh"

input int FVGLookback = 20;
input double FVGStrengthThreshold = 0.6;

struct FVG {
    double high;
    double low;
    double strength;
    datetime time;
    bool bullish;
};

FVG fvgPool[];
int fvgCount = 0;

void DetectFVGs(string symbol, ENUM_TIMEFRAMES timeframe) {
    int bars = iBars(symbol, timeframe);
    if (bars < FVGLookback + 3) return;
    
    ArraySetAsSeries(fvgPool, true);
    ArrayResize(fvgPool, 0);
    fvgCount = 0;
    
    int atrHandle = iATR(symbol, timeframe, 14);
    double atr[];
    ArraySetAsSeries(atr, true);
    CopyBuffer(atrHandle, 0, 0, FVGLookback, atr);
    IndicatorRelease(atrHandle);
    double avgRange = atr[0];
    
    for (int i = 3; i < FVGLookback; i++) {
        // Bullish FVG
        if (iLow(symbol, timeframe, i-2) > iHigh(symbol, timeframe, i)) {
            double fvgHigh = iLow(symbol, timeframe, i-2);
            double fvgLow = iHigh(symbol, timeframe, i);
            double volumeFactor = (double)(iVolume(symbol, timeframe, i-1) + iVolume(symbol, timeframe, i-2));

            int maHandle = iMA(symbol, timeframe, 20, 0, MODE_SMA, PRICE_CLOSE);
            double ma[];
            ArraySetAsSeries(ma, true);
            CopyBuffer(maHandle, 0, 0, FVGLookback, ma);
            IndicatorRelease(maHandle);

            double strength = MathMin(1.0, volumeFactor / ma[0]);
            
            if (strength >= FVGStrengthThreshold) {
                FVG fvg;
                fvg.high = fvgHigh;
                fvg.low = fvgLow;
                fvg.strength = strength;
                fvg.time = iTime(symbol, timeframe, i);
                fvg.bullish = true;
                
                ArrayResize(fvgPool, ++fvgCount);
                fvgPool[fvgCount-1] = fvg;
            }
        }
        
        // Bearish FVG
        if (iHigh(symbol, timeframe, i-2) < iLow(symbol, timeframe, i)) {
            double fvgHigh = iLow(symbol, timeframe, i);
            double fvgLow = iHigh(symbol, timeframe, i-2);
            double volumeFactor = (double)(iVolume(symbol, timeframe, i-1) + iVolume(symbol, timeframe, i-2));

            int maHandle = iMA(symbol, timeframe, 20, 0, MODE_SMA, PRICE_CLOSE);
            double ma[];
            ArraySetAsSeries(ma, true);
            CopyBuffer(maHandle, 0, 0, FVGLookback, ma);
            IndicatorRelease(maHandle);

            double strength = MathMin(1.0, volumeFactor / ma[0]);
            
            if (strength >= FVGStrengthThreshold) {
                FVG fvg;
                fvg.high = fvgHigh;
                fvg.low = fvgLow;
                fvg.strength = strength;
                fvg.time = iTime(symbol, timeframe, i);
                fvg.bullish = false;
                
                ArrayResize(fvgPool, ++fvgCount);
                fvgPool[fvgCount-1] = fvg;
            }
        }
    }
}

bool GetLatestFVG(FVG &dest, bool bullish) {
    for (int i = 0; i < fvgCount; i++) {
        if (fvgPool[i].bullish == bullish && fvgPool[i].strength >= FVGStrengthThreshold) {
            dest = fvgPool[i];
            return true;
        }
    }
    return false;
}

bool DetectValidFVG(bool bullish) {
    FVG dummy;
    return GetLatestFVG(dummy, bullish);
}

#endif // __FVGMQH__
