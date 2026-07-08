COPY customers FROM 'C:/projetos/projeto-olist/data/olist_customers_dataset.csv' DELIMITER ',' CSV HEADER;

COPY sellers FROM 'C:/projetos/projeto-olist/data/olist_sellers_dataset.csv' DELIMITER ',' CSV HEADER;

COPY products FROM 'C:/projetos/projeto-olist/data/olist_products_dataset.csv' DELIMITER ',' CSV HEADER;

COPY geolocation FROM 'C:/projetos/projeto-olist/data/olist_geolocation_dataset.csv' DELIMITER ',' CSV HEADER;

COPY product_category_translation FROM 'C:/projetos/projeto-olist/data/product_category_name_translation.csv' DELIMITER ',' CSV HEADER;

COPY orders FROM 'C:/projetos/projeto-olist/data/olist_orders_dataset.csv' DELIMITER ',' CSV HEADER;

COPY order_items FROM 'C:/projetos/projeto-olist/data/olist_order_items_dataset.csv' DELIMITER ',' CSV HEADER;

COPY order_payments FROM 'C:/projetos/projeto-olist/data/olist_order_payments_dataset.csv' DELIMITER ',' CSV HEADER;

COPY order_reviews FROM 'C:/projetos/projeto-olist/data/olist_order_reviews_dataset.csv' DELIMITER ',' CSV HEADER;