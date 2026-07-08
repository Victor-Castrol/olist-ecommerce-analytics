
-- Q1: Receita mensal (pedidos entregues)
SELECT
    DATE_TRUNC('month', o.order_purchase_timestamp) AS mes,
    COUNT(DISTINCT o.order_id) AS qtd_pedidos,
    SUM(oi.price) AS receita_produtos,
    SUM(oi.freight_value) AS receita_frete
FROM orders o
JOIN order_items oi ON oi.order_id = o.order_id
WHERE o.order_status = 'delivered'
GROUP BY 1
ORDER BY 1;

-- Q2: Top 10 categorias por faturamento

SELECT
    COALESCE(t.product_category_name_english, p.product_category_name, 'sem_categoria') AS categoria,
    COUNT(DISTINCT o.order_id) AS qtd_pedidos,
    SUM(oi.price) AS receita
FROM orders o
JOIN order_items oi ON oi.order_id = o.order_id
JOIN products p ON p.product_id = oi.product_id
LEFT JOIN product_category_translation t ON t.product_category_name = p.product_category_name
WHERE o.order_status = 'delivered'
GROUP BY 1
ORDER BY receita DESC
LIMIT 10;

-- Q3: Ticket médio por estado do cliente

SELECT
    c.customer_state AS estado,
    COUNT(DISTINCT o.order_id) AS qtd_pedidos,
    SUM(oi.price + oi.freight_value) AS receita_total,
    ROUND(SUM(oi.price + oi.freight_value) / COUNT(DISTINCT o.order_id), 2) AS ticket_medio
FROM orders o
JOIN order_items oi ON oi.order_id = o.order_id
JOIN customers c ON c.customer_id = o.customer_id
WHERE o.order_status = 'delivered'
GROUP BY 1
ORDER BY ticket_medio DESC;

-- Q4: Desempenho de entrega por estado

SELECT
    c.customer_state AS estado,
    COUNT(*) AS pedidos_entregues,
    ROUND(AVG(o.order_delivered_customer_date::date - o.order_purchase_timestamp::date), 1) AS media_dias_entrega,
    ROUND(AVG(o.order_estimated_delivery_date::date - o.order_delivered_customer_date::date), 1) AS folga_media_dias,
    ROUND(
        100.0 * SUM(CASE WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date THEN 1 ELSE 0 END)
        / COUNT(*), 2
    ) AS pct_atrasados
FROM orders o
JOIN customers c ON c.customer_id = o.customer_id
WHERE o.order_status = 'delivered'
  AND o.order_delivered_customer_date IS NOT NULL
GROUP BY 1
ORDER BY pct_atrasados DESC;



-- Q5: Métodos de pagamento e parcelamento

SELECT
    op.payment_type AS metodo,
    COUNT(DISTINCT op.order_id) AS qtd_pedidos,
    SUM(op.payment_value) AS valor_total,
    ROUND(AVG(op.payment_installments), 1) AS parcelas_medias,
    ROUND(
        100.0 * SUM(CASE WHEN op.payment_installments > 1 THEN 1 ELSE 0 END) / COUNT(*), 2
    ) AS pct_parcelado
FROM order_payments op
JOIN orders o ON o.order_id = op.order_id
WHERE o.order_status = 'delivered'
GROUP BY 1
ORDER BY valor_total DESC;
