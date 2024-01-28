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

int handle_FastMAPeriod = 10;
int handle_SlowMAPeriod = 20;


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double   fastMA_Buffer[];
int      handle_FastMA;
double   slowMA_Buffer[];
int      handle_SlowMA;
int OnInit()
  {
   SetIndexBuffer(0, fastMA_Buffer,INDICATOR_DATA);
   SetIndexBuffer(0, slowMA_Buffer,INDICATOR_DATA);
   handle_FastMA = iMA(_Symbol, PERIOD_CURRENT, handle_FastMAPeriod, 0, MODE_SMA, PRICE_CLOSE);
   handle_SlowMA = iMA(_Symbol, PERIOD_CURRENT, handle_SlowMAPeriod, 0, MODE_SMA, PRICE_CLOSE);

   return(INIT_SUCCEEDED);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnTick()
  {

   CopyBuffer(handle_FastMA, 0, 1, 2, fastMA_Buffer);
   CopyBuffer(handle_SlowMA, 0, 1, 2, slowMA_Buffer);


   double lotsize = 0.1;
   double price = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
   double last_close = iClose(_Symbol, _Period, 1);


   double last_fastMA_val = NormalizeDouble(fastMA_Buffer[1], _Digits);
   double last_slowMA_val = NormalizeDouble(slowMA_Buffer[1], _Digits);
   double previous_fastMA_val = NormalizeDouble(fastMA_Buffer[0], _Digits);
   double previous_slowMA_val = NormalizeDouble(slowMA_Buffer[0], _Digits);


   if(price > last_fastMA_val &&
      price > last_slowMA_val &&
      previous_fastMA_val < previous_slowMA_val &&
      last_fastMA_val > last_slowMA_val
     )
     {
      if(!PositionSelect(_Symbol))
        {

         trade.Buy(lotsize,_Symbol,price,price-200,price+200);

        }
     }
   else
      if(price < last_fastMA_val &&
         price < last_slowMA_val &&
         previous_fastMA_val > previous_slowMA_val &&
         last_fastMA_val < last_slowMA_val
        )
        {
         if(!PositionSelect(_Symbol))
           {
            trade.Sell(lotsize,_Symbol,price,price+20,price-20);
           }
        }
  }
//+------------------------------------------------------------------+
