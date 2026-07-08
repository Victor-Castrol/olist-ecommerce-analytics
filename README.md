# Olist E-commerce Analytics

Análise de 96 mil pedidos do e-commerce brasileiro (dataset público da Olist, 2016-2018).
Banco modelado em PostgreSQL, análise em SQL e dashboard de 3 páginas em Power BI.

## O dashboard

### Página 1 — Visão Executiva
Evolução da receita, KPIs gerais e os principais cortes por categoria e estado.

![Visão Executiva](img/pagina1_executiva.png)

### Página 2 — Clientes & Geografia
Onde estão os clientes e quanto vale cada região: mapa de receita, ticket médio e volume por estado.

![Clientes e Geografia](img/pagina2_geografia.png)

### Página 3 — Logística & Pagamentos
Onde a promessa de entrega quebra e como o cliente paga: atrasos por estado, prazo real vs prometido e métodos de pagamento.

![Logística e Pagamentos](img/pagina3_logistica.png)

## Stack

**PostgreSQL 18**
- 9 tabelas modeladas manualmente com chaves primárias, estrangeiras e tipos definidos (~1,5 mi de registros)
- Carga via COPY respeitando a ordem de dependência entre tabelas
- Queries de análise com JOINs múltiplos, LEFT JOIN + COALESCE, agregações condicionais (CASE WHEN) e aritmética de datas

**Power BI**
- Modelo estrela com order_items como tabela fato e 5 dimensões
- 21 medidas DAX em pastas: base, time intelligence (MoM, YoY, YTD com CALCULATE + DATEADD), logística (AVERAGEX + DATEDIFF) e pagamentos
- Tabela calendário marcada como tabela de data, com flag de mês completo
- Tema JSON próprio, navegação por botões e slicers sincronizados entre páginas

## O que a análise mostrou

1. **A Black Friday de 2017 não foi só um pico.** Nov/2017 cresceu +53% sobre o mês anterior e, depois dela, a receita mensal subiu de patamar e não voltou mais ao nível anterior. Pro negócio, isso muda a leitura: BF não é ação pontual, é motor de aquisição com efeito permanente na base.

2. **O ticket médio é maior longe dos grandes centros.** PB tem ticket de R$ 263 contra R$ 210 de SP, e o top 10 de ticket é todo Norte/Nordeste — o inverso do ranking de volume, onde SP domina com 42 mil pedidos. Faz sentido: o frete pesa mais e quem espera 20+ dias por uma entrega só compra o que vale a pena. Na prática, o cliente do interior vale mais por pedido.

3. **Alagoas tem 23% de pedidos atrasados, o pior do país.** O problema não é distância: estados do Norte com prazos maiores entregam no prazo (AC e AP atrasam só 4%). Em AL a folga prometida (9 dias) é curta demais para a logística local. A correção que os dados sugerem é barata: recalibrar o prazo estimado do Nordeste — ajuste de parâmetro, não de infraestrutura.

4. **Cartão de crédito concentra quase 80% do valor transacionado.** Metade das transações é parcelada, com média de 2,9 parcelas. Qualquer discussão de pricing ou antecipação de recebíveis nesse e-commerce começa por esse dado.

## Decisões de análise

- Só pedidos com status "delivered" entram nas métricas (receita confirmada)
- Meses incompletos do dataset foram excluídos por flag na tabela calendário, senão o gráfico mostra uma queda de receita que não existe
- Clientes contados por customer_unique_id. O customer_id muda a cada pedido e infla a contagem
- Método de pagamento "not_defined" (4 transações) excluído por irrelevância
- As medidas do Power BI foram conferidas contra as queries SQL

## Como reproduzir

1. Baixar o dataset: kaggle.com/datasets/olistbr/brazilian-ecommerce
2. Extrair os CSVs em data/
3. Rodar sql/01_create_tables.sql e depois sql/02_load_data.sql
4. Abrir powerbi/dashboard_olist.pbix e apontar a conexão pro seu PostgreSQL local