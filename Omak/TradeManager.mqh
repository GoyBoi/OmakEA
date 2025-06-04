//+------------------------------------------------------------------+
//|                     TradeManager.mqh                             |
//|             Trade execution and position management              |
//+------------------------------------------------------------------+
#ifndef __TRADEMANAGER_MQH__
#define __TRADEMANAGER_MQH__

datetime lastEntryTime;

bool OpenTrade(bool buy, double sl, double tp, double lots) {
    MqlTradeRequest req;
    MqlTradeResult res;
    ZeroMemory(req);
    ZeroMemory(res);

    req.action = TRADE_ACTION_DEAL;
    req.symbol = _Symbol;
    req.volume = lots;
    req.type = buy ? ORDER_TYPE_BUY : ORDER_TYPE_SELL;
    req.price = SymbolInfoDouble(_Symbol, buy ? SYMBOL_ASK : SYMBOL_BID);
    req.sl = sl;
    req.tp = tp;
    req.deviation = 10;
    req.magic = MagicNumber;
    req.type_filling = ORDER_FILLING_IOC;

    if (!OrderSend(req, res)) {
        Print("[OMAK][TRADE][ERROR] OrderSend failed. Retcode: ", res.retcode);
        return false;
    }

    if (res.retcode == TRADE_RETCODE_DONE) {
        Print("✅ Trade opened: ", buy ? "BUY" : "SELL", " @ ", req.price);
        RecordTradeExecuted();
        TradeHealthLog(true);
        return true;
    }

    Print("[OMAK][TRADE][WARN] Unexpected retcode: ", res.retcode);
    TradeHealthLog(false);
    return false;
}

void RegisterEntryTime() {
    lastEntryTime = TimeCurrent();
}

void ManageOpenTrades() {
    for (int i = PositionsTotal() - 1; i >= 0; i--) {
        ulong posTicket = PositionGetTicket(i);
        if (!PositionSelectByTicket(posTicket)) continue;

        double price = SymbolInfoDouble(_Symbol, PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY ? SYMBOL_BID : SYMBOL_ASK);
        int atrHandle = iATR(_Symbol, Period(), 14);
        double atrValue[];
        ArraySetAsSeries(atrValue, true);
        CopyBuffer(atrHandle, 0, 0, 1, atrValue);
        IndicatorRelease(atrHandle);

        double trailDistance = atrValue[0] * 1.5;
        double currentSL = (double)PositionGetDouble(POSITION_SL);
        double currentTP = (double)PositionGetDouble(POSITION_TP);

        double newSL;
        if (PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY) {
            newSL = price - trailDistance;
            if (newSL > currentSL) {
                ModifyPosition(posTicket, newSL, currentTP);
            }
        } else {
            newSL = price + trailDistance;
            if (newSL < currentSL) {
                ModifyPosition(posTicket, newSL, currentTP);
            }
        }
    }
}

void ModifyPosition(ulong ticket, double newSL, double newTP) {
    MqlTradeRequest req;
    MqlTradeResult res;
    ZeroMemory(req);
    ZeroMemory(res);

    req.action = TRADE_ACTION_SLTP;
    req.symbol = _Symbol;
    req.sl = newSL;
    req.tp = newTP;
    req.position = ticket;

    if (!OrderSend(req, res)) {
        Print("[OMAK][TRAIL] Modify SL/TP failed. Retcode: ", res.retcode);
    } else {
        Print("[OMAK][TRAIL] SL/TP updated successfully.");
    }
}

#endif

