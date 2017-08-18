/**
 * Utilizado na resposta para a pergunta "Agrupando por dia e pelo período da data":
 * https://pt.stackoverflow.com/a/230182/59479
 */

BEGIN TRAN criacao

SET NOCOUNT ON;

CREATE TABLE solicitacao (
  solid             INT IDENTITY,
  soldatafechamento VARCHAR(10),
  proid             INT,
  solestagioid      INT
);

INSERT INTO solicitacao(soldatafechamento,
                        proid,
                        solestagioid)
VALUES('26.06.2017', 3, 110),
      ('26.06.2017', 4, 112),
      ('27.06.2017', 4, 110),
      ('27.06.2017', 1, 110),
      ('27.06.2017', 4, 110),
      ('27.06.2017', 4, 110),
      ('27.06.2017', 4, 110),
      ('29.06.2017', 4, 110),
      ('29.06.2017', 4, 110),
      ('29.06.2017', 4, 110),
      ('29.06.2017', 4, 110),
      ('29.06.2017', 4, 110);

BEGIN TRY
  WITH dias AS(
    SELECT CAST('2017.06.26' AS DATE) AS dia
    UNION ALL
    SELECT DATEADD(DAY, 1, d.dia)
      FROM dias d
     WHERE d.dia < '2017.06.30'
  )
  SELECT CONVERT(VARCHAR, d.dia, 103) AS data_cancelado,
         COUNT(s.solid) AS cancelados
    FROM dias d
         LEFT JOIN solicitacao s ON CONVERT(DATE, s.soldatafechamento, 103) = d.dia
                                AND s.proid = 4
                                AND s.solestagioid = 110
   GROUP BY d.dia
  OPTION (MAXRECURSION 0);
END TRY
BEGIN CATCH
END CATCH

ROLLBACK TRAN criacao;