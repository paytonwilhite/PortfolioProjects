--Select *
--From [Portfolio Project]..CovidVaccinations
--order by 3,4


--Select *
--From [Portfolio Project]..CovidDeaths
--Where continent is not null
--order by 3,4

--Select Data to be used

----Select location, date, total_cases, new_cases, total_deaths, population
--From [Portfolio Project]..CovidDeaths
--Order by 1,2

--Looking at Total Cases vs Total Deaths
--Shows likelihood of dying if you contract covid in your country
Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as 'DeathPercentage'
From [Portfolio Project]..CovidDeaths
Where continent is not null
Order by 1,2

--Total cases vs population
--Shows what percentage of the population has contracted covid by day
Select location, date, population, total_cases, (total_cases/population)*100 as 'InfectionPercentage'
From [Portfolio Project]..CovidDeaths
Order by 1,2

--Shows what countries have the highest infection percentage
Select location, population, max(total_cases) as HighestInfectionCount, max((total_cases/population)*100) as 'InfectionPercentage'
From [Portfolio Project]..CovidDeaths
Group by location, population
Order by InfectionPercentage desc

--Countries with highest death count
Select location, max(cast(total_deaths as int)) as DeathCount
From [Portfolio Project]..CovidDeaths
Where continent is not null
Group by location
Order by DeathCount desc

--Statistics by continent (incorrect)
--Select continent, max(cast(total_deaths as int)) as DeathCount
--From [Portfolio Project]..CovidDeaths
--Where continent is not null
--Group by continent
--Order by DeathCount desc

--Death count by continent (CORRECTED)
Select location, max(cast(total_deaths as int)) as DeathCount
From [Portfolio Project]..CovidDeaths
Where continent is null And Location not in ('World', 'High income', 'Upper middle income', 'Lower middle income', 'Low income', 'International', 'European Union')
group by location
Order by DeathCount desc

--Death count by class
Select location, max(cast(total_deaths as int)) as DeathCount
From [Portfolio Project]..CovidDeaths
Where continent is null And Location not in ('Europe', 'Asia', 'Africa', 'North America', 'South America', 'Oceania', 'World', 'European Union', 'International')
group by location
Order by DeathCount desc


--POPULATION, % OF POPULATION THAT HAS CONTRACTED COVID, TOTAL DEATHS, LIKELIHOOD OF DYING ONCE COVID IS CONTRACTED (likelihoodOfDying), 
--AND % OF POPULATION THAT HAS DIED (deathRate) FROM COVID BY CONTINENT AND COUNTRY
--Europe
Select location, max(population) as pop, (max(total_cases/population))*100 as infectionRate,  max(cast(total_deaths as int)) as deaths, (max(cast(total_deaths as int))/max(total_cases))*100 as likelihoodOfDying,
(max(cast(total_deaths as int))/max(population))*100 as deathRate
From [Portfolio Project]..CovidDeaths
where continent = 'Europe' and total_cases is not null
group by location
order by 2 desc

--North America
Select location, max(population) as pop, (max(total_cases/population))*100 as infectionRate,  max(cast(total_deaths as int)) as deaths, (max(cast(total_deaths as int))/max(total_cases))*100 as likelihoodOfDying,
(max(cast(total_deaths as int))/max(population))*100 as deathRate
From [Portfolio Project]..CovidDeaths
where continent = 'North America'
group by location
order by 2 desc

--Asia
Select location, max(population) as pop, (max(total_cases/population))*100 as infectionRate,  max(cast(total_deaths as int)) as deaths, (max(cast(total_deaths as int))/max(total_cases))*100 as likelihoodOfDying,
(max(cast(total_deaths as int))/max(population))*100 as deathRate
From [Portfolio Project]..CovidDeaths
where continent = 'Asia'
group by location
order by 2 desc

--South America
Select location, max(population) as pop, (max(total_cases/population))*100 as infectionRate,  max(cast(total_deaths as int)) as deaths, (max(cast(total_deaths as int))/max(total_cases))*100 as likelihoodOfDying,
(max(cast(total_deaths as int))/max(population))*100 as deathRate
From [Portfolio Project]..CovidDeaths
where continent = 'South America'
group by location
order by 2 desc

--Africa
Select location, max(population) as pop, (max(total_cases/population))*100 as infectionRate,  max(cast(total_deaths as int)) as deaths, (max(cast(total_deaths as int))/max(total_cases))*100 as likelihoodOfDying,
(max(cast(total_deaths as int))/max(population))*100 as deathRate
From [Portfolio Project]..CovidDeaths
where continent = 'Africa'
group by location
order by 2 desc

--Oceania
Select location, max(population) as pop, (max(total_cases/population))*100 as infectionRate,  max(cast(total_deaths as int)) as deaths, (max(cast(total_deaths as int))/max(total_cases))*100 as likelihoodOfDying,
(max(cast(total_deaths as int))/max(population))*100 as deathRate
From [Portfolio Project]..CovidDeaths
where continent = 'Oceania'
group by location
order by 2 desc

--GLOBAL CASES, DEATHS, LIKELIHOOD OF DYING IF COVID IS CONTRACTED (likelihoodOfDeath) BY DAY
select date, sum(new_cases) as cases, sum(cast(new_deaths as int)) as deaths, (sum(cast(new_deaths as int))/sum(new_cases))*100 as likelihoodOfDeath
from [Portfolio Project]..CovidDeaths
where continent is not null
group by date
order by 1,2

--**VACCINATION DATA**--

select *
from [Portfolio Project]..CovidDeaths as dea
Join [Portfolio Project]..CovidVaccinations as vac
	On dea.location = vac.location And dea.date = vac.date
	where dea.location = 'United States'

--Overall vaccinations by day
--select dea.continent, dea.location, dea.date, dea.population, cast(vac.new_vaccinations as bigint) as new_vaccinations,
--(sum(convert(bigint, vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.date)) as rolling_vaccinations,
--(max(rolling_vaccinations)/population)*100
--from [Portfolio Project]..CovidDeaths as dea
--Join [Portfolio Project]..CovidVaccinations as vac
--	On dea.location = vac.location And dea.date = vac.date
--where dea.continent is not null
--order by 2,3

--Using CTE to find Vaccination Rate by Country (INCORRECT)
--With PopvsVac (continent, location, date, population, new_vaccinations, rolling_vaccinations)
--as
--(
--select dea.continent, dea.location, dea.date, dea.population, cast(vac.new_vaccinations as bigint) as new_vaccinations,
--(sum(convert(bigint, vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.date)) as rolling_vaccinations
----(max(rolling_vaccinations)/population)*100
--from [Portfolio Project]..CovidDeaths as dea
--Join [Portfolio Project]..CovidVaccinations as vac
--	On dea.location = vac.location And dea.date = vac.date
--where dea.continent is not null
----order by 2,3
--)
--select *, (rolling_vaccinations/population)*100 as percent_vaxxed
--From PopvsVac

--Using CTE to find Vaccination Rate by Country (CORRECTED)
With PopvsVac (continent, location, date, population, people_fully_vaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, cast(vac.people_fully_vaccinated as bigint) as people_fully_vaccinated
from [Portfolio Project]..CovidDeaths as dea
Join [Portfolio Project]..CovidVaccinations as vac
	On dea.location = vac.location And dea.date = vac.date
where dea.continent is not null
)
select *, (people_fully_vaccinated/population)*100 as percent_vaxxed
From PopvsVac
where location = 'United States'
order by location, date

--TEMP TABLE
Drop table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
Rolling_vaccinations numeric
)

Insert into #PercentPopulationVaccinated
select dea.continent, dea.location, dea.date, dea.population, cast(vac.new_vaccinations as bigint) as new_vaccinations,
(sum(convert(bigint, vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.date)) as rolling_vaccinations
--(max(rolling_vaccinations)/population)*100
from [Portfolio Project]..CovidDeaths as dea
Join [Portfolio Project]..CovidVaccinations as vac
	On dea.location = vac.location And dea.date = vac.date
where dea.continent is not null
--order by 2,3

select *, (rolling_vaccinations/population)*100 as percent_vaxxed
From #PercentPopulationVaccinated



--CREATING VIEW TO STORE DATE FOR LATER VISUALIZATIONS
Use [Portfolio Project]
GO
Create View PercentPopulationVaccinated as
select dea.continent, dea.location, dea.date, dea.population, cast(vac.new_vaccinations as bigint) as new_vaccinations,
(sum(convert(bigint, vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.date)) as rolling_vaccinations
--(max(rolling_vaccinations)/population)*100
from [Portfolio Project]..CovidDeaths as dea
Join [Portfolio Project]..CovidVaccinations as vac
	On dea.location = vac.location And dea.date = vac.date
where dea.continent is not null