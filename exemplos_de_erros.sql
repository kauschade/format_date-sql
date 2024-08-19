-- Posição Inválida
SELECT 
	FORMAT_DATE(
        CURRENT_TIMESTAMP,
        'dd mm aaaa',
        '/',
        'hh mm ss',
        ':',
        ' ',
        FALSE,
        3 -- CAMPO COM ERRO
    )
FROM suatabela;
-- Resposta: Posição Inválida, use 1 para: 'DATA HORA'. Ou 2 para: 'HORA DATA'.
-- Por quê: Posição não existe, logo, não é possível usa-la.



-- Formato Inválido
SELECT 
	FORMAT_DATE(
        CURRENT_TIMESTAMP,
        null, -- CAMPO COM ERRO
        '/',
        null, -- CAMPO COM ERRO
        ':',
        ' ',
        FALSE,
        1
    )
FROM suatabela;
-- Resposta: Formato inválido, tente: "SELECT FORMAT_DATE(CURRENT_TIMESTAMP, 'ajuda', null, 'ajuda', null) FROM suatabela;".
-- Por quê: Não é possível utilizar data e hora como null.



-- Formato Inválido
SELECT 
	FORMAT_DATE(
        CURRENT_TIMESTAMP,
        'dd mm aaaj', -- CAMPO COM ERRO
        '/',
        'hh mm ss',
        ':',
        ' ',
        FALSE,
        1
    )
FROM suatabela;
-- Resposta: (dd mm aaaj) - Formato inválido, tente: "SELECT FORMAT_DATE(CURRENT_TIMESTAMP, 'ajuda', null, 'ajuda', null) FROM suatabela;".
-- Por quê: Formato de data não existe, não permite usar um formato inexistente.



-- Formato Inválido
SELECT 
	FORMAT_DATE(
        CURRENT_TIMESTAMP,
        'dd mm aaaa',
        '/',
        'hh mm sj', -- CAMPO COM ERRO
        ':',
        ' ',
        FALSE,
        1
    )
FROM suatabela;
-- Resposta: (hh mm sj) - Formato inválido, tente: "SELECT FORMAT_DATE(CURRENT_TIMESTAMP, 'ajuda', null, 'ajuda', null) FROM suatabela;".
-- Por quê: Formato de hora não existe, não permite usar um formato inexistente.