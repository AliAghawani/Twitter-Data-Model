-- Create the database
CREATE DATABASE IF NOT EXISTS TwitterClone;
USE TwitterClone;

-- Create the Users table
CREATE TABLE Users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password BINARY(64) NOT NULL
);

-- Create the Profiles table
CREATE TABLE Profiles (
    profile_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    bio TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE
);

-- Create the Followers table
CREATE TABLE Followers (
    follower_id INT NOT NULL,
    followed_id INT NOT NULL,
    PRIMARY KEY (follower_id, followed_id),
    FOREIGN KEY (follower_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (followed_id) REFERENCES Users(user_id) ON DELETE CASCADE
);

-- Create the Tweets table
CREATE TABLE Tweets (
    tweet_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    content TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE
);

-- Create the Likes table
CREATE TABLE Likes (
    like_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    tweet_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (tweet_id) REFERENCES Tweets(tweet_id) ON DELETE CASCADE
);

-- Insert users
INSERT INTO Users (username, email, password)
VALUES 
('john_doe', 'john@example.com', UNHEX(MD5('password123'))),
('jane_doe', 'jane@example.com', UNHEX(MD5('password456')));

-- Insert profiles
INSERT INTO Profiles (user_id, bio) 
VALUES 
(1, 'Software Developer and tech enthusiast'),
(2, 'Data Analyst and aspiring entrepreneur');

-- Insert follow relationships
INSERT INTO Followers (follower_id, followed_id) 
VALUES 
(1, 2), -- john follows jane
(2, 1); -- jane follows john

-- Insert tweets
INSERT INTO Tweets (user_id, content) 
VALUES 
(1, 'Hello, world! This is my first tweet.'),
(2, 'Excited to join Twitter!');

-- Insert likes
INSERT INTO Likes (user_id, tweet_id) 
VALUES 
(2, 1), -- jane likes john's tweet
(1, 2); -- john likes jane's tweet

DELIMITER //
CREATE PROCEDURE createAccount(
    IN p_username VARCHAR(50),
    IN p_email VARCHAR(100),
    IN p_password VARCHAR(50),
    IN p_bio TEXT
)
BEGIN
    -- Insert into Users
    INSERT INTO Users (username, email, password)
    VALUES (p_username, p_email, UNHEX(MD5(p_password)));

    -- Insert into Profiles
    INSERT INTO Profiles (user_id, bio)
    VALUES (LAST_INSERT_ID(), p_bio);
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE User_Follow(
    IN p_follower_username VARCHAR(50),
    IN p_followed_username VARCHAR(50)
)
BEGIN
    DECLARE follower_id INT;
    DECLARE followed_id INT;

    -- Find user IDs
    SELECT user_id INTO follower_id FROM Users WHERE username = p_follower_username;
    SELECT user_id INTO followed_id FROM Users WHERE username = p_followed_username;

    -- Insert into Followers
    INSERT INTO Followers (follower_id, followed_id)
    VALUES (follower_id, followed_id);
END //
DELIMITER ;

