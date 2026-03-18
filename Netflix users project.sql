SELECT*
FROM netflix_user_behavior_dataset;

Select user_id, subscription_type
from netflix_user_behavior_dataset
where subscription_type = 'premium';

Select user_id, subscription_type
from netflix_user_behavior_dataset
where subscription_type = 'basic';

SELECT subscription_type, COUNT(*) AS total
FROM netflix_user_behavior_dataset
GROUP BY subscription_type;

select country,  count(user_id)
from netflix_user_behavior_dataset
where country = 'india';
 
SELECT payment_method, COUNT(user_id) AS total_users
FROM netflix_user_behavior_dataset
GROUP BY payment_method;

## to know device being used highest for netflix
Select primary_device, COUNT(user_id) as Number_of_Devices_used
from netflix_user_behavior_dataset
Group by primary_device;

Select age > 50,count(user_id) as people_watching
from netflix_user_behavior_dataset
group by age;

SELECT COUNT(user_id) AS people_watching
FROM netflix_user_behavior_dataset
WHERE age > 50;

## Selects users whose age is above average age
SELECT user_id, age
FROM netflix_user_behavior_dataset
WHERE age > (
    SELECT AVG(age)
    FROM netflix_user_behavior_dataset
);

select user_id, favorite_genre, COUNT (avg_watch_time_minutes) AS avg_watching_time 
from netflix_user_behavior_dataset
where avg_watch_time_minutes > (
	select AVG(avg_watch_time_minutes)
    FROM netflix_user_behavior_dataset
);


SELECT COUNT(*) AS people_above_avg_watch_time
FROM netflix_user_behavior_dataset
WHERE avg_watch_time_minutes > (
    SELECT AVG(avg_watch_time_minutes)
    FROM netflix_user_behavior_dataset
);

Select binge_watch_sessions > 10
from netflix_user_behavior_dataset;

Select binge_watch_sessions, count(user_id) as people_watching
from netflix_user_behavior_dataset
where binge_watch_sessions >(
	select avg(binge_watch_sessions)
    from netflix_user_behavior_dataset
);

##Identifying top users who may be useful for targeted marketing
Select user_id, avg_watch_time_minutes,
rank() over (order by avg_watch_time_minutes desc) as rank_position
from netflix_user_behavior_dataset;

#Identifying top recommendation click rate with proper ranks
select user_id, recommendation_click_rate,
rank() over (order by recommendation_click_rate desc) as rank_position
from netflix_user_behavior_dataset;

select user_id, recommendation_click_rate,
dense_rank() over (order by recommendation_click_rate desc) as rank_position
from netflix_user_behavior_dataset;

## Finding top 5 binge watchers
SELECT user_id, avg_watch_time_minutes
FROM netflix_user_behavior_dataset
ORDER BY avg_watch_time_minutes DESC
LIMIT 5;

# Find avg watch time of binge watchers
SELECT favorite_genre,
       AVG(avg_watch_time_minutes) AS avg_watch_time
FROM netflix_user_behavior_dataset
GROUP BY favorite_genre;

# User segmentation

SELECT user_id, avg_watch_time_minutes,
       CASE 
           WHEN avg_watch_time_minutes > 120 THEN 'Binge Watcher'
           WHEN avg_watch_time_minutes > 60 THEN 'Active User'
           ELSE 'Casual User'
       END AS user_category
FROM netflix_user_behavior_dataset;

# top Users per genre
Select user_id, favorite_genre, avg_watch_time_minutes,
dense_rank() over(partition by favorite_genre order by  avg_watch_time_minutes desc) as genre_rank
from netflix_user_behavior_dataset
limit 3;


#Finding top3 users per genre as per watching time

SELECT *
FROM (
    SELECT user_id, favorite_genre, avg_watch_time_minutes,
           DENSE_RANK() OVER (
               PARTITION BY favorite_genre 
               ORDER BY avg_watch_time_minutes DESC
           ) AS genre_rank
    FROM netflix_user_behavior_dataset
) t
WHERE genre_rank <= 3;


# Payment method analysis

SELECT payment_method, COUNT(*) AS users
FROM netflix_user_behavior_dataset
GROUP BY payment_method
ORDER BY users DESC;
