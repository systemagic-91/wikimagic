-- LICAO 5

-- filtrando dados com where e and
select p.prod_id, p.prod_price, p.prod_name 
from products p 
where p.vend_id = 'DLL01' 
and p.prod_price <= 4;

-- filtrando dados com where e or
select p.prod_id, p.prod_price, p.prod_name 
from products p 
where p.vend_id = 'DLL01' 
or p.vend_id = 'BRS01';

-- OBS: O SQL processa os operadores AND antes dos 
-- operadores OR. A solucao para esse problema é usar
-- parenteses para agrupar explicitamente operadores
-- relacionados
select p.prod_name, p.prod_price
from products p
where (p.vend_id = 'DLL01' or p.vend_id = 'BRS01')
and p.prod_price >= 10;

-- Usando o operador IN
select p.prod_name, p.prod_price
from products p
where p.vend_id in ('DLL01', 'BRS01')
order by p.prod_name ;

-- Usando o operador NOT
select p.prod_name
from products p
where not p.vend_id = 'DLL01'
order by p.prod_name;


-- DESAFIOS LICAO 5

-- nome de fornecedores da California - USA 
select v.vend_name   
from vendors v
where v.vend_country = 'USA'
and v.vend_state = 'CA';

-- pedidos com quantidade e codigo especificos
select oi.order_num, oi.prod_id, oi.quantity
from orderitems oi  
where oi.prod_id in ('BR01', 'BR02', 'BR03')
and oi.quantity >= 100;

-- buscando produtos em intervalo de preço
select p.prod_name, p.prod_price 
from products p 
where p.prod_price >= 3
and p.prod_price <= 6
order by p.prod_price;

-- corrigindo instrução
select v.vend_name
from vendors v
where v.vend_country  = 'USA'
and v.vend_state = 'CA'
order by v.vend_name;