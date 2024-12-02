
--Select * 
--FROM PortfolioProject_Covid.dbo.CovidDeaths
--Order by 3,4;

--Select * 
--FROM PortfolioProject_Covid.dbo.CovidVaccination
--Where continent is not null
--Order by 3,4;

--Select Data that we are going to be using
SELECT 
    location,
    date,
    total_cases,
    total_deaths,
    CASE 
        WHEN total_cases = 0 THEN 0
        ELSE CAST(total_deaths AS FLOAT) / total_cases * 100
    END AS DeathPercentage
FROM 
    PortfolioProject_Covid.dbo.CovidDeaths
Where continent is not null
ORDER BY 
    location, date;


--Looking at Total cases Vs Total Deaths
--Shows likelihood of drying if you contract covid in your country
SELECT 
    location,
    date,
    total_cases,
    total_deaths,
    CASE 
        WHEN total_cases = 0 THEN 0
        ELSE CAST(total_deaths AS FLOAT) / total_cases * 100
    END AS DeathPercentage
FROM 
    PortfolioProject_Covid.dbo.CovidDeaths
Where location like '%thai%'
and continent is not null
ORDER BY 
    location, date;

--looking at Total cases Vs Population
--Shows what percentage of population got covid
SELECT 
    location,
    date,population,
    total_cases,
  
    CASE 
        WHEN total_cases = 0 THEN 0
        ELSE CAST(total_cases AS FLOAT) / population * 100
    END AS PercentagePopulationInfected
FROM 
    PortfolioProject_Covid.dbo.CovidDeaths
--Where location like '%thai%'
ORDER BY 
    location, date;

-- Looking at Counties with  Highest Infection Rate Compare to Population
SELECT 
    location,
    population,
    Max(total_cases) as HighestInfectionCount , Max(total_cases) / population * 100 
	AS PercentagePopulationInfected
FROM 
    PortfolioProject_Covid.dbo.CovidDeaths
--Where location like '%thai%'
Group by location,population
ORDER BY PercentagePopulationInfected Desc;



--Check Null data in Continent Coulumn
Select * 
FROM PortfolioProject_Covid.dbo.CovidDeaths
--Where continent is not null
Order by 3,4;


-- Showing the Counties with Highest Death Cout per Population
SELECT 
    location,
    Max(cast(total_deaths as int)) as TotalDeahtCount
FROM 
    PortfolioProject_Covid.dbo.CovidDeaths
--Where location like '%thai%'
Where continent is not null
Group by location
ORDER BY TotalDeahtCount Desc;


-- Let' break thing down by continent 
SELECT 
    continent,
    Max(cast(total_deaths as int)) as TotalDeahtCount
FROM 
    PortfolioProject_Covid.dbo.CovidDeaths
--Where location like '%thai%'
Where continent is not null
Group by continent
ORDER BY TotalDeahtCount Desc;



-- show the conttinent whit the highest death count per population
 SELECT 
    continent,
    Max(cast(total_deaths as int)) as TotalDeahtCount
FROM 
    PortfolioProject_Covid.dbo.CovidDeaths
--Where location like '%thai%'
Where continent is not null
Group by continent
ORDER BY TotalDeahtCount Desc;




-- Global Numbers
SELECT 
    Sum(new_cases) as Total_cases , Sum(new_deaths) as Total_Deahts,
	CASE
		When Sum(new_cases) = 0 Then 0
		Else Sum(new_deaths)/Sum(new_cases)*100
		End AS DeathPercentage
FROM 
    PortfolioProject_Covid.dbo.CovidDeaths
--Where location like '%thai%'
Where continent is not null
--Group by date
ORDER BY 1,2;



--Replace Null in vaccination to empty 
Select * from PortfolioProject_Covid.dbo.CovidDeaths

Select * from PortfolioProject_Covid.dbo.CovidVaccination

UPDATE PortfolioProject_Covid.dbo.CovidVaccination
SET total_tests = REPLACE(total_tests, 'NULL', ' '),
	new_tests = REPLACE(new_tests, 'NULL', ' '),
	total_tests_per_thousand = REPLACE(total_tests_per_thousand, 'NULL', ' '),
	new_tests_per_thousand = REPLACE(new_tests_per_thousand, 'NULL', ' '),
	new_tests_smoothed = REPLACE(new_tests_smoothed, 'NULL', ' '),
	new_tests_smoothed_per_thousand = REPLACE(new_tests_smoothed_per_thousand, 'NULL', ' '),
	positive_rate = REPLACE(positive_rate, 'NULL', ' '),
	tests_per_case = REPLACE(tests_per_case, 'NULL', ' '),
	tests_units = REPLACE(tests_units, 'NULL', ' '),
	total_vaccinations = REPLACE(total_vaccinations, 'NULL', ' '),
	people_vaccinated = REPLACE(people_vaccinated, 'NULL', ' '),
	people_fully_vaccinated = REPLACE(people_fully_vaccinated, 'NULL', ' '),
	total_boosters = REPLACE(total_boosters, 'NULL', ' '),
	new_vaccinations = REPLACE(new_vaccinations, 'NULL', ' '),
	new_vaccinations_smoothed = REPLACE(new_vaccinations_smoothed, 'NULL', ' '),
	total_vaccinations_per_hundred = REPLACE(total_vaccinations_per_hundred, 'NULL', ' '),
	people_vaccinated_per_hundred = REPLACE(people_vaccinated_per_hundred, 'NULL', ' '),
	people_fully_vaccinated_per_hundred = REPLACE(people_fully_vaccinated_per_hundred, 'NULL', ' '),
	total_boosters_per_hundred = REPLACE(total_boosters_per_hundred, 'NULL', ' '),
	new_vaccinations_smoothed_per_million = REPLACE(new_vaccinations_smoothed_per_million, 'NULL', ' '),
	new_people_vaccinated_smoothed = REPLACE(new_people_vaccinated_smoothed, 'NULL', ' '),
	new_people_vaccinated_smoothed_per_hundred = REPLACE(new_people_vaccinated_smoothed_per_hundred, 'NULL', ' '),
	extreme_poverty = REPLACE(extreme_poverty, 'NULL', ' '),
	female_smokers = REPLACE(female_smokers, 'NULL', ' '),
	male_smokers = REPLACE(male_smokers, 'NULL', ' '),
	excess_mortality_cumulative_absolute = REPLACE(excess_mortality_cumulative_absolute, 'NULL', ' '),
	excess_mortality_cumulative = REPLACE(excess_mortality_cumulative, 'NULL', ' '),
	excess_mortality = REPLACE(excess_mortality, 'NULL', ' '),
	excess_mortality_cumulative_per_million = REPLACE(excess_mortality_cumulative_per_million, 'NULL', ' ')

Select * from PortfolioProject_Covid.dbo.CovidVaccination

-- looking at total Pipulation vs vaccinations

Select 
    dea.continent,
    dea.location, 
    dea.date,
    dea.population,
    vac.new_vaccinations,
    Sum(COALESCE(TRY_CAST(vac.new_vaccinations AS int), 0)) OVER (Partition by dea.location order by dea.location,dea.date) 
	as RollingPeopleVaccinated
	--,(RollingPeopleVaccinated/population)*100
From 
    PortfolioProject_Covid.dbo.CovidDeaths dea
Join 
    PortfolioProject_Covid.dbo.CovidVaccination vac
    on dea.location = vac.location
    and dea.date = vac.date
Where 
    dea.continent is not null
ORDER BY 
    2, 3;


--Use CTE

With PopvsVac (continent,Location,Date,population,new_vaccinations,RollingPeopleVaccinated)
as 
(
Select 
    dea.continent,
    dea.location, 
    dea.date,
    dea.population,
    vac.new_vaccinations,
    Sum(COALESCE(TRY_CAST(vac.new_vaccinations AS int), 0)) OVER (Partition by dea.location order by dea.location,dea.date) 
	as RollingPeopleVaccinated
	--,(RollingPeopleVaccinated/population)*100
From 
    PortfolioProject_Covid.dbo.CovidDeaths dea
Join 
    PortfolioProject_Covid.dbo.CovidVaccination vac
    on dea.location = vac.location
    and dea.date = vac.date
Where 
    dea.continent is not null
--ORDER BY 2, 3
)
Select * , (RollingPeopleVaccinated/population)*100
From PopvsVac






--Temp Table
-- สร้างตารางชั่วคราว
-- ลบตารางชั่วคราวที่มีอยู่ (ถ้ามี)
IF OBJECT_ID('tempdb..#PercentagePopulationVaccinated') IS NOT NULL
    DROP TABLE #PercentagePopulationVaccinated;

-- สร้างตารางชั่วคราวใหม่
CREATE TABLE #PercentagePopulationVaccinated
(
    continent NVARCHAR(255),
    location NVARCHAR(255),
    date DATETIME,
    population NUMERIC(18, 2),
    new_vaccinations NUMERIC(18, 2),
    RollingPeopleVaccinated NUMERIC(18, 2)
);

-- แทรกข้อมูลลงในตาราง
INSERT INTO #PercentagePopulationVaccinated (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
SELECT 
    dea.continent,
    dea.location, 
    dea.date,
    TRY_CAST(dea.population AS NUMERIC(18, 2)) AS population,
    TRY_CAST(vac.new_vaccinations AS NUMERIC(18, 2)) AS new_vaccinations,
    SUM(COALESCE(TRY_CAST(vac.new_vaccinations AS NUMERIC(18, 2)), 0)) 
        OVER (PARTITION BY dea.location ORDER BY dea.date) AS RollingPeopleVaccinated
FROM 
    PortfolioProject_Covid.dbo.CovidDeaths dea
JOIN 
    PortfolioProject_Covid.dbo.CovidVaccination vac
    ON dea.location = vac.location
    AND dea.date = vac.date
WHERE 
    dea.continent IS NOT NULL;

-- ตรวจสอบข้อมูล
SELECT *, (RollingPeopleVaccinated * 1.0 / population) * 100 AS VaccinationPercentage
FROM #PercentagePopulationVaccinated;


--creating view to store data for later visualization

Create View PercentPopulationVaccinate_New  as
SELECT 
    dea.continent,
    dea.location, 
    dea.date,
    TRY_CAST(dea.population AS NUMERIC(18, 2)) AS population,
    TRY_CAST(vac.new_vaccinations AS NUMERIC(18, 2)) AS new_vaccinations,
    SUM(COALESCE(TRY_CAST(vac.new_vaccinations AS NUMERIC(18, 2)), 0)) 
        OVER (PARTITION BY dea.location ORDER BY dea.date) AS RollingPeopleVaccinated
FROM 
    PortfolioProject_Covid.dbo.CovidDeaths dea
JOIN 
    PortfolioProject_Covid.dbo.CovidVaccination vac
    ON dea.location = vac.location
    AND dea.date = vac.date
WHERE 
    dea.continent IS NOT NULL
--order by 2,3

Select * 
from PercentPopulationVaccinate_New