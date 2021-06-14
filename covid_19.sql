Select * From project.covid19
Where continent is not null 
order by 3,4;

Select Location, date, total_cases, new_cases, total_deaths, population From project.covid19
Where continent is not null 
order by 1,2;

Select Location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From project.covid19
Where location like '%states%'
and continent is not null 
order by 1,2;

Select Location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From project.covid19
order by 1,2;

Select Location, date, Population, total_cases,  (total_cases/population)*100 as PercentPopulationInfected
From project.covid19
order by 1,2;

Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From project.covid19
Group by Location, Population
order by PercentPopulationInfected desc;

Select Location, MAX((Total_deaths)) as TotalDeathCount
From project.covid19 
Group by Location
order by TotalDeathCount desc;

Select continent, MAX((Total_deaths)) as TotalDeathCount
From project.covid19
Where continent is not null 
Group by continent
order by TotalDeathCount desc;


Select SUM(new_cases) as total_cases, SUM((new_deaths)) as total_deaths, SUM((new_deaths))/SUM(New_Cases)*100 as DeathPercentage
From project.covid19
where continent is not null 
order by 1,2;

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(vac.new_vaccinations) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From project.covid19 dea
Join portfolioproject.covidvaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3;

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
From portfolioproject.coviddeaths dea
Join portfolioproject.covidvaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 

)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac;


DROP Table if exists PercentPopulationVaccinated;
Create Table PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
);

Insert into PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(vac.new_vaccinations) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated

From portfolioproject.coviddeaths dea
Join portfolioproject.covidvaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date;


Select *, (RollingPeopleVaccinated/Population)*100
From PercentPopulationVaccinated;


Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(vac.new_vaccinations) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From portfolioproject.coviddeaths dea
Join portfolioproject.covidvaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null;