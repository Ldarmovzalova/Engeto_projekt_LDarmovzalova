-- Vytvoření tabulky primary pomocné tabulky pro následnou práci s daty

select *
from czechia_price cp 
limit 10;-- kontrola obsahu tabulky


select *
from czechia_price_category cpc 
where name like 'Chl%'; -- 114201 pro mléko, 111301 pro chléb, zadala jsem si vyhledání po jednom Ch% a předtím Ml%

select
    extract(year from date_from) as rok,
    category_code,
    round(avg(value)::numeric, 2) as prumerna_cena
  from czechia_price
  where category_code in (114201, 111301)  -- 114201 = chléb, 111301 = mléko
  group by rok, category_code
  order by rok, category_code; -- dotaz spočítá průmerné ceny během evidovaných let pro obě potraviny


select 
	payroll_year as year,
	round (avg (value)::numeric,2) as prumerna_mzda
from czechia_payroll
where value_type_code = 5958
group by payroll_year 
order by payroll_year asc; -- tabulka pro průměrnou mzdu napříč odvětvími za jednotlivé roky

--spojení obou dotazů a vytvoření pomocné tabulky 

create table t_lucie_darmovzalova_project_SQL_primary_final as
with prumerne_ceny as(
	select
 	  extract(year from date_from) as rok,
  	  category_code as kod_kategorie,
  	  round(avg(value)::numeric, 2) as prumerna_cena
 	 from czechia_price as cp
 	 where category_code in (114201, 111301)  -- 114201 = chléb, 111301 = mléko
	  group by rok, category_code
	  order by rok, category_code),
prumerna_mzda as(
	select 
		payroll_year as year,
		round (avg (value)::numeric,2) as prumerna_mzda
	from czechia_payroll as cpa
	where value_type_code = 5958
	group by payroll_year 
	order by payroll_year asc)
select
 	pc. rok,
  	pc.kod_kategorie,
  	  case kod_kategorie
    when 114201 then 'chléb'
    when 111301 then 'mléko'
  END AS nazev_potraviny,
  	pc.prumerna_cena,
  	pm.prumerna_mzda
from prumerne_ceny as pc
join prumerna_mzda as pm ON pc.rok = pm.year
order by pc.rok, pc.kod_kategorie;

select *
from t_lucie_darmovzalova_project_SQL_primary_final; -- kontrola dat, že tabulka obsahuje všechny požadované sloupce



 
  	
  
 





	