Select *
From PortfolioProject..['covid_death(2)$']
Where continent is not null 
order by 3,4


-- Select Data that we are going to be starting with

Select location, date, total_cases, new_cases, total_deaths,population
From portfolioproject..['covid_death(2)$']
Where continent is not null 
order by 1,2


-- Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract covid in your country

Select Location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From portfolioproject..['covid_death(2)$']
Where location like '%India%'
and continent is not null 
order by 1,2

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
   SUM(CONVERT(Int,vac.new_vaccinations)) OVER (Partition by dea.location ORDER BY dea.location, dea.date) as people_vacc
from portfolioproject..['covid_death(2)$'] as dea
join portfolioproject..['owid-covid-data (1)$']  as vac
on dea.location = vac.location
and vac.date = dea.date
where dea.continent is not null
order by 1,2,3 

--use CTE
with popvsVac (location, date, population, new_vaccination, continent, people_vacc)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
   SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location ORDER BY dea.location, dea.date) as people_vacc
from portfolioproject..['covid_death(2)$'] as dea
join portfolioproject..['owid-covid-data (1)$']  as vac
on dea.location = vac.location
and vac.date = dea.date
where dea.continent is not null
--order by 1,2,3 
)
select *
from popvsVsc

-- TEMP TABLE
drop table if exists percentpopulationvacc
create table percentpopulationvacc
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
people_vacc numeric
)

insert into
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
   SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location ORDER BY dea.location, dea.date) as people_vacc
from portfolioproject..['covid_death(2)$'] as dea
join portfolioproject..['owid-covid-data (1)$']  as vac
on dea.location = vac.location
and vac.date = dea.date
where dea.continent is not null
order by 1,2,3 





