//+------------------------------------------------------------------+
//|                                              CandlePatternFilter.mqh |
//|                        Custom Candle Pattern Filter Module        |
//+------------------------------------------------------------------+
#ifndef __CANDLEPATTERNFILTER_MQH__
#define __CANDLEPATTERNFILTER_MQH__

bool IsBullishEngulfing()
{
    double open1 = iOpen(_Symbol, _Period, 1);
    double close1 = iClose(_Symbol, _Period, 1);
    double open2 = iOpen(_Symbol, _Period, 2);
    double close2 = iClose(_Symbol, _Period, 2);

    return (close2 < open2 && close1 > open1 && close1 > open2 && open1 < close2);
}

bool IsBearishEngulfing()
{
    double open1 = iOpen(_Symbol, _Period, 1);
    double close1 = iClose(_Symbol, _Period, 1);
    double open2 = iOpen(_Symbol, _Period, 2);
    double close2 = iClose(_Symbol, _Period, 2);

    return (close2 > open2 && close1 < open1 && close1 < open2 && open1 > close2);
}

#endif // __CANDLEPATTERNFILTER_MQH__
