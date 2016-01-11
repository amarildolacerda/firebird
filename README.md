

Exemplos utilizando packages (3.0):

1) Para obter o Valor Futuro de uma operação
     n = 10
     i = 2%
     pv = 1000
     fv = ?
     
     select  PKG_FINANCE.fv(1000,2,10) FV from rdb$database    
     Resposta: 1218.994
     
2) Para obter o valor presente de um valor Futuro
   n = 10
   i = 2%
   fv = 1218,994
   pv = ?
   select  PKG_FINANCE.pv (1218.994,2,10) PV from rdb$database
   Resposta:  1000.00
   
3) Para obter o valor de uma prestação em um financiamento de parcelas uniformes
   pv = 1000
   n = 10
   i = 2%
   select  PKG_FINANCE.pmt (1000,2,10) pbm from rdb$database
   Resposta: 111.33


   
   
   
   
   
   
     
