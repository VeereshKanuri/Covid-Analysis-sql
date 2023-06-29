select * from  covidProject..covidDeaths
where continent is not null
order by 3,4

select * from covidProject..CovidVaccinations
order by 3,4

select location,date,total_cases,new_cases,total_deaths,population 
from covidProject..covidDeaths
where continent is not null
order by 1,2

select location,date,total_cases,population,(total_cases/population)*100 as efffected_percent
from covidProject..covidDeaths
where continent is not null
and location = 'china'
order by 1,2

select location,population,max(total_cases) as total_cases,max((total_cases/population))*100 as percent_pop_infected
from covidProject..covidDeaths
where continent is not null
group by location,population
order by percent_pop_infected desc

select location,population,max(cast(total_deaths as int)) as total_deaths
from covidProject..covidDeaths
where continent is not null
group by location,population
order by total_deaths desc

select location,population,max(cast(total_deaths as int)) as total_deaths,max((total_deaths/population))*100 as percent_pop_died
from covidProject..covidDeaths
where continent is not null
group by location,population
order by percent_pop_died desc

select continent,max(cast(total_deaths as int)) as high_tot_deaths
from covidProject..covidDeaths
where continent is not null
group by continent


select location,max(cast(total_deaths as int)) as high_tot_deaths
from covidProject..covidDeaths
group by location


select date,sum(new_cases) as total_cases,sum(cast(new_deaths as int)) as total_deaths, (sum(cast(new_deaths as int))/sum(new_cases)) as death_percent
from covidProject..covidDeaths
where continent is not null
group by date
order by 1,2

select * from covidProject..covidDeaths
join covidProject..CovidVaccinations on covidProject..covidDeaths.location=covidProject..CovidVaccinations.location and covidProject..covidDeaths.date=covidProject..CovidVaccinations.date


select cd.continent,cd.location,cd.date,cv.new_vaccinations,cd.population  from covidProject..covidDeaths cd
join covidProject..CovidVaccinations cv on 
cd.location=cv.location and cd.date=cv.date
where cd.continent is not null
order by 1,2,3

select cd.continent,cd.location,cd.date,cv.new_vaccinations,cd.population  from covidProject..covidDeaths cd
join covidProject..CovidVaccinations cv on 
cd.location=cv.location and cd.date=cv.date
where cd.continent is not null
order by 2,3

select cd.continent,cd.location,cd.date,cv.new_vaccinations,cd.population,
sum(cast(cv.new_vaccinations as int)) over (partition by cv.location order by cv.location,cd.date) as total_vaccinations  from covidProject..covidDeaths cd
join covidProject..CovidVaccinations cv on 
cd.location=cv.location and cd.date=cv.date
where cd.continent is not null
order by 2,3


with popVSvacc (Continent,location,Date,New_vaccinations,Population,Running_total_vaccinations) as
(
select cd.continent,cd.location,cd.date,cv.new_vaccinations,cd.population,
sum(cast(cv.new_vaccinations as int)) over (partition by cv.location order by cv.location,cd.date) as total_vaccinations  from covidProject..covidDeaths cd
join covidProject..CovidVaccinations cv on 
cd.location=cv.location and cd.date=cv.date
where cd.continent is not null
)
select*, (Running_total_vaccinations/Population)*100 from popVSvacc

drop table if exists pop_vaccinated 
create table pop_vaccinated (Continent nVarchar(120),Location nVarchar(120),Date datetime, population numeric,new_vaccinations numeric,RollingVaccinatedTotal numeric)

insert into pop_vaccinated 

select cd.continent,cd.location,cd.date,cv.new_vaccinations,cd.population,
sum(cast(cv.new_vaccinations as int)) over (partition by cv.location order by cv.location,cd.date) as total_vaccinations  from covidProject..covidDeaths cd
join covidProject..CovidVaccinations cv on 
cd.location=cv.location and cd.date=cv.date
where cd.continent is not null

select * from pop_vaccinated 


create view percpopulationvaccinated as 
select cd.continent,cd.location,cd.date,cv.new_vaccinations,cd.population,
sum(cast(cv.new_vaccinations as int)) over (partition by cv.location order by cv.location,cd.date) as total_vaccinations  from covidProject..covidDeaths cd
join covidProject..CovidVaccinations cv on 
cd.location=cv.location and cd.date=cv.date
where cd.continent is not null


