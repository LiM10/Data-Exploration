SELECT *
FROM PortfolioProject..CovidDeaths$ 

SELECT *
FROM PortfolioProject..CovidVaccinations$

SELECT location, date, population, total_cases, total_deaths,
		ROUND((total_deaths/total_cases)*100,2) AS death_vs_case_pct,
		ROUND((total_deaths/population)*100,2) AS death_vs_pop_pct
FROM PortfolioProject..CovidDeaths$ 
WHERE location like '%baijan%'
ORDER BY location, date;

-- Maximum Total Cases and Total Deaths on the Continents
SELECT continent, MAX(total_cases) AS max_total_cases, MAX(CAST(total_deaths AS int)) AS max_total_deaths
		--MAX(ROUND((total_deaths/total_cases)*100,2)) AS death_vs_case_pct, 
		--MAX(ROUND((total_deaths/population)*100,2)) AS death_vs_pop_pct
FROM PortfolioProject..CovidDeaths$ 
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY max_total_cases DESC, max_total_deaths DESC

-- Maximum total case and maximum total death by countries in selected continent
SELECT location, MAX(total_cases) AS max_total_case, MAX(CAST(total_deaths AS int)) AS max_total_death
FROM PortfolioProject..CovidDeaths$
WHERE continent = 'Europe' AND COALESCE(total_cases, total_deaths) IS NOT NULL
GROUP BY location
ORDER BY location;

-- Maximum total case and maximum total death by years in selected countries
SELECT YEAR(date) AS year, MAX(total_cases) AS max_total_case, MAX(CAST(total_deaths AS int)) AS max_total_death
FROM PortfolioProject..CovidDeaths$
WHERE location = 'Azerbaijan' AND COALESCE(total_cases, total_deaths) IS NOT NULL
GROUP BY YEAR(date)
ORDER BY year;

-- Maximum case rate and death rate by countries in selected continent
SELECT location, 
				 MAX(population) AS population,
				 MAX(total_cases) AS max_total_cases, 
				 MAX(ROUND(total_cases/population*100, 2)) AS max_case_rate,
				 MAX(CAST(total_deaths AS int)) AS max_total_deaths, 
				 MAX(ROUND(CAST(total_deaths AS int)/population*100, 2)) AS max_death_rate
FROM PortfolioProject..CovidDeaths$
WHERE continent = 'Asia' AND COALESCE(total_cases, total_deaths) IS NOT NULL
GROUP BY location
ORDER BY max_case_rate DESC, max_death_rate DESC; 


-- tests and vaccinations per population by countries
SELECT vaccin.location, 
		MAX(population) AS population,
		MAX(CAST(vaccin.total_tests AS int)) AS max_total_tests, 
		MAX(CAST(vaccin.total_vaccinations AS int)) max_total_vaccinations,
		ROUND(MAX(CAST(vaccin.total_tests AS int)/population*100),2) AS test_per_pop,
		ROUND(MAX(CAST(vaccin.total_vaccinations AS int)/population*100),2) AS vaccination_per_pop
		--MAX(vaccin.life_expectancy) AS life_expectancy, 
		--MAX(vaccin.human_development_index) AS human_development_index
FROM PortfolioProject..CovidVaccinations$ vaccin
INNER JOIN PortfolioProject..CovidDeaths$ death
ON vaccin.location = death.location
WHERE vaccin.total_tests IS NOT NULL AND vaccin.total_vaccinations IS NOT NULL AND vaccin.human_development_index IS NOT NULL
GROUP BY vaccin.location
ORDER BY vaccination_per_pop DESC


SELECT vaccin.location, 
		MAX(population) AS population,
		ROUND(MAX(CAST(vaccin.total_tests AS int)/population*100),2) AS test_per_pop,
		ROUND(MAX(CAST(vaccin.total_vaccinations AS int)/population*100),2) AS vaccination_per_pop,
		MAX(ROUND(death.total_cases/population*100, 2)) AS max_case_rate,
		MAX(ROUND(CAST(total_deaths AS int)/population*100, 2)) AS max_death_rate
FROM PortfolioProject..CovidVaccinations$ vaccin
INNER JOIN PortfolioProject..CovidDeaths$ death
ON vaccin.location = death.location
WHERE vaccin.total_tests IS NOT NULL AND vaccin.total_vaccinations IS NOT NULL AND vaccin.human_development_index IS NOT NULL
GROUP BY vaccin.location
ORDER BY vaccination_per_pop DESC




