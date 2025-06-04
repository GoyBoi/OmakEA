//+------------------------------------------------------------------+
//|                       Dashboard.mqh                              |
//| Basic MT5 panel for manual control                               |
//+------------------------------------------------------------------+
#ifndef __DASHBOARD_MQH__
#define __DASHBOARD_MQH__

input bool AllowManualOverride = true;

// Simple label-based dashboard
void InitDashboard() {
    if (!AllowManualOverride) return;
    if (!ObjectCreate(0, "OmakDashboard", OBJ_LABEL, 0, 0, 0)) return;

    ObjectSetInteger(0, "OmakDashboard", OBJPROP_CORNER, CORNER_RIGHT_UPPER);
    ObjectSetInteger(0, "OmakDashboard", OBJPROP_XDISTANCE, 10);
    ObjectSetInteger(0, "OmakDashboard", OBJPROP_YDISTANCE, 10);
    ObjectSetInteger(0, "OmakDashboard", OBJPROP_COLOR, clrWhite);
    ObjectSetString(0, "OmakDashboard", OBJPROP_TEXT, "OMAK EA Dashboard\n- EA Status: ACTIVE\n- Manual Override Allowed");
}

#endif
