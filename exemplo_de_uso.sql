SELECT 
	FORMAT_DATE(
        CURRENT_TIMESTAMP,  -- DATA E HORA
        'dd mm aaaa',       -- FORMATO DATA
        '/',                -- SEPARADOR DATA
        'hh mm ss',         -- FORMATO HORA
        ':',                -- SEPARADOR HORA
        ' ',                -- SEPARADOR ENTRE DATA E HORA
        FALSE,              -- USAR MILISSEGUNGOS
        1                   -- POSIÇÃO DATA
    )
FROM suatabela;
