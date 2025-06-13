-- Vytvoření tabulky primary pomocné tabulky pro následnou práci s daty

select *
from czechia_price cp 
limit 10;-- kontrola obsahu tabulky

select
    extract(year from date_from) as rok,
    category_code as kod,
    round(avg(value)::numeric, 2) as prumerna_cena
  from czechia_price
  group by rok, category_code
  order by rok, category_code;

select
	payroll_year as rok,
	round (avg (value)::numeric,2) as prumerna_mzda
from czechia_payroll
where value_type_code = 5958
group by payroll_year 
order by payroll_year asc; -- tabulka pro průměrnou mzdu napříč odvětvími za jednotlivé roky


-- spojení obou dotazů a vytvoření pomocné tabulky

create table t_lucie_darmovzalova_project_SQL_primary_final as
with prumerne_ceny as(
	select 
		extract (year from date_from) as rok,
		category_code as kod,
		round (avg(value)::numeric, 2) as prumerna_cena_potravin
	from czechia_price
	group by rok, kod),
prumerna_mzda as(
	select 
		payroll_year as rok,
		round(avg(value)::numeric, 2) as prumerna_mzda
	from czechia_payroll
	where value_type_code=5958
	group by rok)
select 
	pc.rok,
	pc.kod,
	pc.prumerna_cena_potravin,
	pm.prumerna_mzda
from prumerne_ceny as pc
join prumerna_mzda as pm on pc.rok=pm.rok
order by pm.rok, pc.kod;

select *
from t_lucie_darmovzalova_project_SQL_primary_final;
	

	





