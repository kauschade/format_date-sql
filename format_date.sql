CREATE OR ALTER FUNCTION FORMAT_DATE (
    VALOR VARCHAR(24) DEFAULT CURRENT_TIMESTAMP,
    ORDENACAO_DATA VARCHAR(10) DEFAULT 'rand', 
    SEPARADOR_DATA VARCHAR(4) DEFAULT 'rand',
    ORDENACAO_HORA VARCHAR(10) DEFAULT 'rand', 
    SEPARADOR_HORA VARCHAR(4) DEFAULT 'rand',
    SEPARADOR_DH VARCHAR(4) DEFAULT 'rand',
    USAR_MLS BOOLEAN DEFAULT TRUE,
    POSICAO_DATA INT DEFAULT 1
) 
RETURNS VARCHAR(300)
AS
DECLARE VARIABLE DIA VARCHAR(2);
DECLARE VARIABLE MES VARCHAR(2);
DECLARE VARIABLE ANO VARCHAR(4);
DECLARE VARIABLE HORA VARCHAR(2);
DECLARE VARIABLE MINU VARCHAR(2);
DECLARE VARIABLE SEG VARCHAR(2);
DECLARE VARIABLE MLS VARCHAR(4);
DECLARE VARIABLE DATA_FORMAT VARCHAR(300);
DECLARE VARIABLE HORA_FORMAT VARCHAR(300);
DECLARE VARIABLE ERRO VARCHAR(50);
DECLARE VARIABLE AJUDA_DATA VARCHAR(300);
DECLARE VARIABLE AJUDA_HORA VARCHAR(300);
DECLARE VARIABLE MENSAGEM_ERRO_FORMATO VARCHAR(300);

BEGIN
    DIA = '00';
    MES = '00';
    ANO = '0000';
    HORA = '00';
    MINU = '00';
    SEG = '00';
    MLS = '00';

    MENSAGEM_ERRO_FORMATO = 
        replace('Formato inválido, tente: "SELECT FORMAT_DATE(:aspas_simples:' || valor || ':aspas_simples:, :aspas_simples:ajuda:aspas_simples:, null, :aspas_simples:ajuda:aspas_simples:, null) FROM suatabela;"', ':aspas_simples:', '''');

    AJUDA_DATA = 
        '****[Ajuda DATA: dd = dias / mm = meses / yyyy = anos (4 digitos) / yy = anos (2 digitos)]****';

    AJUDA_HORA = 
        '****[Ajuda HORA: hh = horas / mm = minutos / ss = segundos]****';

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
        MLS = SUBSTRING(VALOR FROM 20 FOR 4);
    END

    ORDENACAO_DATA =
        CASE WHEN lower(ORDENACAO_DATA) = 'rand' THEN
            CASE (SELECT CAST(RAND() * 5 + 1 AS INTEGER) FROM RDB$DATABASE) 
                WHEN 1 THEN 'dd mm aaaa'
                WHEN 2 THEN 'mm dd aaaa'
                WHEN 3 THEN 'aaaa mm dd'
                WHEN 4 THEN 'aaaa dd mm'
                WHEN 5 THEN 'dd aaaa mm'
                WHEN 6 THEN 'mm aaaa dd'
                ELSE ORDENACAO_DATA
            END
        ELSE ORDENACAO_DATA END;

    SEPARADOR_DATA =
        CASE WHEN lower(SEPARADOR_DATA) = 'rand' THEN
            CASE (SELECT CAST(RAND() * 5 + 1 AS INTEGER) FROM RDB$DATABASE) 
                WHEN 1 THEN '/'
                WHEN 2 THEN '-'
                WHEN 3 THEN '_'
                WHEN 4 THEN 'x'
                WHEN 5 THEN ' '
                WHEN 6 THEN ''
                ELSE SEPARADOR_DATA
            END
        ELSE SEPARADOR_DATA END;

    DATA_FORMAT = 
        CASE 
            WHEN ORDENACAO_DATA IS NOT NULL THEN
                CASE REPLACE(lower(ORDENACAO_DATA),'y','a')
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
                    WHEN 'ajuda' THEN AJUDA_DATA
                    ELSE 'ERRO'
                END
            ELSE 'Data não fornecida'
        END;

    ORDENACAO_HORA = 
        CASE WHEN lower(ORDENACAO_HORA) = 'rand' THEN
            CASE (SELECT CAST(RAND() * 5 + 1 AS INTEGER) FROM RDB$DATABASE) 
                WHEN 1 THEN 'hh mm ss'
                WHEN 2 THEN 'hh ss mm'
                WHEN 3 THEN 'mm hh ss'
                WHEN 4 THEN 'mm ss hh'
                WHEN 5 THEN 'ss hh mm'
                WHEN 6 THEN 'ss mm hh'
                ELSE ORDENACAO_HORA
            END
        ELSE ORDENACAO_HORA END;

    SEPARADOR_HORA =
        CASE WHEN lower(SEPARADOR_HORA) = 'rand' THEN
            CASE (SELECT CAST(RAND() * 5 + 1 AS INTEGER) FROM RDB$DATABASE) 
                WHEN 1 THEN ':'
                WHEN 2 THEN '-'
                WHEN 3 THEN '_'
                WHEN 4 THEN 'x'
                WHEN 5 THEN ' '
                WHEN 6 THEN ''
                ELSE SEPARADOR_HORA
            END
        ELSE SEPARADOR_HORA END;

    HORA_FORMAT = 
        CASE USAR_MLS
            WHEN TRUE THEN 
            CASE 
                WHEN ORDENACAO_HORA IS NOT NULL THEN 
                CASE lower(ORDENACAO_HORA)
                        WHEN 'hh mm ss' THEN (HORA || SEPARADOR_HORA || MINU || SEPARADOR_HORA || SEG || MLS)
                        WHEN 'hh ss mm' THEN (HORA || SEPARADOR_HORA || SEG || MLS || SEPARADOR_HORA || MINU)
                        WHEN 'mm hh ss' THEN (MINU || SEPARADOR_HORA || HORA || SEPARADOR_HORA || SEG || MLS)
                        WHEN 'mm ss hh' THEN (MINU || SEPARADOR_HORA || SEG || MLS || SEPARADOR_HORA || HORA)
                        WHEN 'ss hh mm' THEN (SEG || MLS || SEPARADOR_HORA || HORA || SEPARADOR_HORA || MINU)
                        WHEN 'ss mm hh' THEN (SEG || MLS || SEPARADOR_HORA || MINU || SEPARADOR_HORA || HORA)
                        WHEN 'hh mm' THEN (HORA || SEPARADOR_HORA || MINU)
                        WHEN 'hh ss' THEN (HORA || SEPARADOR_HORA || SEG || MLS)
                        WHEN 'mm hh' THEN (MINU || SEPARADOR_HORA || HORA)
                        WHEN 'mm ss' THEN (MINU || SEPARADOR_HORA || SEG || MLS)
                        WHEN 'ss hh' THEN (SEG || MLS || SEPARADOR_HORA || HORA)
                        WHEN 'ss mm' THEN (SEG || MLS || SEPARADOR_HORA || MINU)
                        WHEN 'hh' THEN HORA
                        WHEN 'mm' THEN MINU
                        WHEN 'ss' THEN SEG || MLS
                        WHEN 'ajuda' THEN AJUDA_HORA
                        ELSE 'ERRO'
                    END
                ELSE 'Hora não fornecida'
            END
            ELSE 
            CASE WHEN ORDENACAO_HORA IS NOT NULL THEN 
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
                        WHEN 'ajuda' THEN AJUDA_HORA
                        ELSE 'ERRO'
                    END
                ELSE 'Hora não fornecida'
            END
        END;

    SEPARADOR_DH =
        CASE WHEN lower(SEPARADOR_DH) = 'rand' THEN
            CASE (SELECT CAST(RAND() * 1 + 1 AS INTEGER) FROM RDB$DATABASE)
                WHEN 1 THEN ' '
                WHEN 2 THEN ''
                ELSE SEPARADOR_DH
            END
        ELSE SEPARADOR_DH END;

    ERRO = 
        CASE 
            WHEN DATA_FORMAT = 'ERRO' THEN '404'
            WHEN HORA_FORMAT = 'ERRO' THEN '404'
            ELSE '200'
        END;

    RETURN
        CASE ERRO
            WHEN '404' THEN 
                CASE 
                    WHEN DATA_FORMAT = 'ERRO' THEN '(' || ORDENACAO_DATA || ') - ' || MENSAGEM_ERRO_FORMATO
                    WHEN HORA_FORMAT = 'ERRO' THEN '(' || ORDENACAO_HORA || ') - ' || MENSAGEM_ERRO_FORMATO
                    ELSE MENSAGEM_ERRO_FORMATO
                END 
            ELSE 
                CASE 
                    WHEN (ORDENACAO_DATA IS NOT NULL AND ORDENACAO_HORA IS NOT NULL) THEN
                        CASE POSICAO_DATA
                            WHEN 1 THEN DATA_FORMAT || SEPARADOR_DH || HORA_FORMAT
                            WHEN 2 THEN HORA_FORMAT || SEPARADOR_DH || DATA_FORMAT
                            ELSE replace('(' || POSICAO_DATA || ') - Posição Inválida, use 1 para: :aspas_simples:' || DATA_FORMAT || SEPARADOR_DH || HORA_FORMAT || ':aspas_simples:. Ou 2 para: :aspas_simples:' || HORA_FORMAT || SEPARADOR_DH || DATA_FORMAT || ':aspas_simples:.', ':aspas_simples:', '''')
                        END
                    WHEN (ORDENACAO_DATA IS NOT NULL AND ORDENACAO_HORA IS NULL) THEN DATA_FORMAT
                    WHEN (ORDENACAO_DATA IS NULL AND ORDENACAO_HORA IS NOT NULL) THEN HORA_FORMAT
                    ELSE MENSAGEM_ERRO_FORMATO
                END
        END;
END