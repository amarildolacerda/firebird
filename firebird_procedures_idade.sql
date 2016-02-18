

/*
  Amarildo Lacerda
  Calcular idade mostrando  Anos Meses Dias
*/

SET TERM ^ ;

CREATE OR ALTER PROCEDURE IDADE_MESES (
    p_data_ini date,
    p_data_fim date)
returns (
    result varchar(16))
as
declare variable l_val integer;
begin
  result ='';

  l_val = datediff(year from :p_data_ini to :p_data_fim   );
  if (l_val>0) then
  begin
     result = result || l_val||'a ';
     p_data_fim = addyear(:p_data_fim,-:l_val);
  end


  l_val = datediff(month from :p_data_ini to :p_data_fim   );
  if (l_val>0) then
  begin
     result = result || l_val||'m ';
     p_data_fim = addmonth(:p_data_fim,-:l_val);
  end

  l_val = datediff(day from :p_data_ini to :p_data_fim);
  if (l_val>0) then
  begin
     result = result || l_val||'d ';
  end

  suspend;
end^

SET TERM ; ^

/* Existing privileges on this procedure */

GRANT EXECUTE ON PROCEDURE IDADE_MESES TO SYSDBA;


/*
    Calcular idade mostrando  Anos Semanas Dias
*/


SET TERM ^ ;

CREATE OR ALTER PROCEDURE IDADE_SEMANAS (
    p_data_ini date,
    p_data_fim date)
returns (
    result varchar(16))
as
declare variable l_val integer;
begin
  result ='';

  l_val = datediff(year from :p_data_ini to :p_data_fim   );
  if (l_val>0) then
  begin
     result = result || l_val||'a ';
     p_data_fim = addyear(:p_data_fim,-:l_val);
  end


  l_val = datediff(week from :p_data_ini to :p_data_fim   );
  if (l_val>0) then
  begin
     result = result || l_val||'s ';
     p_data_fim = addweek(:p_data_fim,-:l_val);
  end

  l_val = datediff(day from :p_data_ini to :p_data_fim);
  if (l_val>0) then
  begin
     result = result || l_val||'d ';
  end

  suspend;
end^

SET TERM ; ^

/* Existing privileges on this procedure */

GRANT EXECUTE ON PROCEDURE IDADE_SEMANAS TO SYSDBA;






/*
   Teste
*/

execute block
as
declare variable retorno varchar(16);
begin

    select result from idade_meses('01/01/2010', '02/02/2016')
    into :retorno;
    if (retorno<>'6a 1m 1d') then
       exception erro 'Falhou calculo de meses';

    select result from idade_semanas('01/01/2010', '02/02/2016')
    into :retorno;
    if (retorno<>'6a 4s 4d') then
       exception erro 'Falhou calculo de semanas';

end
