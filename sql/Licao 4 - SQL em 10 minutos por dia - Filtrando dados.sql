-- LICAO 4

-- filtrando dados com where
select prod_name, prod_price
from products p 
where p.prod_price = 3.49; 

-- listando produtos com valor inferior a $10
select prod_name, prod_price
from products p 
where p.prod_price < 10; 

-- listando produtos com valor inferior ou igual a $10
select prod_name, prod_price
from products p 
where p.prod_price <= 10; 

-- produtos que não foram fabricados por um vendedor
select vend_id, prod_name
from products p
where p.vend_id <> 'DLL01';

-- verificando intervalo de valores
select prod_name, prod_price
from products p 
where p.prod_price between 5 and 10;

-- verificando se a coluna tem valor null
select prod_name
from products p 
where p.prod_price is null;

select cust_name
from customers c 
where c.cust_email is null;

-- DESAFIOS LICAO 4

-- produtos com preço 9.49
select p.prod_id, p.prod_name 
from products p 
where p.prod_price = 9.49;

-- produtos com preço >= 9
select p.prod_id, p.prod_name 
from products p 
where p.prod_price >= 9;

-- numeros de pedidos com 100 ou mais intens 
select distinct o.order_num 
from orderitems o 
where quantity >= 100;

-- produtos com preco entre 3 e 6 ordenados por preco
select p.prod_name, p.prod_price 
from products p 
where p.prod_price between 3 and 6
order by p.prod_price; 