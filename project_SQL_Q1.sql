-- Q1: Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?

select distinct value_type_code
from czechia_payroll; -- 5958 prumerna mzda zamestnance


select *
from czechia_payroll_industry_branch cpib -- najít podle čeho můžu tabulky spojit
limit 10;

create table t_lucie_darmovzalova_project_SQL_primary_Q1_final as
select
	cp.industry_branch_code as kod_odvetvi,
	cpib.name as nazev,
	cp.payroll_year as rok,
	round (avg (cp.value)::numeric,2) as prumerna_mzda
from czechia_payroll as cp
join czechia_payroll_industry_branch as cpib 
	on cp.industry_branch_code= cpib.code
where value_type_code = 5958 
	and industry_branch_code is not null
group by cp.industry_branch_code, 
	cpib.name,
	cp.payroll_year
order by cp.industry_branch_code asc,
	cpib.name asc, 
	cp.payroll_year asc;

select *
from t_lucie_darmovzalova_project_SQL_primary_Q1_final; -- kontrola vytvořené tabulky, ze které budu dál srovnávat data, jestli mzdy klesají, nebo stoupají v průběhu let v jednotlivých odvětvích

create view v_t_lucie_darmovzalova_project_SQL_primary_Q1_final as
select 	
	a.kod_odvetvi,
	a.nazev,
	a.rok,
	a.prumerna_mzda,
	b.prumerna_mzda as prumerna_mzda_za_predchozi_rok,
	case
		when b.prumerna_mzda is null then 'Nejsou data za předchozí rok'
		when a.prumerna_mzda < b.prumerna_mzda then 'Pokles'
		when a.prumerna_mzda > b.prumerna_mzda then 'Nárůst'
		else 'Není změna'
	end mezirocni_zmeny
from t_lucie_darmovzalova_project_SQL_primary_Q1_final as a
left join t_lucie_darmovzalova_project_SQL_primary_Q1_final as b
	on a.kod_odvetvi = b.kod_odvetvi --přidám stejnou tabulku a navýším data o jeden rok, abych měla vedle seme aktuální rok, a předchozí rok a mohla jsem srovnat, jestli je mezi jednotvýlimi průměry pokled, nebo nárůst, nebo se nic nezměnilo
	and a.rok=b.rok+1
order by kod_odvetvi asc, nazev asc, rok asc;

select *
from v_t_lucie_darmovzalova_project_sql_primary_q1_final ; -- kontrola vytvořeného view, zda vše sedí jak potřebuju -> záznamy začínají rokem 2000 a končí rokem 2021, odvětví A-S

select 
	mezirocni_zmeny,
	nazev,
	rok
from v_t_lucie_darmovzalova_project_sql_primary_q1_final 
where kod_odvetvi ='S' and mezirocni_zmeny = 'Pokles'; -- postupně si budu přehazovat písmena, kódu odvětví, abych mohla udělat zhodnocení jednotlivých sektorů.

-- Pro všechny výše uvedené jsou data mezi lety 2000 a 2021, rok 2000 u všech bylo možné srovnat, jelikož je to počáteční rok sledování průměrných mezd.

-- A (Zemědělství, lesnictví vybářství) pokles v letech 2009 a 2021.
-- B (Těžba a dobývání) pokles v letech 2009, 2013, 2014 a 2016.
-- C (Zpracovatelský průmysl) nemá evidovaný pokles mezd.
-- D (Výroba a rozvod elektřiny, plynu, tepla a klimatiz. vzduchu) pokles v letech 2013 a 2015.
-- E (Zásobování vodou; činnosti související s odpady a sanacemi) pokles v roce 2013.
-- F (Stavebnictví) pokles v letech 2013 a 2021.
-- G (Velkoobchod a maloobchod; opravy a údržba motorových vozidel) pokles v roce 2013.
-- H (Doprava a skladování) nemá evidovaný pokles mezd.
-- I (Ubytování, stravování a pohostinství) pokles v letech 2009, 2011, 2020.
-- J (Informační a komunikační činnosti) pokles v roce 2013.
-- K (Peněžnictví a pojišťovnictví) pokles v roce 2013.
-- L (Činnosti v oblasti nemovitostí) pokles v letech 2013, 2020.
-- M (Profesní, vědecké a technické činnosti) pokles v letech 2010, 2013.
-- N (Administrativní a podpůrné činnosti) 2013.
-- O (Veřejná správa a obrana; povinné sociální zabezpečení) pokles v letech 2010, 2011, 2021.
-- P (Vzdělávání) pokles v letech 2010, 2021.
-- Q (Zdravotní a sociální péče) nemá evidovaný pokles mezd.
-- R (Kulturní, zábavní a rekreační činnosti) pokles v letech 2011, 2013, 2021.
-- S (Ostatní činnosti) nemá evidovaný pokles mezd.


