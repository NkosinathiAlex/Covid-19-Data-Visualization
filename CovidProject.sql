
--Data Visualization

--Selecting all the columns from the CovidDeaths Tables
SELECT *
FROM 
PortfolioPoject..CovidDeaths;


--Selecting all the columns from the CovidVaccinations Tables
SELECT * 
FROM
PortfolioPoject..CovidDeaths;


--Selecting the data we are going to be using from the CovidDeaths Table
SELECT
location, date, total_cases, new_cases, total_deaths, population
FROM 
PortfolioPoject..CovidDeaths;

-- A query for Total Cases vs Total Deaths in South Africa
--Shows the likelihood of dying if you are in South Africa
SELECT
location, date, total_cases, new_cases, total_deaths, cast(total_deaths as Float) / cast(total_cases as float) * 100 AS DeathPercentage
FROM 
PortfolioPoject..CovidDeaths
WHERE
location = 'South Africa';

-- A query that Select the date that had highest new cases identified in South Africa
SELECT TOP 1 
date, new_cases
FROM 
PortfolioPoject..CovidDeaths
WHERE
location = 'South Africa'
ORDER BY 
new_cases  DESC;


--A query for Total Cases vs Population
--Show what percentage got covid
SELECT 
location, date, total_cases, population, cast(total_cases as Float) / cast(population as float) * 100 AS populationPercentage
FROM 
PortfolioPoject..CovidDeaths
WHERE
location = 'South Africa';


--Looking at countries with Highest Infection Rate compared to pouplation
SELECT
location, population, sum(cast( new_cases as float)) as HighestInfenctionCount, Max((total_cases/population))*100 as populationInfected
FROM
PortfolioPoject..CovidDeaths
Group by location, population
order by populationInfected DESC;

--Showing Countries with the Highest Death count per Population
SELECT
location, population, sum(cast( new_deaths as float)) Total_Deaths, Max((total_deaths/population))*100 as TotalDeathCountPercentage
FROM
PortfolioPoject..CovidDeaths
WHERE
continent is not null
Group by location, population
order by TotalDeathCountPercentage dESC;

--Selecting continents with the highest death count
SELECT 
location, Max(cast(total_deaths as int)) as TotalDeathCount
FROM
PortfolioPoject..CovidDeaths
WHERE continent is null AND location NOT  LIKE '%income%'
Group by location
order by TotalDeathCount desc;

--Global Numbers 
--Numbers for each date for new cases vs new deaths in the whole world
SELECT 
date, SUM(CAST(new_cases as float)) AS total_cases, 
SUM(CAST(new_deaths as float))  AS total_deaths, 
CASE WHEN SUM(CAST(new_cases AS float))>0
     THEN (SUM(CAST(new_deaths AS float)) / SUM(CAST(new_cases As float))) * 100
	 ELSE NULL
END AS DeathPercentage
FROM
PortfolioPoject..CovidDeaths
where continent is not null
Group by date
order by 1,2;

--Total Cases vs Total Deaths
SELECT 
 SUM(CAST(new_cases as float)) AS total_cases, 
SUM(CAST(new_deaths as float))  AS total_deaths, 
CASE WHEN SUM(CAST(new_cases AS float))>0
     THEN (SUM(CAST(new_deaths AS float)) / SUM(CAST(new_cases As float))) * 100
	 ELSE NULL
END AS DeathPercentage
FROM
PortfolioPoject..CovidDeaths
where continent is not null
order by 1,2;

--Looking at Total Population vs Vaccination
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
 SUM(CAST(vac.new_vaccinations AS Float)) OVER (PARTITION by dea.location order by dea.location, dea.date)
FROM PortfolioPoject..CovidDeaths dea
Join PortfolioPoject..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
WHERE dea.continent is not null
order by 1,2,3 ;












