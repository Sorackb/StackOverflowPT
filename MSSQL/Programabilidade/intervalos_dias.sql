IF OBJECT_ID('intervalos_dias', 'TF') IS NULL
BEGIN
  EXEC('CREATE FUNCTION intervalos_dias() RETURNS @intervalos TABLE(t INT) AS BEGIN RETURN END');
END;
GO

ALTER FUNCTION intervalos_dias(@intervalo  INT = 1,
                               @inicio     DATE,
                               @fim        DATE)

RETURNS @intervalos TABLE(ordem INT,
                          data  DATE)

AS
BEGIN
  WITH intervalos AS (
    SELECT 1 AS ordem,
           @inicio AS dia
     UNION ALL
    SELECT ordem + 1,
           DATEADD(DAY, 1, i.dia)
      FROM intervalos i
     WHERE i.dia < @fim
  )
  INSERT INTO @intervalos(ordem, data)
  SELECT i.ordem,
         i.dia
    FROM intervalos i;
  
  RETURN;
END;
GO