-- LICAO 3

-- classificando dados com order by
select prod_name 
from products p 
order by p.prod_name; 

-- classificando multiplas colunas
-- nesse caso os produtos sao classificados 
-- pelo name somente se tiverem o mesmo price
select prod_id, prod_price, prod_name 
from products p 
order by p.prod_price, p.prod_name; 

-- especificando a direcao
select prod_id, prod_price, prod_name 
from products p 
order by p.prod_price DESC; 

-- DESAFIOS LICAO 3

-- obtendo nomes ordenados de z ate a
select c.cust_name 
from customers c
order by c.cust_name desc;

-- obtendo pedidos ordenados por data e id cliente
select o.cust_id, o.order_num 
from orders o  
order by o.cust_id, o.order_date desc;

-- classificand por quantidade e preco
select o.quantity, o.item_price 
from orderitems o 
order by o.quantity desc, o.item_price desc;

-- corrigindo isntrução (faltava o by de orderby)
select vend_name
from vendors v 
order by vend_name desc;