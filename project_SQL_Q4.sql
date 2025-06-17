-- Q4: Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?

select *
from t_lucie_darmovzalova_project_sql_primary_final tldpspf
limit 10; -- kontrola obsahu tabulky

-- musím si spočítat celkový průměr cen potravin za rok, protože průměr mezd po letech už mám

select
	rok,
	round(avg(prumerna_cena_potravin):: numeric, 2) as prum_cena_potravin_rok,
	min (prumerna_mzda) as prum_mzda_rok
from t_lucie_darmovzalova_project_sql_primary_final tldpspf 
group by rok
order by rok;


-- vytvoření přehledu s vyjádřenými procenty změn v cenách potravin a ve mzdách

with rocni_prehled as (
    select
        rok,
        round(avg(prumerna_cena_potravin)::numeric, 2) as prum_cena_potravin_rok,
        min(prumerna_mzda) as prum_mzda_rok
    from t_lucie_darmovzalova_project_sql_primary_final
    group by rok),
mezirocni_narust as (
    select
        t1.rok as aktualni_rok,
        t2.rok as predchozi_rok,
        round(((t1.prum_cena_potravin_rok - t2.prum_cena_potravin_rok) / t2.prum_cena_potravin_rok) * 100, 2) as narust_cen_v_procentech,
        round(((t1.prum_mzda_rok - t2.prum_mzda_rok) / t2.prum_mzda_rok) * 100, 2) as narust_mezd_v_procentech
    from rocni_prehled t1
    join rocni_prehled t2 on t1.rok = t2.rok + 1
)
select *
from mezirocni_narust
order by aktualni_rok;



-- Musím spočítat nárůst cen potravin a mezd v procentech
-- vypočítat rozdíl mezi procenty cen protravin a procenty mezd
-- najít rozdíl větší než 10

with rocni_prehled as(
	select
		rok,
		round(avg(prumerna_cena_potravin):: numeric, 2) as prum_cena_potravin_rok,
		min (prumerna_mzda) as prum_mzda_rok
	from t_lucie_darmovzalova_project_sql_primary_final 
	group by rok)
	select
		rp1.rok,
		round(((rp1.prum_cena_potravin_rok - rp2.prum_cena_potravin_rok) / rp2.prum_cena_potravin_rok) * 100, 2) as rust_cen_procenta,
		round(((rp1.prum_mzda_rok - rp2.prum_mzda_rok) / rp2.prum_mzda_rok) * 100, 2) as rust_mezd_procenta,
		round ((((rp1.prum_cena_potravin_rok - rp2.prum_cena_potravin_rok) / rp2.prum_cena_potravin_rok) * 100)-(((rp1.prum_mzda_rok - rp2.prum_mzda_rok) / rp2.prum_mzda_rok) * 100),2) as rozdil
	from rocni_prehled as rp1
	join rocni_prehled as rp2 on rp1.rok = rp2.rok+1
	where (
        ((rp1.prum_cena_potravin_rok - rp2.prum_cena_potravin_rok) / rp2.prum_cena_potravin_rok) * 100
        -
        ((rp1.prum_mzda_rok - rp2.prum_mzda_rok) / rp2.prum_mzda_rok) * 100
    ) > 10
	order by rp1.rok;

-- Výsledek je nula (tabulka nic nezobrazila), znamená to tedy, že není rok, kde by meziroční nárůst cen vyšší než 10% oproti nárůstu mezd.

	
