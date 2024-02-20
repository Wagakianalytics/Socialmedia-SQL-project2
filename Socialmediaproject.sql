SELECT *
FROM dbo.sentimentdataset

--Distribution of posts over months

SELECT Year, Month, COUNT(*) AS TotalCount
FROM dbo.sentimentdataset
GROUP BY Year, Month;

--number of posts for each platform

SELECT Platform, COUNT(*) AS Count
FROM dbo.sentimentdataset
GROUP BY Platform;

 --the most popular hashtags

 SELECT Hashtags, COUNT(*) AS Count
FROM dbo.sentimentdataset
GROUP BY Hashtags
ORDER BY Count DESC

 --distribution of posts by country

 SELECT Country, COUNT(*) AS Count
FROM dbo.sentimentdataset
GROUP BY Country
ORDER BY Count DESC;

--sentiment trends over time

SELECT Year, Month, Sentiment, COUNT(*) AS Count
FROM dbo.sentimentdataset
GROUP BY Year, Month, Sentiment;

--average number of likes and retweets per post

SELECT AVG(Likes) AS AvgLikes, AVG(Retweets) AS AvgRetweets
FROM dbo.sentimentdataset

--average number of likes and retweets across different platforms

SELECT Platform, AVG(Likes) AS AvgLikes, AVG(Retweets) AS AvgRetweets
FROM dbo.sentimentdataset
GROUP BY Platform

--sentiment distribution across different countries

SELECT Country, Sentiment, COUNT(*) AS Count
FROM dbo.sentimentdataset
GROUP BY Country, Sentiment;

 --top hashtags associated with specific sentiments

 SELECT Hashtags, Sentiment, COUNT(*) AS Count
FROM dbo.sentimentdataset
WHERE Sentiment = 'Positive'
GROUP BY Hashtags, Sentiment
ORDER BY Count DESC

 SELECT Hashtags, Sentiment, COUNT(*) AS Count
FROM dbo.sentimentdataset
WHERE Sentiment = 'Negative'
GROUP BY Hashtags, Sentiment
ORDER BY Count DESC

--posting frequency and engagement by hour of the day

SELECT Hour, COUNT(*) AS PostCount, AVG(Likes) AS AvgLikes, AVG(Retweets) AS AvgRetweets
FROM dbo.sentimentdataset
GROUP BY Hour;

--total engagement (likes + retweets) for each user in a temporary table

CREATE TABLE #UserEngagement 
(User1 VARCHAR(255),
  TotalEngagement INT)

 INSERT INTO #UserEngagement ([User1], TotalEngagement)
SELECT [User], SUM(Likes + Retweets) AS TotalEngagement
FROM dbo.sentimentdataset
GROUP BY [User];

SELECT *
FROM #UserEngagement 

 --users based on their total engagement

 SELECT User1,
       CASE
           WHEN TotalEngagement > 1000 THEN 'High Engagement'
           WHEN TotalEngagement > 500 THEN 'Medium Engagement'
           ELSE 'Low Engagement'
       END AS EngagementCategory
FROM #UserEngagement;

--sentiments with more than 100 occurrences

SELECT Sentiment, COUNT(*) AS Count
FROM dbo.sentimentdataset
GROUP BY Sentiment
HAVING COUNT(*) > 5;

 --first word from the user-generated content and its occurrences

 SELECT LEFT(Text, CHARINDEX(' ', Text + ' ') - 1) AS FirstWord,
       COUNT(*) AS WordCount
FROM dbo.sentimentdataset
GROUP BY LEFT(Text, CHARINDEX(' ', Text + ' ') - 1);

 --distribution of sentiments over months an the percentage of each sentiment category per month

 SELECT 
    Year, 
    Month, 
    Sentiment, 
    COUNT(*) AS Count,
    ROUND(CAST(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY Year, Month) AS numeric), 2) AS Percentage
FROM dbo.sentimentdataset
GROUP BY Year, Month, Sentiment
ORDER BY Year, Month;

 --trending hashtags and their associated sentiment distribution

 SELECT 
    Hashtags, 
    Sentiment, 
    COUNT(*) AS Count
FROM dbo.sentimentdataset
WHERE Hashtags IS NOT NULL
GROUP BY Hashtags, Sentiment
ORDER BY Count DESC;

--sentiment distribution across different countries

SELECT 
    Country, 
    Sentiment, 
    COUNT(*) AS Count
FROM dbo.sentimentdataset
WHERE Country IS NOT NULL
GROUP BY Country, Sentiment
ORDER BY Country, Count DESC;

--distribution of user engagement by hour of the day

SELECT 
    Hour,
    COUNT(*) AS PostCount,
    SUM(Likes) AS TotalLikes,
    SUM(Retweets) AS TotalRetweets
FROM dbo.sentimentdataset
GROUP BY Hour
ORDER BY Hour;
