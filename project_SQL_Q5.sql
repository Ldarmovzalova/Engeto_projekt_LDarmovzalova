-- Q5: Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin či mzdách ve stejném nebo následujícím roce výraznějším růstem?

select *
from t_lucie_darmovzalova_project_sql_secondary_final
where country = 'Czech Republic'; -- kontrola dat

select *
from t_lucie_darmovzalova_project_sql_primary_final;

-- propojení dat tabulek primary a secondary podle roku se spočítaným průměrem cen potravin všech kategorií

select
	p.rok,
	s.gdp as hdp,
	p.prumerna_mzda,
	round(avg(p.prumerna_cena_potravin)::numeric,2) as prumerna_cena_potravin
from t_lucie_darmovzalova_project_sql_primary_final as p
join t_lucie_darmovzalova_project_sql_secondary_final as s on p.rok=s.year
where p.rok between 2006 and 2018 
	and country = 'Czech Republic'
group by p.rok, s.gdp, p.prumerna_mzda
order by p.rok asc; -- zobrazuje HDP, prumernou_mzdu a prumernou cenu potravin po letech v období 2006 až 2018, kde máme data pro pptraviny a mzdy


-- Vytvoření přehledu procent nárůstu/ pokledu HDP, mezd a cen potravin
with prehled_narustu as(
	select
		p.rok,
		s.gdp as hdp,
		p.prumerna_mzda,
		round(avg(p.prumerna_cena_potravin)::numeric,2) as prumerna_cena_potravin
	from t_lucie_darmovzalova_project_sql_primary_final as p
	join t_lucie_darmovzalova_project_sql_secondary_final as s on p.rok=s.year
	where p.rok between 2006 and 2018 
		and country = 'Czech Republic'
	group by p.rok, s.gdp, p.prumerna_mzda)
select 
	pn1.rok,
	round((100*(pn1.hdp-pn2.hdp)/ nullif (pn2.hdp,0))::numeric,2) as mezirocni_zmena_hdp,
	round(100*(pn1.prumerna_mzda-pn2.prumerna_mzda)/ nullif (pn2.prumerna_mzda,0),2) as mezirocni_zmena_mezd,
	round(100*(pn1.prumerna_cena_potravin-pn2.prumerna_cena_potravin)/ nullif (pn2.prumerna_cena_potravin,0),2) as mezirocni_zmena_cen_potravin
from prehled_narustu as pn1
join prehled_narustu as pn2 on pn1.rok = pn2.rok + 1
order by pn1.rok;
	
-- Data ukazují, že HDP má vliv na vývoj mezd i cen potravin. Pokud HPD stoupá, soupají i mzdy a ceny potravin, ne však rovnoměrně, změny v cenách potravin jsou výraznější než změny u mezd.
-- Mzdy i ceny potravin se mění samozřejmě i pokud HDP meziročně klesá. 
