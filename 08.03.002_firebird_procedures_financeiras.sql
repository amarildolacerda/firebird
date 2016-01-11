/*
  Auth:  Amarildo Lacerda - amarildo.lacerda@storeware.com.br
  Subj:  Firebird procedures for finances
  Date:  03/01/2016
*/



--------------------------------------------------------------------
-- procedures to Firebird 2.5
--------------------------------------------------------------------

create or alter  exception test_Error 'Error: ';


SET TERM ^ ;

CREATE OR ALTER PROCEDURE FIN_COEF(
    P_I DOUBLE PRECISION,
    P_N DOUBLE PRECISION)
RETURNS (
    RESULT DOUBLE PRECISION)
AS
-- Calcular o coeficiente de financiamento para obter valor da parcela
BEGIN
  result = (p_i/100)   /(1-  (1/power(1+ (p_i/100),p_n)));
  suspend;
END^


CREATE OR ALTER PROCEDURE FIN_I (
    P_VP DOUBLE PRECISION,
    P_VF DOUBLE PRECISION,
    P_N DOUBLE PRECISION)
RETURNS (
    RESULT DOUBLE PRECISION)
AS
--Calcula a taxa
BEGIN
  result = (power(p_vf/p_vp,1/p_n)-1)*100;
  suspend;
END^


CREATE OR ALTER PROCEDURE FIN_N (
    P_VP DOUBLE PRECISION,
    P_VF DOUBLE PRECISION,
    P_I DOUBLE PRECISION)
RETURNS (
    RESULT DOUBLE PRECISION)
AS
-- Calcula o periodo
BEGIN
  result =   log( 1 + (p_i/100),10) / log(p_vf/p_vp,10) ;
  suspend;
END^


CREATE OR ALTER PROCEDURE FIN_N_from_PMT (
    P_VP DOUBLE PRECISION,
    P_PMT DOUBLE PRECISION,
    P_I DOUBLE PRECISION)
RETURNS (
    RESULT DOUBLE PRECISION)
AS
-- Calcula o periodo de uma serie de prestacoes constantes
BEGIN
  result =    log(1 + (P_I/100) , 10)  / log( P_PMT/(P_PMT - (P_VP*(P_I/100)))  , 10 )  ;
  suspend;
END^


CREATE OR ALTER PROCEDURE FIN_PMT (
    P_VP DOUBLE PRECISION,
    P_I DOUBLE PRECISION,
    P_N DOUBLE PRECISION)
RETURNS (
    RESULT DOUBLE PRECISION)
AS
-- Calcula o valor da prestacao em um financiamento uniforme
BEGIN
   result = ( p_vp * (p_i/100)  ) /    (1-(1/power(1 + (p_i/100),p_n)));
   suspend;
END^


CREATE OR ALTER PROCEDURE FIN_I_EQ (
    P_I DOUBLE PRECISION,
    P_N DOUBLE PRECISION,
    P_N_BASE DOUBLE PRECISION)
RETURNS (
    RESULT DOUBLE PRECISION)
AS
-- Calcula a taxa equivalente
BEGIN
  result = (power(1+(p_i/100),p_n/p_n_base)-1) * 100;
  suspend;
END^


CREATE OR ALTER PROCEDURE FIN_FV (
    P_VP DOUBLE PRECISION,
    P_I DOUBLE PRECISION,
    P_N DOUBLE PRECISION)
RETURNS (
    RESULT DOUBLE PRECISION)
AS
-- Calcula o valor futuro
BEGIN
   result = p_vp * power(1+(p_I/100),p_n);
   suspend;
END^


CREATE OR ALTER PROCEDURE FIN_PV (
    P_VF DOUBLE PRECISION,
    P_I DOUBLE PRECISION,
    P_N DOUBLE PRECISION)
RETURNS (
    RESULT DOUBLE PRECISION)
AS
-- Calula o valor presente
BEGIN
  result =  p_VF / (  (power(1+(p_i/100), (:p_N) )) );
  suspend;
END^


CREATE OR ALTER PROCEDURE FIN_PV_from_PMT (
    P_PMT DOUBLE PRECISION,
    P_I DOUBLE PRECISION,
    P_N DOUBLE PRECISION)
RETURNS (
    RESULT DOUBLE PRECISION)
AS
-- Calcula o valor presente em um finaneiamento de prestacoes constantes/uniformes
BEGIN
  result =(p_pmt / (p_i/100)    )* (1-(1/power(1+(p_i/100),p_n)));
  suspend;
END^

SET TERM ; ^






----------------------------------------------------------------------
---- Firebird 3.0  Package
----------------------------------------------------------------------



SET TERM ^ ;

CREATE  PACKAGE PKG_FINANCE
AS
begin
       function n( vp double precision, vf double precision, i double precision) returns double precision;
       function pv(vf double precision,  i double precision, n double precision) returns double precision;
       function fv(pv double precision,  i double precision, n double precision) returns double precision;
       function i(pv double precision,fv double precision,n double precision  ) returns double precision;
       function i_eq( i double precision, n double precision, base double precision) returns double precision;
       function coef( i double precision, n double precision) returns double precision;
       function pmt( pv double precision, i double precision, n double precision) returns double precision;
       function n_from_pmt(pv double precision,pmt double precision,i double precision) returns double precision;
       function pv_from_pmt(pmt double precision,i double precision,n double precision) returns double precision;

end^

RECREATE PACKAGE BODY PKG_FINANCE
AS
begin
       function  n( vp double precision, vf double precision, i double precision) returns double precision
       as
       declare variable r double precision;
       begin
          select result from fin_n(:vp,:vf,:i)
          into :r;
          return r;
       end

       function pv(vf double precision,  i double precision, n double precision) returns double precision
       as
       declare variable r double precision;
       begin
          select result from fin_pv(:vf,:i,:n)
          into :r;
          return r;
       end

       function fv(pv double precision,  i double precision, n double precision) returns double precision
       as
       declare variable r double precision;
       begin
          select result from fin_fv(:pv,:i,:n)
          into :r;
          return r;
       end

       function i(pv double precision,fv double precision,n double precision  ) returns double precision
       as
       declare variable r double precision;
       begin
          select result from fin_i(:pv,:fv,:n)
          into :r;
          return r;
       end

       function i_eq( i double precision, n double precision, base double precision) returns double precision
       as
       declare variable r double precision;
       begin
          select result from fin_i_eq(:i,:n,:base)
          into :r;
          return r;
       end

       function coef( i double precision, n double precision) returns double precision
       as
       declare variable r double precision;
       begin
          select result from fin_coef(:i,:n)
          into :r;
          return r;
       end

       function  pmt( pv double precision, i double precision, n double precision) returns double precision
       as
       declare variable r double precision;
       begin
         select result from fin_pmt(:pv,:i,:n)
         into :r;
         return r;
       end

       function n_from_pmt(pv double precision,pmt double precision,i double precision) returns double precision
       as
       declare variable r double precision;
       begin
         select result from fin_n_from_pmt (:pv,:pmt,:i)
         into :r;
         return r;
       end

       function pv_from_pmt(pmt double precision,i double precision,n double precision) returns double precision
       as
       declare variable r double precision;
       begin
         select result from fin_pv_from_pmt(:pmt,:i,:n)
         into :r;
         return r;
       end

end^

SET TERM ; ^

GRANT EXECUTE ON PACKAGE PKG_FINANCE TO wba;
GRANT EXECUTE ON PACKAGE PKG_FINANCE TO sysdba;

-----------------------------------------------------------------
-- PKG_Finance  Tests
-----------------------------------------------------------------
SET TERM ^ ;

execute block
as
declare variable r double precision;
declare variable f double precision ;
begin

   r = pkg_finance.fv(100,10,1);
   f = 110;
   if (round(r,2)<>round(f,2)) then
      exception test_Error 'Calc FV ('||f||'): '||:r;

   r = pkg_finance.pv(110,10,1);
   f = 100;
   if (round(r,2)<>round(f,2)) then
      exception test_Error 'Calc PV ('||f||'): '||:r;

   r = pkg_finance.i(100,110,1);
   f = 10;
   if (round(r,2)<>round(f,2)) then
      exception test_Error 'Calc I ('||f||'): '||:r;

   r = pkg_finance.n(100,110,10);
   f = 1;
   if (round(r,2)<>round(f,2)) then
      exception test_Error 'Calc N ('||f||'): '||:r;

   r = pkg_finance.i_eq(21,1,2);
   f = 10;
   if (round(r,2)<>round(f,2)) then
      exception test_Error 'Calc I_EQ ('||f||'): '||:r;

   r = pkg_finance.pmt(10000,1,24);
   f = 470.73;
   if (round(r,2)<>round(f,2)) then
      exception test_Error 'Calc PMT ('||f||'): '||:r;


   r = pkg_finance.n_from_pmt(10000,470.73,1);
   f = 24;
   if (round(r,2)<>round(f,2)) then
      exception test_Error 'Calc N From PMT ('||f||'): '||:r;


   r = pkg_finance.pv_from_pmt(470.7347,1,24);
   f = 10000;
   if (round(r,2)<>round(f,2)) then
      exception test_Error 'Calc PV From PMT ('||f||'): '||:r;

   r = pkg_finance.coef(1,24);
   f = 0.047073;
   if (round(r,6)<>round(f,6)) then
      exception test_Error 'Calc COEF ('||f||'): '||:r;

   r = 10000 / f;
   f = 470.73;
   r = pkg_finance.coef(1,24);
   f = 0.047073;
   if (round(r,2)<>round(f,2)) then
      exception test_Error 'Calc PMT by COEF ('||f||'): '||:r;


end^

SET TERM ; ^


