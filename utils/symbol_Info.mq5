//+------------------------------------------------------------------+
//|                                                                  |
//|                                                       Edwar-Sanz |
//|                                                                  |
//+------------------------------------------------------------------+

int OnInit()
  {


   double point = SymbolInfoDouble(_Symbol, SYMBOL_POINT);
   double current_ask = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
   double current_bid = SymbolInfoDouble(_Symbol, SYMBOL_BID);


   Print("Current Info");
   Print("point: ", point,
         "  current_ask: ", current_ask,
         "  current_bid: ", current_bid);
   Print("");

// ---- Candle info -----
// * current candle shift 0: (_Symbol, _Period, 0)
   datetime time_candle = iTime(_Symbol, _Period, 1);
   double last_close = iClose(_Symbol, _Period, 1);
   double last_low = iLow(_Symbol, _Period, 1);
   double last_high = iHigh(_Symbol, _Period, 1);


   Print("Candle info");
   Print("time_candle: ", time_candle,
         "  last_close: ", last_close,
         "  last_low: ", last_low,
         "  last_high: ", last_high);


   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
