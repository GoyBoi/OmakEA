//+------------------------------------------------------------------+
//|                                               KillZoneFilter.mqh |
//|                        Custom Kill Zone Filter Module            |
//+------------------------------------------------------------------+
#ifndef __KILLZONEFILTER_MQH__
#define __KILLZONEFILTER_MQH__

#include <StdFunctions.mqh>  // Required for TimeToStruct

bool IsWithinKillZone()
{
    datetime currentTime = TimeCurrent();
    MqlDateTime timeStruct;
    TimeToStruct(currentTime, timeStruct);

    int hour = timeStruct.hour;

    // Define kill zone: 7:00 to 10:00 and 13:00 to 15:00
    if ((hour >= 7 && hour < 10) || (hour >= 13 && hour < 15))
        return true;

    return false;
}

#endif