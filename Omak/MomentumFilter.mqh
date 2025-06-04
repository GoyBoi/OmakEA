//+------------------------------------------------------------------+
//|                                               MomentumFilter.mqh |
//|                        Custom Momentum Filter Module             |
//+------------------------------------------------------------------+
#ifndef __MOMENTUMFILTER_MQH__
#define __MOMENTUMFILTER_MQH__

bool IsBullishMomentum(int rsiPeriod=14, double rsiThreshold=50.0)
{
    int handle = iRSI(_Symbol, _Period, rsiPeriod, PRICE_CLOSE);
    if (handle == INVALID_HANDLE) return false;

    double rsi[];
    ArraySetAsSeries(rsi, true);
    if (CopyBuffer(handle, 0, 0, 1, rsi) <= 0) {
        IndicatorRelease(handle);
        return false;
    }
    IndicatorRelease(handle);
    return rsi[0] > rsiThreshold;
}

bool IsBearishMomentum(int rsiPeriod=14, double rsiThreshold=50.0)
{
    int handle = iRSI(_Symbol, _Period, rsiPeriod, PRICE_CLOSE);
    if (handle == INVALID_HANDLE) return false;

    double rsi[];
    ArraySetAsSeries(rsi, true);
    if (CopyBuffer(handle, 0, 0, 1, rsi) <= 0) {
        IndicatorRelease(handle);
        return false;
    }
    IndicatorRelease(handle);
    return rsi[0] < rsiThreshold;
}

#endif