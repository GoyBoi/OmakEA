//+------------------------------------------------------------------+
//|                    RiskManager.mqh                               |
//|     Dynamic risk engine for OmakStrategyEA                       |
//+------------------------------------------------------------------+
#ifndef __RISKMANAGER_MQH__
#define __RISKMANAGER_MQH__

input double MaxRiskPercent = 2.0;
input double MinLot = 0.01;
input double MaxLot = 50.0;

double CalculateLotSize(double stopLossPips) {
    if (stopLossPips <= 0) return MinLot;

    double balance = AccountInfoDouble(ACCOUNT_BALANCE);
    double riskCapital = balance * MaxRiskPercent / 100.0;

    double tickSize = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_SIZE);
    double tickValue = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_VALUE);
    double digits = (double)SymbolInfoInteger(_Symbol, SYMBOL_DIGITS);
    double pipValue = tickValue / tickSize * (digits == 3 || digits == 5 ? 10 : 1);

    double lot = riskCapital / (stopLossPips * pipValue);
    lot = NormalizeDouble(lot, 2);

    lot = MathMax(MinLot, MathMin(MaxLot, lot));
    return lot;
}

#endif

