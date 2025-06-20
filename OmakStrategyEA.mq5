//+------------------------------------------------------------------+
//|                    OmakStrategyEA.mq5                            |
//| Main Expert Advisor: MAs, ATR, FVG, CRT, and Confluence logic   |
//+------------------------------------------------------------------+
#property strict

// Libraries
#include <MovingAverages.mqh>

// Omak modules
#include "Omak/MAAnalyzer.mqh"
#include "Omak/CRTBias.mqh"
#include "Omak/FVGDetector.mqh"
#include "Omak/OrderBlockDetector.mqh"
#include "Omak/ADXFilter.mqh"
#include "Omak/MomentumFilter.mqh"
#include "Omak/CandlePatternFilter.mqh"
#include "Omak/KillZoneFilter.mqh"
#include "Omak/RiskManager.mqh"
#include "Omak/Logger.mqh"
#include "Omak/ExecutionFilter.mqh"
#include "Omak/SignalScoreboard.mqh"
#include "Omak/SignalFilter.mqh"
#include "Omak/EntryLogic.mqh"
#include "Omak/TradeManager.mqh"
#include "Omak/Utils.mqh"
#include "Omak/TradeHealthMonitor.mqh"
#include "Omak/Dashboard.mqh"
#include "Omak/OmakStubs.mqh"

input double LotSize      = 0.01;
input int    Slippage     = 3;
input int    MagicNumber  = 123456;

int direction = 0;

int OnInit() {
    LogInfo("Omak Strategy EA Initialized.");
    InitDashboard();
    return INIT_SUCCEEDED;
}

void OnDeinit(const int reason) {
    LogInfo("Omak Strategy EA Deinitialized.");
}

void OnTick() {
    if (!CanExecuteTrade()) return;

    ResetSignalScore();

    // 1) 21-period MAs alignment
    if (Are21MAsAligned(true))
        AddScore("21MAs aligned bullish", 1);

    // 2) 200-period EMA trend confirmation
    if (Is200MAConfirmingTrend(true, PERIOD_H1))
        AddScore("200MA confirms bullish", 1);

    // 3) CRT bias
    int crtBias = GetCRTBias();
    if (crtBias == 2) {
        AddScore("CRT Strong Bullish", 2);
        direction = ORDER_TYPE_BUY;
    } else if (crtBias == -2) {
        AddScore("CRT Strong Bearish", 2);
        direction = ORDER_TYPE_SELL;
    } else {
        direction = 0;
    }

    // 4) FVG detection
    if (DetectValidFVG(direction == ORDER_TYPE_BUY))
        AddScore("Valid FVG detected", 2);

    // 5) Final signal strength check with filters
    if (!IsSignalStrongEnough() || direction == 0) return;

    // 6) Calculate entry, SL, TP
    double entryPrice = CalculateEntryPrice(direction);
    double sl         = CalculateStopLoss(entryPrice, direction);
    double tp         = CalculateTakeProfit(entryPrice, direction);

    // 7) Determine lot size
    double stopLossPips = MathAbs(entryPrice - sl) / PipFactor();
    double lots         = CalculateLotSize(stopLossPips);

    // 8) Open trade
    if (OpenTrade(direction == ORDER_TYPE_BUY, sl, tp, lots)) {
        RegisterEntryTime();
        LogTrade(entryPrice, sl, tp, direction);
    }

    // 9) Manage open positions
    ManageOpenTrades();
}
