
datetime lastPrintTime = 0;

int OnInit()
{
   EventSetMillisecondTimer(1000); // Verificar cada segundo
   return(INIT_SUCCEEDED);
}

void OnTimer()
{

   datetime currentCandleTime = iTime(_Symbol, _Period, 0);
   if (currentCandleTime != lastPrintTime)
   {
      double openPrice = iOpen(_Symbol, _Period, 0);
      Print("Candle has changed, Open: ", openPrice);
      lastPrintTime = currentCandleTime;
   }
}

