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




