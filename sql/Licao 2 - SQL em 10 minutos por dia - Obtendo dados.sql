-- LICAO 2

-- Obtendo uma unica coluna
select prod_name from products;

-- Obtendo multiplas colunas
select prod_id, prod_name, prod_price from products;

-- Obtendo todas as colunas
select * from products;

-- Obtendo valores distintos (valores únicos, sem repeticao)
-- há 3 vendedores e quero o obter os ids deles sem repetir
select distinct vend_id from products;
select distinct vend_id, prod_price from products;
select vend_id, prod_price from products;

-- Limitando resultados, retornar 5 linhas
select prod_name from products limit 5;

-- Retornando 5 linhas começando da linah 5
select prod_name from products limit 5 offset 5;

-- DESAFIOS LICAO 2
select cust_id from customers; -- obtendo id dos clientes
select distinct prod_id from orderitems; -- obtendo a lista dos produtos pedidos
select * from customers; -- obtendo infomrmacoes dos clientes
