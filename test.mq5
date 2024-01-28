//+------------------------------------------------------------------+
//|                                                      ProjectName |
//|                                      Copyright 2020, CompanyName |
//|                                       http://www.companyname.net |
//+------------------------------------------------------------------+
#include <Trade/Trade.mqh>
#include <Trade/PositionInfo.mqh>
#include <Trade\DealInfo.mqh>

CDealInfo deal_info;
CTrade trade;
CPositionInfo posInfo;



input int    FastMAPeriod = 10;   // Período de la media móvil rápida
input int    SlowMAPeriod = 20;   // Período de la media móvil lenta

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnInit()
  {
   return(INIT_SUCCEEDED);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {

  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnTick()
  {
   double FastMA = iMA(_Symbol, PERIOD_CURRENT, FastMAPeriod, 0, MODE_SMA, PRICE_CLOSE);
   double SlowMA = iMA(_Symbol, PERIOD_CURRENT, SlowMAPeriod, 0, MODE_SMA, PRICE_CLOSE);

   double lotsize = 0.1;
   double price = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
   double stoploss = price - 2 * Point();
   double takeprofit = price + 2 * Point();

   if(FastMA > SlowMA && price > FastMA && price > SlowMA)
     {
      if(!PositionSelect(_Symbol))
        {

         trade.Buy(lotsize,_Symbol,price,stoploss,takeprofit);

        }
     }
   else
      if(FastMA < SlowMA && price < FastMA && price < SlowMA)
        {
         if(!PositionSelect(_Symbol))
           {
            trade.Sell(lotsize,_Symbol,price,stoploss,takeprofit);
           }
        }
  }
//+------------------------------------------------------------------+
