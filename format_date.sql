/*
    Função FORMAT_DATE

    Como usar:
    Entrada: SELECT FORMAT_DATE(seu_campo, 'dd mm aaaa', '/', 'hh mm', ':', 1) FROM sua_tabela;
    Retorno: '06/08/2024 10:00'

    Primeiro valor: Data que deseja formatar - formato 'aaaa-mm-dd hh:mm:ss';
    Segundo valor: Formato da data, seguindo o padrão da tabela;
    Terceiro valor: Separador da data, ente o dia, mês e ano;
    Quarto valor: Formato da hora, seguindo o padrão da tabela;
    Quinto valor: Separador da hora, ente a hora, minuto e segundo;
    Sexto valor: Define se a data aparece antes ou depois da hora.

    **Caso não queira usar data ou hora, insira NULL no formato.**

    |SIGNIFICADO DAS ABREVIAÇÕES DE DATA|
    |ABREVIACAO |REPRESENTA             |
    |-----------+-----------------------+
    |dd         |dia                    |
    |mm         |mês                    |
    |aaaa       |ano (formato 4 digitos)|
    |aa         |ano (formato 2 digitos)|

    |SIGNIFICADO DAS ABREVIAÇÕES DE HORA|
    |ABREVIACAO |REPRESENTA             |
    |-----------+-----------------------+
    |hh         |horas                  |
    |mm         |minutos                |
    |ss         |segundos               |
*/

CREATE OR ALTER FUNCTION FORMAT_DATE (
    VALOR VARCHAR(24),
    ORDENACAO_DATA VARCHAR(10), 
    SEPARADOR_DATA VARCHAR(1),
    ORDENACAO_HORA VARCHAR(10), 
    SEPARADOR_HORA VARCHAR(1),
    POSICAO_DATA INT
) 
RETURNS VARCHAR(25)
AS
DECLARE VARIABLE DIA VARCHAR(2);
DECLARE VARIABLE MES VARCHAR(2);
DECLARE VARIABLE ANO VARCHAR(4);
DECLARE VARIABLE HORA VARCHAR(2);
DECLARE VARIABLE MINU VARCHAR(2);
DECLARE VARIABLE SEG VARCHAR(2);
DECLARE VARIABLE DATA_FORMAT VARCHAR(25);
DECLARE VARIABLE HORA_FORMAT VARCHAR(25);
BEGIN
    DIA = '00';
    MES = '00';
    ANO = '0000';
    HORA = '00';
    MINU = '00';
    SEG = '00';

    IF (VALOR IS NOT NULL AND CHAR_LENGTH(VALOR) >= 10) THEN
    BEGIN
        DIA = SUBSTRING(VALOR FROM 9 FOR 2);
        MES = SUBSTRING(VALOR FROM 6 FOR 2);
        ANO = SUBSTRING(VALOR FROM 1 FOR 4);
    END

    IF (VALOR IS NOT NULL AND CHAR_LENGTH(VALOR) >= 8) THEN
    BEGIN
        HORA = SUBSTRING(VALOR FROM 12 FOR 2);
        MINU = SUBSTRING(VALOR FROM 15 FOR 2);
        SEG = SUBSTRING(VALOR FROM 18 FOR 2);
    END

    DATA_FORMAT = 
        CASE 
            WHEN ORDENACAO_DATA IS NOT NULL THEN
                CASE lower(ORDENACAO_DATA)
                    WHEN 'dd mm aaaa' THEN (DIA || SEPARADOR_DATA || MES || SEPARADOR_DATA || ANO)
                    WHEN 'dd mm aa' THEN (DIA || SEPARADOR_DATA || MES || SEPARADOR_DATA || SUBSTRING(ANO FROM 3 FOR 2))
                    WHEN 'mm dd aaaa' THEN (MES || SEPARADOR_DATA || DIA || SEPARADOR_DATA || ANO)
                    WHEN 'mm dd aa' THEN (MES || SEPARADOR_DATA || DIA || SEPARADOR_DATA || SUBSTRING(ANO FROM 3 FOR 2))
                    WHEN 'aaaa mm dd' THEN (ANO || SEPARADOR_DATA || MES || SEPARADOR_DATA || DIA)
                    WHEN 'aa mm dd' THEN (SUBSTRING(ANO FROM 3 FOR 2) || SEPARADOR_DATA || MES || SEPARADOR_DATA || DIA)
                    WHEN 'aaaa dd mm' THEN (ANO || SEPARADOR_DATA || DIA || SEPARADOR_DATA || MES)
                    WHEN 'aa dd mm' THEN (SUBSTRING(ANO FROM 3 FOR 2) || SEPARADOR_DATA || DIA || SEPARADOR_DATA || MES)
                    WHEN 'dd aaaa mm' THEN (DIA || SEPARADOR_DATA || ANO || SEPARADOR_DATA || MES)
                    WHEN 'dd aa mm' THEN (DIA || SEPARADOR_DATA || SUBSTRING(ANO FROM 3 FOR 2) || SEPARADOR_DATA || MES)
                    WHEN 'mm aaaa dd' THEN (MES || SEPARADOR_DATA || ANO || SEPARADOR_DATA || DIA)
                    WHEN 'mm aa dd' THEN (MES || SEPARADOR_DATA || SUBSTRING(ANO FROM 3 FOR 2) || SEPARADOR_DATA || DIA)
                    WHEN 'dd mm' THEN (DIA || SEPARADOR_DATA || MES)
                    WHEN 'mm dd' THEN (MES || SEPARADOR_DATA || DIA)
                    WHEN 'dd aaaa' THEN (DIA || SEPARADOR_DATA || ANO)
                    WHEN 'dd aa' THEN (DIA || SEPARADOR_DATA || SUBSTRING(ANO FROM 3 FOR 2))
                    WHEN 'aaaa dd' THEN (ANO || SEPARADOR_DATA || DIA)
                    WHEN 'aa dd' THEN (SUBSTRING(ANO FROM 3 FOR 2) || SEPARADOR_DATA || DIA)
                    WHEN 'mm aaaa' THEN (MES || SEPARADOR_DATA || ANO)
                    WHEN 'mm aa' THEN (MES || SEPARADOR_DATA || SUBSTRING(ANO FROM 3 FOR 2))
                    WHEN 'aaaa mm' THEN (ANO || SEPARADOR_DATA || MES)
                    WHEN 'aa mm' THEN (SUBSTRING(ANO FROM 3 FOR 2) || SEPARADOR_DATA || MES)
                    WHEN 'dd' THEN DIA
                    WHEN 'mm' THEN MES
                    WHEN 'aaaa' THEN ANO
                    WHEN 'aa' THEN SUBSTRING(ANO FROM 3 FOR 2)
                    ELSE 'Formato DATA Inválido!'
                END
            ELSE 'Data não fornecida'
        END;

    -- Formatar a hora
    HORA_FORMAT = 
        CASE 
            WHEN ORDENACAO_HORA IS NOT NULL THEN
                CASE lower(ORDENACAO_HORA)
                    WHEN 'hh mm ss' THEN (HORA || SEPARADOR_HORA || MINU || SEPARADOR_HORA || SEG)
                    WHEN 'hh ss mm' THEN (HORA || SEPARADOR_HORA || SEG || SEPARADOR_HORA || MINU)
                    WHEN 'mm hh ss' THEN (MINU || SEPARADOR_HORA || HORA || SEPARADOR_HORA || SEG)
                    WHEN 'mm ss hh' THEN (MINU || SEPARADOR_HORA || SEG || SEPARADOR_HORA || HORA)
                    WHEN 'ss hh mm' THEN (SEG || SEPARADOR_HORA || HORA || SEPARADOR_HORA || MINU)
                    WHEN 'ss mm hh' THEN (SEG || SEPARADOR_HORA || MINU || SEPARADOR_HORA || HORA)
                    WHEN 'hh mm' THEN (HORA || SEPARADOR_HORA || MINU)
                    WHEN 'hh ss' THEN (HORA || SEPARADOR_HORA || SEG)
                    WHEN 'mm hh' THEN (MINU || SEPARADOR_HORA || HORA)
                    WHEN 'mm ss' THEN (MINU || SEPARADOR_HORA || SEG)
                    WHEN 'ss hh' THEN (SEG || SEPARADOR_HORA || HORA)
                    WHEN 'ss mm' THEN (SEG || SEPARADOR_HORA || MINU)
                    WHEN 'hh' THEN HORA
                    WHEN 'mm' THEN MINU
                    WHEN 'ss' THEN SEG
                    ELSE 'Formato HORA Inválido!'
                END
            ELSE 'Hora não fornecida'
        END;

    RETURN
        CASE 
            WHEN (ORDENACAO_DATA IS NOT NULL AND ORDENACAO_HORA IS NOT NULL) THEN
                CASE POSICAO_DATA
                    WHEN 1 THEN DATA_FORMAT || ' ' || HORA_FORMAT
                    WHEN 2 THEN HORA_FORMAT || ' ' || DATA_FORMAT
                    ELSE 'POSICAO INVÁLIDA'
                END
            WHEN (ORDENACAO_DATA IS NOT NULL AND ORDENACAO_HORA IS NULL) THEN DATA_FORMAT
            WHEN (ORDENACAO_DATA IS NULL AND ORDENACAO_HORA IS NOT NULL) THEN HORA_FORMAT
            ELSE 'Formato Inválido!'
        END;
END