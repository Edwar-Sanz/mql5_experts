void CloseAll(int order_totals, int position_totals)
{
   int i = position_totals;
   while (i >= 0)
   {
      ulong position = PositionGetTicket(i);
      trade.PositionClose(position);
      i--;
   }
   int j = order_totals;
   while (j >= 0)
   {
      ulong order_ticket = OrderGetTicket(j);
      if (OrderSelect(order_ticket) == true)
      {
         trade.OrderDelete(order_ticket);
      }
      j--;
   }
}