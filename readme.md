# Função FORMAT_DATE

A função `FORMAT_DATE` permite formatar datas e horas em um formato personalizado. Você pode definir como a data e a hora serão exibidas, além de escolher a ordem e os separadores.

## Descrição

A função `FORMAT_DATE` formata uma data e uma hora fornecidas em um formato personalizado.

## Formatos de Data

| Abreviação | Representa               |
|------------|--------------------------|
| `dd`       | Dia                      |
| `mm`       | Mês                      |
| `aaaa`     | Ano (4 dígitos)          |
| `aa`       | Ano (2 dígitos)          |

### Exemplos de Formatos de Data

| Formato        | Exemplo       |
|----------------|---------------|
| `dd mm aaaa`   | 06 08 2024    |
| `dd mm aa`     | 06 08 24      |
| `mm dd aaaa`   | 08 06 2024    |
| `mm dd aa`     | 08 06 24      |
| `aaaa mm dd`   | 2024 08 06    |
| `aa mm dd`     | 24 08 06      |
| `aaaa dd mm`   | 2024 06 08    |
| `aa dd mm`     | 24 06 08      |
| `dd aaaa mm`   | 06 2024 08    |
| `dd aa mm`     | 06 24 08      |
| `mm aaaa dd`   | 08 2024 06    |
| `mm aa dd`     | 08 24 06      |
| `dd mm`        | 06 08         |
| `mm dd`        | 08 06         |
| `dd aaaa`      | 06 2024       |
| `dd aa`        | 06 24         |
| `aaaa dd`      | 2024 06       |
| `aa dd`        | 24 06         |
| `mm aaaa`      | 08 2024       |
| `mm aa`        | 08 24         |
| `aaaa mm`      | 2024 08       |
| `aa mm`        | 24 08         |
| `dd`           | 06            |
| `mm`           | 08            |
| `aaaa`         | 2024          |
| `aa`           | 24            |

## Formatos de Hora

| Abreviação | Representa               |
|------------|--------------------------|
| `hh`       | Horas                    |
| `mm`       | Minutos                  |
| `ss`       | Segundos                 |

### Exemplos de Formatos de Hora

| Formato        | Exemplo       |
|----------------|---------------|
| `hh mm ss`     | 10 00 00      |
| `hh ss mm`     | 10 00 00      |
| `mm hh ss`     | 00 10 00      |
| `mm ss hh`     | 00 00 10      |
| `ss hh mm`     | 00 10 00      |
| `ss mm hh`     | 00 00 10      |
| `hh mm`        | 10 00         |
| `hh ss`        | 10 00         |
| `mm hh`        | 00 10         |
| `mm ss`        | 00 00         |
| `ss hh`        | 00 10         |
| `ss mm`        | 00 00         |
| `hh`           | 10            |
| `mm`           | 00            |
| `ss`           | 00            |

## Parâmetros

- **VALOR**: Data e hora para formatar, no formato `aaaa-mm-dd hh:mm:ss`.
- **ORDENACAO_DATA**: Formato da data (ex: `dd mm aaaa`).
- **SEPARADOR_DATA**: Separador para a data (ex: `/`).
- **ORDENACAO_HORA**: Formato da hora (ex: `hh mm ss`).
- **SEPARADOR_HORA**: Separador para a hora (ex: `:`).
- **POSICAO_DATA**: Define se a data aparece antes (1) ou depois (2) da hora.

## Exemplos de Uso

1. **Formato completo:**

   ```sql
   SELECT FORMAT_DATE('2024-08-06 10:00:00', 'dd mm aaaa', '/', 'hh mm', ':', 1) FROM sua_tabela;
   -- Retorno: '06/08/2024 10:00'```
   
2. **Somente data:**

   ```sql
   SELECT FORMAT_DATE('2024-08-06 10:00:00', 'dd mm aaaa', '/', null, null, 1) FROM sua_tabela;
   -- Retorno: '06/08/2024'```

3. **Somente hora:**

   ```sql
   SELECT FORMAT_DATE('2024-08-06 10:00:00', null, null, 'hh mm ss', ':', 1) FROM sua_tabela;
   -- Retorno: '10:00:00'```

4. **Hora antes da Data:**

   ```sql
   SELECT FORMAT_DATE('2024-08-06 10:00:00', 'dd mm aaaa', '/', 'hh mm', ':', 2) FROM sua_tabela;
    -- Retorno: '10:00 06/08/2024'```