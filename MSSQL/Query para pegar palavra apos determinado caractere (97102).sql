/**
 * Utilizado na resposta para a pergunta "Query para pegar palavra apos determinado caractere":
 * https://pt.stackoverflow.com/a/230271/59479
 */

BEGIN TRAN criacao

SET NOCOUNT ON;

CREATE TABLE solicitacao (
  solcaminho VARCHAR(100)
);

INSERT INTO solicitacao(solcaminho)
VALUES('Acesso ao sistema'),
      ('Faturamento >> Cupom Fiscal >> PBM >> Farm�cia Popular'),
      ('Faturamento >> Cupom Fiscal'),
      ('Faturamento >> Cupom Fiscal >> PBM >> Novartis'),
      ('Configura��o ECF'),
      ('Faturamento >> Venda NFC-e'),
      ('Configura��o >> Configura��o de Integra��es'),
      ('Faturamento >> Cupom Fiscal >> PBM >> Vidalink'),
      ('Faturamento >> Cancelamentos'),
      ('Softpharma');

BEGIN TRY
  SELECT (SELECT TOP(1) sep.item
            FROM separacao(s.solcaminho, ' >> ') sep
           ORDER BY sep.sequencia DESC) AS solcaminho
    FROM solicitacao s;
END TRY
BEGIN CATCH
END CATCH

ROLLBACK TRAN criacao;