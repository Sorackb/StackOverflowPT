/**
 * Utilizado na resposta para a pergunta "Como atualizar todos os registros de todas as tabelas que tenham FK de uma tabela":
 * https://pt.stackoverflow.com/a/232824/59479
 */

CREATE TABLE contrato (id    INT NOT NULL IDENTITY,
                       nome  VARCHAR(150),
                       ativo BIT
                       PRIMARY KEY(id));

CREATE TABLE dbo.itemcontrato (id         INT NOT NULL IDENTITY,
                               contratoid INT,
                               nome       VARCHAR(150),
                               ativo      BIT
                               PRIMARY KEY(id));

ALTER TABLE dbo.itemcontrato ADD FOREIGN KEY(contratoid) REFERENCES dbo.contrato(id);
GO

IF OBJECT_ID('tgr_itemcontrato_ai', 'TR') IS NULL
BEGIN
  EXEC('CREATE TRIGGER tgr_itemcontrato_ai ON ItemContrato FOR INSERT AS BEGIN SELECT 1 END');
END;
GO

ALTER TRIGGER tgr_itemcontrato_ai
ON ItemContrato
FOR INSERT
AS
BEGIN
  SET NOCOUNT ON;

  UPDATE ic
     SET ic.ativo = c.ativo
    FROM ItemContrato ic
         INNER JOIN inserted i ON i.id = ic.id
         INNER JOIN Contrato c ON c.id = ic.contratoid;
END;
GO

IF OBJECT_ID('tgr_contrato_aiu', 'TR') IS NULL
BEGIN
  EXEC('CREATE TRIGGER tgr_contrato_aiu ON Contrato FOR INSERT, UPDATE AS BEGIN SELECT 1 END');
END;
GO

ALTER TRIGGER tgr_contrato_aiu
ON Contrato
FOR INSERT, UPDATE
AS
BEGIN
  DECLARE @nome_tabela VARCHAR(100),
          @query       VARCHAR(MAX);

  SET NOCOUNT ON;

  -- Pega o nome da tabela para a qual a TRIGGER é executada
  SELECT @nome_tabela = OBJECT_NAME(o.parent_object_id)
    FROM sys.objects o WITH(NOLOCK)
   WHERE o.name = OBJECT_NAME(@@PROCID);

  SELECT @query = isnull(@query + CHAR(10), '') + 'UPDATE f' + CHAR(10) +
                                                  '   SET f.ativo = ' +  + CAST(i.ativo AS VARCHAR) + CHAR(10) +
                                                  '  FROM ' + tf.name + ' f' + CHAR(10) +
                                                  ' WHERE f.' + c.name + ' = ' + CAST(i.id AS VARCHAR) + ';' + CHAR(10)
    FROM sys.tables t WITH(NOLOCK)
         INNER JOIN sys.foreign_keys fk WITH(NOLOCK) ON fk.referenced_object_id = t.object_id
         INNER JOIN sys.tables tf WITH(NOLOCK) ON tf.object_id = fk.parent_object_id
         INNER JOIN sys.foreign_key_columns fkc WITH(NOLOCK) ON fkc.constraint_object_id = fk.object_id
         INNER JOIN sys.columns c WITH(NOLOCK) ON c.object_id = fkc.parent_object_id
                                              AND c.column_id = fkc.parent_column_id
         CROSS JOIN inserted i
         INNER JOIN deleted d ON d.id = i.id
   WHERE t.name = @nome_tabela
     -- Somente se mudar algo na coluna "Ativo"
     AND i.ativo <> d.ativo
     -- Garante que exista a coluna "Ativo" na tabela filha
     AND EXISTS(SELECT 1
                  FROM sys.columns cf WITH(NOLOCK)
                 WHERE cf.name = 'ATIVO'
                   AND cf.object_id = fkc.parent_object_id);

  IF @query IS NOT NULL
  BEGIN
    PRINT @query;
    EXEC(@query);
  END;
END;
GO

SET NOCOUNT ON;

INSERT Contrato VALUES('X', 1),
                      ('Y', 1),
                      ('Z', 0);

INSERT ItemContrato VALUES(1, 'A', NULL),
                          (1, 'B', NULL),
                          (1, 'C', NULL),
                          (2, 'D', NULL),
                          (2, 'E', NULL),
                          (2, 'F', NULL),
                          (2, 'G', NULL),
                          (3, 'H', NULL),
                          (3, 'I', NULL),
                          (3, 'J', NULL);

-- Antes da atualização
SELECT c.*
  FROM Contrato c;

SELECT ic.*
  FROM ItemContrato ic;

-- Atualização dos contratos "X" e "Z"
UPDATE c
   SET c.ativo = 0
  FROM Contrato c
 WHERE c.nome = 'X';

UPDATE c
   SET c.ativo = 1
  FROM Contrato c
 WHERE c.nome = 'Z';

-- Após a atualização
SELECT c.*
  FROM Contrato c;

SELECT ic.*
  FROM ItemContrato ic;

-- Busca direto da tabela de origem
SELECT ic.id,
       ic.contratoid,
       ic.nome,
       c.ativo
  FROM ItemContrato ic WITH(NOLOCK)
       INNER JOIN Contrato c WITH(NOLOCK) ON c.id = ic.contratoid;