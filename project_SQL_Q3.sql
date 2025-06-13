-- Q3: Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?

select *
from czechia_price; -- kontrola obsahu tabulky


select
  cp.category_code AS kategorie,
  extract (year from cp.date_from) as rok,
  round (avg(cp.value)::numeric,2) as prumerna_cena_potravin
from  czechia_price as cp
join czechia_price_category cpc ON cp.category_code = cpc.code
where cp.category_code=118101
group by cp.category_code, extract (year from cp.date_from)
order by kategorie, rok; -- výpočet průměrů ceny jednotlivých kategorii potravin v každím roce, kde jsou data

-- vytvoření pomocné tabulky

create table t_lucie_darmovzalova_help_table_prumery_cen as (
	select 
		extract (year from cp.date_from) as rok,
		cp.category_code as kod,
		cpc.name as nazev,
		round (avg (cp.value)::numeric,2) as prumerna_cena_potraviny
	from czechia_price as cp
	join czechia_price_category as cpc on cp.category_code=cpc.code 
	group by cp.category_code, cpc.name, extract (year from cp.date_from));

select *
from t_lucie_darmovzalova_help_table_prumery_cen;


-- výpočet meziročních změn v cenách během let

select
    pc1.rok,
    pc1.kod,
    pc1.nazev,
    pc1.prumerna_cena_potraviny,
    pc2.prumerna_cena_potraviny AS predchozi_prumerna_cena,
    round(100.0 * (pc1.prumerna_cena_potraviny - pc2.prumerna_cena_potraviny) / nullif(pc2.prumerna_cena_potraviny, 0),2) as mezirocni_narust_procent
from t_lucie_darmovzalova_help_table_prumery_cen as pc1
join t_lucie_darmovzalova_help_table_prumery_cen as pc2 ON pc1.kod = pc2.kod AND pc1.rok = pc2.rok + 1
order by pc1.kod, pc1.rok;

-- zprůměrování vypočtených procentních pohybů cen

select
    kod,
    nazev,
    round(avg(mezirocni_narust_procent), 2) as prumerny_mezirocni_narust
from  (
    select
        pc1.rok,
        pc1.kod,
        pc1.nazev,
        pc1.prumerna_cena_potraviny,
        pc2.prumerna_cena_potraviny as predchozi_prumerna_cena,
        round(100.0 * (pc1.prumerna_cena_potraviny - pc2.prumerna_cena_potraviny) / nullif(pc2.prumerna_cena_potraviny, 0),2) as mezirocni_narust_procent
    from t_lucie_darmovzalova_help_table_prumery_cen as pc1
    join t_lucie_darmovzalova_help_table_prumery_cen as pc2 on pc1.kod = pc2.kod and pc1.rok = pc2.rok + 1) mezivysledek
group by kod, nazev
order by prumerny_mezirocni_narust asc
limit 1;


-- Kategorii, který mezi roky 2006 a 2018 zaznamenala nejmenší meziroční nárůst ceny je 118,101 Cukr krystalový, kde došlo k průměrnému nárůstu o -1,92% což značí zlevňování mezi sledovanými roky.
-- Pokud se máme doslova držet položeného dotazu, tak se na poklesy cen nemůžeme dívat a je potřeba zjistit, jaká kategorie eviduje nejmenší nárůst bez ohledu na poklesy cen.

select
    pc1.kod,
    pc1.nazev,
    round(avg(100.0 * (pc1.prumerna_cena_potraviny - pc2.prumerna_cena_potraviny) / nullif(pc2.prumerna_cena_potraviny, 0)), 2) as prumerny_mezirocni_narust
from t_lucie_darmovzalova_help_table_prumery_cen as pc1
join t_lucie_darmovzalova_help_table_prumery_cen as pc2 on pc1.kod = pc2.kod and pc1.rok = pc2.rok + 1
group by pc1.kod, pc1.nazev
having avg(100.0 * (pc1.prumerna_cena_potraviny - pc2.prumerna_cena_potraviny) / nullif(pc2.prumerna_cena_potraviny, 0)) > 0
order by prumerny_mezirocni_narust ASC
limit 1;

-- Výsledkem je kategorie 116,103 Banány žluté, které zaznamenaly nárůst o 0,81%, pokud počítáme jen s procenty většímy než 0.

