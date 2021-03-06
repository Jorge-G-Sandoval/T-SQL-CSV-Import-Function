-- Log Files Table
CREATE TABLE dbo.AVAL_ARQUIVOS_IMPORTADOS (
    ID int IDENTITY(1,1) PRIMARY KEY,
    NM_ARQUIVO_IMPORTADO VARCHAR(4000)
);

-- Drop function before create it again
DROP FUNCTION dbo.ImportarCSV;

-- Create the function
CREATE FUNCTION dbo.IMPORTARCSV 
	(@TP_EXTRACAO nvarchar(5),
	@NM_PATH_CSV nvarchar(4000))
RETURNS INT
AS
BEGIN
	DECLARE @NM_TABELA nvarchar(250) = '';
	DECLARE @NM_CSV nvarchar(4000) = '';
	DECLARE @TP_RETORNO int = 0;
	IF @TP_EXTRACAO = 'E1'  
		SET @NM_TABELA = 'dbo.AVAL_DADOS_OCORRENCIA';
	ELSE IF @TP_EXTRACAO = 'E2'  
		SET @NM_TABELA = 'dbo.AVAL_STATUS_DISPOSITIVOS';
	ELSE IF @TP_EXTRACAO = 'E3'  
		SET @NM_TABELA = 'dbo.AVAL_CLIENTES_INTERROMPIDOS';
	ELSE IF @TP_EXTRACAO = 'E4'  
		SET @NM_TABELA = 'dbo.AVAL_ACOES_EVENTOS';
	ELSE IF @TP_EXTRACAO = 'E5'  
		SET @NM_TABELA = 'dbo.AVAL_DURACAO_MEDIA';
	ELSE IF @TP_EXTRACAO = 'E6'  
		SET @NM_TABELA = 'dbo.AVAL_DESPACHO_DADOS';
	ELSE IF @TP_EXTRACAO = 'E7'  
		SET @NM_TABELA = 'dbo.AVAL_TEMPO_MEDIO_PREPARO';
	ELSE IF @TP_EXTRACAO = 'E8'  
		SET @NM_TABELA = 'dbo.AVAL_PLANOS_MANOBRA';
	ELSE IF @TP_EXTRACAO = 'E11'  
		SET @NM_TABELA = 'dbo.AVAL_NOTAS_ANEXO_III';
	ELSE IF @TP_EXTRACAO = 'E23'  
		SET @NM_TABELA = 'dbo.AVAL_STATUS_CHAVES';
	ELSE IF @TP_EXTRACAO = 'E24'  
		SET @NM_TABELA = 'dbo.AVAL_MEDICAO';
	ELSE 
		SET @TP_RETORNO = 4096;

	IF @TP_RETORNO = 0
	BEGIN
		SET @NM_CSV = (SELECT RIGHT(@NM_PATH_CSV, CHARINDEX('\', REVERSE(@NM_PATH_CSV)) - 1));
		IF EXISTS (SELECT NM_ARQUIVO_IMPORTADO FROM dbo.AVAL_ARQUIVOS_IMPORTADOS WHERE NM_ARQUIVO_IMPORTADO = @NM_CSV)
			SET @TP_RETORNO = 4099;
		ELSE
		BEGIN
			DECLARE @SQL_INSERT nvarchar(4000) = 'BULK INSERT ' + @NM_TABELA + ' FROM ''' + @NM_PATH_CSV + ''' WITH (FIRSTROW = 2, FIELDTERMINATOR ='';'', ROWTERMINATOR = ''\n'')';
			EXECUTE @TP_RETORNO = sp_executesql @SQL_INSERT;
			IF @TP_RETORNO = 0
			BEGIN		
				DECLARE @SQL_FILE_LOG nvarchar(4000) = 'INSERT INTO dbo.AVAL_ARQUIVOS_IMPORTADOS  (NM_ARQUIVO_IMPORTADO) VALUES (''' + @NM_CSV + ''')';
				EXECUTE sp_executesql @SQL_FILE_LOG;		
			END;
		END;
	END;
	RETURN @TP_RETORNO;
END;

-- Executing function
DECLARE @return_status int;  
EXEC @return_status = dbo.IMPORTARCSV 'E1','C:\Users\Rinzler\Downloads\test1E1.csv';  
SELECT 'Return Status' = @return_status;  
GO  