-- Q2: Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?

select *
from t_lucie_darmovzalova_project_SQL_primary_final
limit 5; -- kontrola dat v tabulce

select
	rok,
	nazev_potraviny,
	prumerna_cena,
	prumerna_mzda,
	round (prumerna_mzda/prumerna_cena) as mozno_koupit_jednotek
from t_lucie_darmovzalova_project_SQL_primary_final
where rok = (
		select
			min(rok)
		from t_lucie_darmovzalova_project_SQL_primary_final) -- vyber mii minimální hodnotu pro rok z tabulky
	or rok = (
		select
			max (rok)
		from t_lucie_darmovzalova_project_SQL_primary_final) -- vyber mi maximální hodnotu z tabulky pro rok
group by rok,nazev_potraviny, prumerna_cena, prumerna_mzda
order by rok asc;

-- Prvním společným obdobím pro mléko a chleba je rok 2006 s průměrnou průmernou mzdou napříč odvětními pro tento rok (20,677.44Kč) je možné koupit 1,432kg chleba a 1,283 litrů mléka.
-- Posledním společným obdobím je rok 2018, kde byla průměrná mzda za všechny sledovaná odvětví 32,485.09Kč za což se dá koupit 1,639ks chleba a 1.340 litrů mléka.

-- V roce 2018 lze koupit o 14,5% více chleba, než v roce 2006
-- Mléka lze v roce 2018 nakoupit i 4,4% více než v roce 2006.
