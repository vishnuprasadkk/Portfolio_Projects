
/* checking the structure of the tables */
SELECT 
    *
FROM
    covid_vaccinations
LIMIT 100;
SELECT 
    *
FROM
    covid_deaths
LIMIT 100;

/*Selecting some data from the table*/

SELECT 
    location,
    continent,
    date,
    total_cases,
    new_cases,
    total_deaths,
    population
FROM
    covid_deaths
;


/*Total cases vs Total deaths and death rate. Shows the chances of dying if you get covid in your country*/

SELECT 
    location,
    date,
    total_cases,
    total_deaths,
    (total_deaths / total_cases) * 100 AS death_rate
FROM
    covid_deaths;

/*Total cases vs population and infection rate. Shows what % of the total population got covid in India and the UAE*/


SELECT 
    location,
    date,
    total_cases,
    population,
    (total_cases / population) * 100 AS infection_rate
FROM
    covid_deaths
WHERE
    location IN ('India' , 'United Arab Emirates');
    
/*Total cases vs population and infection rate. Shows what % of the total population got covid for the entire world*/

SELECT 
    location,
    date,
    total_cases,
    population,
    (total_cases / population) * 100 AS infection_rate
FROM
    covid_deaths;
    
/* Countries with the highest infection rate*/

SELECT 
    location,
    max(total_cases) as Highestinfectioncount,
    population,
	max((total_cases/ population))*  100 AS infection_rate
FROM
    covid_deaths
GROUP BY 
	location,population
order by infection_rate desc;

/* Countries with highest death count per population */

SELECT 
    location,
    MAX(total_deaths) AS total_death_count,
    population,
    MAX(total_deaths / population) * 100 AS max_death_per_population
FROM
    covid_deaths
WHERE
    location NOT IN ('World' , 'International',
        'vatican',
        'Oceana',
        'Upper middle income',
        'High income',
        'Europe',
        'North America',
        'Asia',
        'Lower middle income',
        'South America',
        'European Union',
        'Low income')
GROUP BY location
ORDER BY total_death_count DESC;

#Breaking things by continent(Death counts)


SELECT 
    continent,
    MAX(total_deaths) AS total_death_count,
    population,
    MAX(total_deaths / population) * 100 AS max_death_per_population
FROM
    covid_deaths
where length(continent)!=0
GROUP BY continent
ORDER BY total_death_count DESC;


/* Total cases and total deaths in the world*/

SELECT 
    SUM(new_cases) as total_cases,
    SUM(new_deaths) as total_deaths,
    SUM(new_deaths) / SUM(new_cases) * 100 AS death_percentage
FROM
    covid_deaths
WHERE
    LENGTH(continent) != 0;
    
-- population vs vaccinations

SELECT 
    d.continent,d.location,d.date,d.population,v.new_vaccinations
FROM
    covid_deaths d
        JOIN
    covid_vaccinations v ON d.location = v.location
        AND d.date = v.date
Where LENGTH(d.continent)!=0;

-- total vaccinations by country

SELECT 
    d.continent,d.location,d.population,sum(v.new_vaccinations) as total_vaccinations
FROM
    covid_deaths d
        JOIN
    covid_vaccinations v ON d.location = v.location
        AND d.date = v.date
Where LENGTH(d.continent)!=0
group by location ;

-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3


-- Using CTE to perform Calculation on Partition By in previous query

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac



-- Using Temp Table to perform Calculation on Partition By in previous query

DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null 
--order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated




-- Creating View to store data for later visualizations

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 










