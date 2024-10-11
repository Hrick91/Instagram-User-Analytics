use ig_clone;
-- Loyal User Reward
select * from users order by created_at asc limit 5;
-- Fetch inactive users (Include id column for faster search and joins 
select users.id, users.username from users
left join photos on users.id= photos.user_id
where photos.user_id is null;
-- Contest Winner Declaration
select u.id, u.username,p.id as photo_id,p.image_url, 
count(l.user_id) as Total_like_count
from photos as p
inner join likes as l on p.id=l.photo_id
inner join users as u  on u.id= p.user_id
group by u.id, u.username,p.id,p.image_url
order by Total_like_count desc
limit 1;
-- Top 5 Hashtags
select tags.tag_name, count(*) as most_used_hashtags 
from photo_tags
inner join tags
on photo_tags.tag_id=tags.id
group by tag_id
order by most_used_hashtags desc
limit 5;
-- Ad Campaign Launch
select dayname(created_at) as Registration_Day,
count(username) as Most_People_Registered
from users
group by Registration_Day
order by Most_People_Registered desc
limit 1;
-- 'Investor Metrics: User Engagement'
 -- Total number of Active Users
 select count(distinct users.id) as Active_User
 from users
 inner join photos on users.id= photos.user_id;
-- Total number of photos
select count(*) as Total_Photos from photos;
-- Calculating the Average Number of Posts per Active User
select 
(select count(*) as Total_Photos from photos)/
(select count(distinct users.id) as Active_User)
from users
inner join photos on users.id= photos.user_id;

---------------------------------------------------
select 
count(distinct users.id) as Active_User, 
count(*) as Total_Photo_Posted,
(count(*)/nullif(count(distinct users.id),0)) as
Average_Posts_Per_Active_User
from users
inner join photos on users.id= photos.user_id;


-- Finding out the Bots & Fake Accounts
-- Step 1: Get the total number of photos
WITH TotalPhotos AS (
    SELECT COUNT(*) AS total_photos
    FROM photos
),

-- Step 2: Count likes for each user
UserLikes AS (
    SELECT 
        likes.user_id,
        COUNT(likes.photo_id) AS liked_photos
    FROM 
        likes
    GROUP BY 
        likes.user_id
)

-- Step 3: Identify users who have liked every single photo
SELECT 
    u.id AS user_id,
    u.username
FROM 
    users AS u
INNER JOIN 
    UserLikes AS ul ON u.id = ul.user_id
CROSS JOIN 
    TotalPhotos AS tp
WHERE 
    ul.liked_photos = tp.total_photos;  -- Users who liked all photos


