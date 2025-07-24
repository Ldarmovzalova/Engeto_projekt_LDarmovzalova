-- Vytvoření pomocné tabulky secundary pro následnou práci s daty

select 
	min (year) as prvni_rok, 
	max (year) as posledni_rok,
	country
from economies
group by country; -- první rok 1960 a poslední rok 2020,

-- potřebuju data pro stejné období jako pro CZ, takže potřebuju jen období 2006-2018


-- vytvoření pomocné přehledové tabulky pro státy evropy 
create table t_lucie_darmovzalova_project_SQL_secondary_final as 
	select
		c.country,
		c.region_in_world,
		e.year,
		e.gdp,
		e.gini,
		e.population
	from countries c
	join economies as e on c.country = e.country
	where c.region_in_world like '%Europe' and year between 2006 and 2018
	order by country asc, year asc;

select *
from t_lucie_darmovzalova_project_SQL_secondary_final; -- kontrola vytvořené tabulky
	