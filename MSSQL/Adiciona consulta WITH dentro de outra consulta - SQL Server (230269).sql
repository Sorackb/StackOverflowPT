/**
 * Utilizado na resposta para a pergunta "Adiciona consulta WITH dentro de outra consulta . SQL Server":
 * https://pt.stackoverflow.com/a/230279/59479
 */

BEGIN TRAN criacao

SET NOCOUNT ON;

CREATE TABLE solicitacao (
  solid             INT IDENTITY,
  soldatafechamento VARCHAR(10),
  proid             INT,
  solestagioid      INT,
  soltipid          INT
);

INSERT INTO solicitacao(soldatafechamento,
                        proid,
                        solestagioid,
                        soltipid)
VALUES('26.06.2017', 3, 110, NULL),
      ('26.06.2017', 4, 112, NULL),
      ('27.06.2017', 4, 110, NULL),
      ('27.06.2017', 1, 110, NULL),
      ('27.06.2017', 4, 110, NULL),
      ('27.06.2017', 4, 110, NULL),
      ('27.06.2017', 4, 110, NULL),
      ('27.06.2017', 4, NULL, 35),
      ('27.06.2017', 4, NULL, 35),
      ('28.06.2017', 4, NULL, 35),
      ('28.06.2017', 4, NULL, 35),
      ('28.06.2017', 4, NULL, 35),
      ('28.06.2017', 4, NULL, 35),
      ('28.06.2017', 4, NULL, 35),
      ('29.06.2017', 4, 110, NULL),
      ('29.06.2017', 4, 110, NULL),
      ('29.06.2017', 4, NULL, 35),
      ('29.06.2017', 4, NULL, 35),
      ('29.06.2017', 4, NULL, 35),
      ('29.06.2017', 4, NULL, 35),
      ('29.06.2017', 4, 110, NULL),
      ('29.06.2017', 4, 110, NULL),
      ('29.06.2017', 4, 110, NULL);

BEGIN TRY
   WITH dias AS(
    SELECT CAST('2017.06.26' AS DATE) AS dia
    UNION ALL
    SELECT DATEADD(DAY, 1, d.dia)
      FROM dias d
     WHERE d.dia < '2017.06.30'
  )
  SELECT CONVERT(VARCHAR, d.dia, 103) AS data_cancelado,
         COUNT(CASE WHEN s.soltipid = 35 THEN 1 ELSE NULL END) AS abertos,
         COUNT(CASE WHEN s.solestagioid = 110 THEN 1 ELSE NULL END) AS cancelados
    FROM dias d
         LEFT JOIN solicitacao s ON CONVERT(DATE, s.soldatafechamento, 103) = d.dia
                                AND s.proid = 4
  GROUP BY d.dia
  OPTION (MAXRECURSION 0);
END TRY
BEGIN CATCH
END CATCH

ROLLBACK TRAN criacao;