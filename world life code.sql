select *
from worldlifexpectancy;

select country,year,concat(country,year), count(concat(country,year))
from worldlifexpectancy
group by country, year, concat(country,year)
having count(concat(country, year)) > 1;

Delete from worldlifexpectancy
where
     Row_id in (
     select row_id
from(
	select Row_id,
    concat(country,year),
    Row_number() over(partition by concat(country,year) order by concat(country,year))as Row_num
    from worldlifexpectancy
    ) as row_table
where row_num > 1
);  

 select distinct(country)
 from worldlifexpectancy
 where status = 'developing';
 
 update worldlifexpectancy t1
 join worldlifexpectancy t2
      on t1.country=t2.country
  set t1.status='developing'
  where t1.status =''
  and t2.status <>''
  and t2.status='developing'; 
 
 
 
 update worldlifexpectancy t1
 join worldlifexpectancy t2
      on t1.country=t2.country
  set t1.status='developed'
  where t1.status =''
  and t2.status <>''
  and t2.status='developed'; 
  
  
  select *
  from worldlifexpectancy
  where `worldlifexpectancy` = ''
  ;
  
  select t1.country, t1.year, t1.`Lifeexpectancy`,
  t2.country, t2.year, t2.`Lifeexpectancy`,
  t3.country, t3.year, t3.`Lifeexpectancy`,
  round((t2.`Lifeexpectancy`+t3.`Lifeexpectancy`) /2,1)
  from worldlifexpectancy t1
  join worldlifexpectancy t2
	on t1.country=t2.country
    and t1.year=t2.year-1
  join worldlifexpectancy t3
	on t1.country=t3.country
    and t1.year=t3.year+1
  where t1.`Lifeexpectancy`=''
;
  
  update worldlifexpectancy t1
  join worldlifexpectancy t2
	on t1.country=t2.country
    and t1.year=t2.year-1
  join worldlifexpectancy t3
	on t1.country=t3.country
    and t1.year=t3.year+1
set t1.`Lifeexpectancy`= round((t2.`Lifeexpectancy`+t3.`Lifeexpectancy`) /2,1)
where t1.`Lifeexpectancy`=''
;
  
  select country, year, `Lifeexpectancy`
  from worldlifexpectancy
  where `Lifeexpectancy` = '';
  
  Exploratory data analysis
  
  Select country,min(`Lifeexpectancy`), 
  max(`Lifeexpectancy`),
  round(max(`Lifeexpectancy`)-min(`Lifeexpectancy`),1) as life_increase_15_years
  from worldlifexpectancy
  group by country
  having min(`lifeexpectancy`)<>0 
  and max(`lifeexpectancy`)<>0
  order by life_increase_15_years desc;
  
  select country,ROUND(AVG(`lifeexpectancy`),1) AS LIFE_EXP, ROUND(AVG(GDP),1) AS GDP
  FROM worldlifexpectancy
  group by country
  HAVING LIFE_EXP > 0
  AND GDP > 0
  order by GDP DESC;


select
SUM(case
    when GDP>=1500 THEN 1
    ELSE 0
END) high_GDP_Count
FROM worldlifexpectancy;    

  
  