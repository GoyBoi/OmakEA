//+------------------------------------------------------------------+
//|                    SignalFilter.mqh                              |
//|              Dynamic signal strength evaluation                  |
//+------------------------------------------------------------------+
#ifndef __SIGNALFILTER_MQH__
#define __SIGNALFILTER_MQH__

#include "ADXFilter.mqh"
#include "MomentumFilter.mqh"
#include "CandlePatternFilter.mqh"
#include "KillZoneFilter.mqh"
#include "Utils.mqh"

extern int signalScore;
input int BaseSignalScore = 3;
input bool UseDynamicThreshold = true;

bool IsSignalStrongEnough()
{
    int requiredScore = BaseSignalScore;

    if(UseDynamicThreshold)
    {
        int atrHandle = iATR(_Symbol, Period(), 14);
        if(atrHandle != INVALID_HANDLE)
        {
            double atr[];
            if(CopyBuffer(atrHandle, 0, 0, 1, atr) > 0)
            {
                double atrValue = atr[0];
                if(atrValue > 50 * _Point)
                    requiredScore--;
            }
            IndicatorRelease(atrHandle);
        }
        requiredScore = MathMax(2, requiredScore);
    }

    if(signalScore < requiredScore)
    {
        Print("[OMAK][FILTER] Signal too weak. Score: ", signalScore, " / Required: ", requiredScore);
        return false;
    }

    // Additional filters
    if(!IsStrongTrend())
        return false;

    if(!(IsBullishMomentum() || IsBearishMomentum()))
        return false;

    if(!IsWithinKillZone())
        return false;

    if(!(IsBullishEngulfing() || IsBearishEngulfing()))
        return false;

    return true;
}

#endif

