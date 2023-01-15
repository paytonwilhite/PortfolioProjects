--Totaldeaths is total estimated road deaths. Deathrate is the number of road deaths per 100,000 population.
--This project will explore the data for the year 2019 only.
select * from TrafficDeathsProject..traffic_deaths
where year = 2019

--2019 Human Development Index data, along with other income and emissions related data for each country. 
select * from TrafficDeathsProject..hdi_data

--Table with all relevant data sorted by country name.
select d.isocode, d.country, h.continent, h.hdi_group, h.hdi, d.totaldeaths, d.deathrate
from 
	TrafficDeathsProject..traffic_deaths as d
	inner join
	TrafficDeathsProject..hdi_data as h
	on d.isocode = h.iso_code
where year = 2019
order by d.country

--Using CTE to combine the two tables and explore the data.
with global_data as 
(
select d.isocode as iso, d.country as country, h.continent as continent, h.hdi_group as hdi_grp, h.hdi as hdi, d.totaldeaths as trafficdeaths, d.deathrate as trafficdeathrate
from 
	TrafficDeathsProject..traffic_deaths as d
	inner join
	TrafficDeathsProject..hdi_data as h
	on d.isocode = h.iso_code
where d.year = 2019
)
select * from global_data

--Countries with the HIGHEST TrafficDeathRate.
with global_data as 
(
select d.isocode as iso, d.country as country, h.continent as continent, h.hdi_group as hdi_grp, h.hdi as hdi, d.totaldeaths as trafficdeaths, d.deathrate as trafficdeathrate
from 
	TrafficDeathsProject..traffic_deaths as d
	inner join
	TrafficDeathsProject..hdi_data as h
	on d.isocode = h.iso_code
where d.year = 2019
)
select country, continent, hdi, hdi_grp, trafficdeathrate
from global_data
order by trafficdeathrate desc

--Average HDI and TrafficDeathRate by Continent, sorted by TrafficDeathRate DESCENDING.
with global_data as 
(
select d.isocode as iso, d.country as country, h.continent as continent, h.hdi_group as hdi_grp, h.hdi as hdi, d.totaldeaths as trafficdeaths, d.deathrate as trafficdeathrate
from 
	TrafficDeathsProject..traffic_deaths as d
	inner join
	TrafficDeathsProject..hdi_data as h
	on d.isocode = h.iso_code
where d.year = 2019
)
select continent, round(avg(hdi), 2) as avg_hdi, round(avg(trafficdeathrate), 2) as avg_trafficdeathrate
from global_data
group by continent
order by 3 desc

--Average HDI and TrafficDeathRate for each HDI group, sorted by TrafficDeathRate DESCENDING.
with global_data as 
(
select d.isocode as iso, d.country as country, h.continent as continent, h.hdi_group as hdi_grp, h.hdi as hdi, d.totaldeaths as trafficdeaths, d.deathrate as trafficdeathrate
from 
	TrafficDeathsProject..traffic_deaths as d
	inner join
	TrafficDeathsProject..hdi_data as h
	on d.isocode = h.iso_code
where d.year = 2019
)
select hdi_grp, round(avg(hdi), 2) as avg_hdi, sum(trafficdeaths) as totaltrafficdeaths, round(avg(trafficdeathrate), 2) as avg_trafficdeathrate
from global_data
group by hdi_grp
order by 4 desc

--Countries that are Very Highly Developed with HIGHEST TrafficDeathRate
with global_data as 
(
select d.isocode as iso, d.country as country, h.continent as continent, h.hdi_group as hdi_grp, h.hdi as hdi, d.totaldeaths as trafficdeaths, d.deathrate as trafficdeathrate
from 
	TrafficDeathsProject..traffic_deaths as d
	inner join
	TrafficDeathsProject..hdi_data as h
	on d.isocode = h.iso_code
where d.year = 2019
)
select * from global_data
where hdi_grp = 'Very High'
order by trafficdeathrate desc

--Countries that are Very Highly Developed with LOWEST TrafficDeathRate
with global_data as 
(
select d.isocode as iso, d.country as country, h.continent as continent, h.hdi_group as hdi_grp, h.hdi as hdi, d.totaldeaths as trafficdeaths, d.deathrate as trafficdeathrate
from 
	TrafficDeathsProject..traffic_deaths as d
	inner join
	TrafficDeathsProject..hdi_data as h
	on d.isocode = h.iso_code
where d.year = 2019
)
select * from global_data
where hdi_grp = 'Very High'
order by trafficdeathrate

--Countries that are Very Highly Developed with the MOST amount of TrafficDeaths
with global_data as 
(
select d.isocode as iso, d.country as country, h.continent as continent, h.hdi_group as hdi_grp, h.hdi as hdi, d.totaldeaths as trafficdeaths, d.deathrate as trafficdeathrate
from 
	TrafficDeathsProject..traffic_deaths as d
	inner join
	TrafficDeathsProject..hdi_data as h
	on d.isocode = h.iso_code
where d.year = 2019
)
select * from global_data
where hdi_grp = 'Very High'
order by trafficdeaths desc

--Countries that are Very Highly Developed with the LEAST amount of TrafficDeaths
with global_data as 
(
select d.isocode as iso, d.country as country, h.continent as continent, h.hdi_group as hdi_grp, h.hdi as hdi, d.totaldeaths as trafficdeaths, d.deathrate as trafficdeathrate
from 
	TrafficDeathsProject..traffic_deaths as d
	inner join
	TrafficDeathsProject..hdi_data as h
	on d.isocode = h.iso_code
where d.year = 2019
)
select * from global_data
where hdi_grp = 'Very High'
order by trafficdeaths

--Countries in North America, Europe, and Oceania that are Very Highly Developed with the HIGHEST TrafficDeathRate
with global_data as 
(
select d.isocode as iso, d.country as country, h.continent as continent, h.hdi_group as hdi_grp, h.hdi as hdi, d.totaldeaths as trafficdeaths, d.deathrate as trafficdeathrate
from 
	TrafficDeathsProject..traffic_deaths as d
	inner join
	TrafficDeathsProject..hdi_data as h
	on d.isocode = h.iso_code
where d.year = 2019
)
select * from global_data
where hdi_grp = 'Very High' and continent in ('North America', 'Europe', 'Oceania')
order by trafficdeathrate desc

with global_data as 
(
select d.isocode as iso, d.country as country, h.continent as continent, h.hdi_group as hdi_grp, h.hdi as hdi, d.totaldeaths as trafficdeaths, d.deathrate as trafficdeathrate
from 
	TrafficDeathsProject..traffic_deaths as d
	inner join
	TrafficDeathsProject..hdi_data as h
	on d.isocode = h.iso_code
where d.year = 2019
)
select * from global_data