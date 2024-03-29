//+------------------------------------------------------------------+
//|                                                             MA   |
//|                                       Copyright 2024, Edwar-Sanz |
//|                                    https://github.com/Edwar-Sanz |
//+------------------------------------------------------------------+
#include <Trade/Trade.mqh>
#include <Trade/PositionInfo.mqh>
#include <Trade\DealInfo.mqh>

CDealInfo deal_info;
CTrade trade;
CPositionInfo posInfo;


//------inputs----------
input int    handle_FastMAPeriod = 10;
input int alpha = 1;
int    handle_SlowMAPeriod = handle_FastMAPeriod + alpha;
input int stop_lost = 100;
input int beta = 1;
int profit = stop_lost+beta;
//----timer variables---
datetime lastPrintTime = 0;
bool candleHasPassed = false;
//------ma varibles-----
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
   EventSetMillisecondTimer(1000); // verifica ontimer en milisegundos
   return(INIT_SUCCEEDED);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnTick()
  {

   if(isMarketOpen(_Symbol))
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


      if(candleHasPassed == true &&
         price > last_fastMA_val &&
         price > last_slowMA_val &&
         previous_fastMA_val < previous_slowMA_val &&
         last_fastMA_val > last_slowMA_val
        )
        {
         if(!PositionSelect(_Symbol))
           {

            trade.Buy(lotsize,_Symbol,price,price-stop_lost,price+profit);

           }
        }
      else
         if(candleHasPassed == true &&
            price < last_fastMA_val &&
            price < last_slowMA_val &&
            previous_fastMA_val > previous_slowMA_val &&
            last_fastMA_val < last_slowMA_val
           )
           {
            if(!PositionSelect(_Symbol))
              {
               trade.Sell(lotsize,_Symbol,price,price+stop_lost,price-profit);
              }
           }
     }

   candleHasPassed = false;

  }



//+------------------------------------------------------------------+
void OnTimer()
  {

   datetime currentCandleTime = iTime(_Symbol, _Period, 0);
   if(currentCandleTime != lastPrintTime)
     {

      //Candle has changed
      candleHasPassed = true;
      lastPrintTime = currentCandleTime;
     }
  }
//+------------------------------------------------------------------+
bool isMarketOpen(string symbol)
  {
   if(StringLen(symbol) > 1)
     {
      datetime begin = 0;
      datetime end = 0;
      datetime now = TimeTradeServer();
      uint session_index = 0;

      MqlDateTime today;
      TimeToStruct(now, today);
      if(SymbolInfoSessionTrade(symbol, (ENUM_DAY_OF_WEEK)today.day_of_week, session_index, begin, end) == true)
        {
         string snow = TimeToString(now, TIME_MINUTES | TIME_SECONDS);
         string sbegin = TimeToString(begin, TIME_MINUTES | TIME_SECONDS);
         string send = TimeToString(end - 1, TIME_MINUTES | TIME_SECONDS);

         now = StringToTime(snow);
         begin = StringToTime(sbegin);
         end = StringToTime(send);

         if(now >= begin && now <= end)
            return true;

         return false;
        }
      else
         return false;
     }
   Print("invalid symbol!!!!!");
   return false;
  }
//+------------------------------------------------------------------+
