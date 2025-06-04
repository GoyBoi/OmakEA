//+------------------------------------------------------------------+
//|                                               MomentumFilter.mqh |
//|                        Custom Momentum Filter Module             |
//+------------------------------------------------------------------+
#ifndef __MOMENTUMFILTER_MQH__
#define __MOMENTUMFILTER_MQH__

bool IsBullishMomentum(int rsiPeriod=14, double rsiThreshold=50.0)
{
    double rsi = iRSI(_Symbol, _Period, rsiPeriod, PRICE_CLOSE, 0);
    return rsi > rsiThreshold;
}

bool IsBearishMomentum(int rsiPeriod=14, double rsiThreshold=50.0)
{
    double rsi = iRSI(_Symbol, _Period, rsiPeriod, PRICE_CLOSE, 0);
    return rsi < rsiThreshold;
}

#endif
