
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

int OnInit()
  {

   if(!isMarketOpen(_Symbol))
     {
      Print("Close");
     }

   return(INIT_SUCCEEDED);
  }

