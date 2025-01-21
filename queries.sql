-- Display the number of tweets for a use
SELECT COUNT(*) AS tweet_count 
FROM Tweets 
WHERE user_id = (SELECT user_id FROM Users WHERE username = 'john_doe');

-- Display all users and their followers
SELECT 
    u1.username AS follower,
    u2.username AS followed
FROM Followers
JOIN Users u1 ON Followers.follower_id = u1.user_id
JOIN Users u2 ON Followers.followed_id = u2.user_id;

-- How many tweets has each user posted
SELECT 
    Users.username,
    COUNT(Tweets.tweet_id) AS tweet_count
FROM Users
LEFT JOIN Tweets ON Users.user_id = Tweets.user_id
GROUP BY Users.username;

-- Which tweet has received the most likes
SELECT 
    Tweets.content,
    Users.username,
    COUNT(Likes.like_id) AS likes_count
FROM Tweets
JOIN Likes ON Tweets.tweet_id = Likes.tweet_id
JOIN Users ON Tweets.user_id = Users.user_id
GROUP BY Tweets.tweet_id
ORDER BY likes_count DESC
LIMIT 1;

-- Who are the users followed by "john_doe"
SELECT 
    u2.username AS followed_user
FROM Followers
JOIN Users u1 ON Followers.follower_id = u1.user_id
JOIN Users u2 ON Followers.followed_id = u2.user_id
WHERE u1.username = 'john_doe';

-- Which users have more than 10 followers
SELECT 
    Users.username,
    COUNT(Followers.follower_id) AS follower_count
FROM Users
LEFT JOIN Followers ON Users.user_id = Followers.followed_id
GROUP BY Users.user_id
HAVING follower_count > 10;

-- Compare user activity based on the number of tweets, likes given, and followers
SELECT 
    Users.username,
    COUNT(DISTINCT Tweets.tweet_id) AS tweet_count,
    COUNT(DISTINCT Likes.like_id) AS likes_given,
    COUNT(DISTINCT Followers.follower_id) AS followers_count
FROM Users
LEFT JOIN Tweets ON Users.user_id = Tweets.user_id
LEFT JOIN Likes ON Users.user_id = Likes.user_id
LEFT JOIN Followers ON Users.user_id = Followers.followed_id
GROUP BY Users.username;

-- How many likes has each user's tweets received
SELECT 
    Users.username,
    COUNT(Likes.like_id) AS total_likes
FROM Users
LEFT JOIN Tweets ON Users.user_id = Tweets.user_id
LEFT JOIN Likes ON Tweets.tweet_id = Likes.tweet_id
GROUP BY Users.username;

-- Which users have the highest number of followers
SELECT 
    Users.username,
    COUNT(Followers.follower_id) AS total_followers
FROM Users
LEFT JOIN Followers ON Users.user_id = Followers.followed_id
GROUP BY Users.username
ORDER BY total_followers DESC
LIMIT 1;

-- Which tweets contain the keyword "Hello"
SELECT 
    content,
    created_at
FROM Tweets
WHERE content LIKE '%Hello%';

-- Who are the users that haven’t posted any tweets
SELECT 
    Users.username
FROM Users
LEFT JOIN Tweets ON Users.user_id = Tweets.user_id
WHERE Tweets.tweet_id IS NULL;

-- How many tweets are posted during each hour of the day
SELECT 
    HOUR(created_at) AS hour_of_day,
    COUNT(tweet_id) AS tweet_count
FROM Tweets
GROUP BY HOUR(created_at)
ORDER BY hour_of_day;

-- Who liked the tweet "Hello, world!"
SELECT 
    Users.username
FROM Likes
JOIN Tweets ON Likes.tweet_id = Tweets.tweet_id
JOIN Users ON Likes.user_id = Users.user_id
WHERE Tweets.content = 'Hello, world! This is my first tweet.';



