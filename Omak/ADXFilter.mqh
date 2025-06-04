//+------------------------------------------------------------------+
//|                                                    ADXFilter.mqh |
//|                        Custom ADX Filter Module                  |
//+------------------------------------------------------------------+
#ifndef __ADXFILTER_MQH__
#define __ADXFILTER_MQH__

bool IsStrongTrend(int period=14, double threshold=25.0)
{
    int handle = iADX(_Symbol, _Period, period);
    if(handle == INVALID_HANDLE)
        return false;

    double adxBuffer[];
    ArraySetAsSeries(adxBuffer, true);
    if(CopyBuffer(handle, 0, 0, 1, adxBuffer) <= 0)
    {
        IndicatorRelease(handle);
        return false;
    }

    IndicatorRelease(handle);
    double adx = adxBuffer[0];
    return adx >= threshold;
}

#endif

