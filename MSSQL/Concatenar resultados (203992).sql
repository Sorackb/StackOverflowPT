/**
 * Utilizado na resposta para a pergunta "Concatenar resultados":
 * https://pt.stackoverflow.com/a/203993/59479
 */

BEGIN TRAN criacao

SET NOCOUNT ON;

CREATE TABLE cliente (
  nome VARCHAR(100) NOT NULL
);

INSERT INTO cliente(nome)
VALUES('José'),
      ('Luis'),
      ('Antônio');

BEGIN TRY
  DECLARE @texto varchar(max);

  -- FORMA 1
  PRINT 'FORMA 1:';

  SET @texto = null;

  SELECT @texto = ISNULL(@texto + ', ', '') + cli.nome
    FROM cliente cli;

  PRINT @texto;

  -- FORMA 2
  PRINT '';
  PRINT 'FORMA 2:';

  SET @texto = null;

  SELECT DISTINCT @texto = RTRIM(LTRIM(SUBSTRING((SELECT ', ' + cli.nome AS [text()]
                                                    FROM cliente cli
                                                     FOR XML PATH ('')), 2, 8000)))
  FROM cliente cli2

  print @texto;
END TRY
BEGIN CATCH
END CATCH

ROLLBACK TRAN criacao;