Projekt Životní uroveň v ČR - Analýza dostupnosti základních potravin a vývoj mezd

V tomto projekt se zaměřujeme na srovnání dat v letech 2006 až 2018. Zjišťujeme, jaké množství ukázkových potravin je možné nakoupit za průměrnou mzdu, zaměřujeme se na vývoj mezd v letech a hledáme potravinu s nejpomalejším nárůstem ceny během let. Porovnáváme meziroční změny ve mzdách a potravinách a zjiťujeme, zda v některém roce byl u některé kategorie nárůst ceny výrazně vyšší. V neposlední řadě porovnáváme údaje o HDP v České republice a snažíme se odpovědět zda jeho změny mají vliv na ceny a mzdy.

Zdrojové tabulky, které byli využity pro zpracování projektu jsou:
- czechia_price -> ceny potravin v letech rozdělených podle kódů potravin
- czechia_price_category -> pomocná tabulka s přehledem názvů potravin a jejich jednotek
- czechia_payroll -> přehled mezd dle kategorií a let
- czechia_payroll_industry_branch -> názvy kategorii odvětví dle kódů
- economies -> data o HDP, GINI a populaci evropských států
- countries -> základní infrormace o státech (poloha, kontinent, náboženství, měna, apod.)

Projekt se skládá z 5ti stěžejních otázek, na které odpovídáme s využitím výše uvedených zdrojových tabulek. Výsledkem je 5 SQL souborů, kdy každý odpovídá na jednu z otázek. 
Byly vytvořeny také 2 stěžejní tabulky s daty - t_lucie_darmovzalova_project_SQL_primary_final (obsahuje srovnání průměrných mezd a průměrných cen potravin během let a kategoríí potravin) a t_lucie_darmovzalova_project_SQL_secondary_final (obsahuje údaje o hdp, gini a populaci evropských států). Tyto tabulky jsou dále využity pro zpracování odpovědí na hlavní otázky.

Sledovaným obdobím ve všech otázkách jsou roky 2006 až 2018.

Každý z uložených SQL skripů obsahuje zadání/ otázku, postup, popis mezivýsledků a na konci odpověď. 

Poznámky na konec:
Zpracování projektu pro mě byla opravdu výzva, čím více jsem uvažovala nad zpracováním, tím složitější se mi zadání zdálo. Rozložení na menší části a postupné zpracování mi pomohlo. Překvapivá pro mě byla třetí otázka, kde jsem si v průběhu zpracování uvědomila, že se dá odpovědět dvěma způsoby, podle toho jaká data chci vidět.
