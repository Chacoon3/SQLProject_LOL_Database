USE BUDT703_Project_0501_06


-- 1. To find the top 3 rounds that have the most viewers.
SELECT r.*
FROM [LOL.Round] r,
(
SELECT TOP 3 r1.rndViewerCount
FROM [LOL.Round] r1
GROUP BY r1.rndViewerCount
ORDER BY r1.rndViewerCount DESC
) viewerCount
WHERE r.rndViewerCount IN (viewerCount.rndViewerCount)
ORDER BY r.rndViewerCount


--2. To find the top 3 champions with the highest win rate.
SELECT TOP 3 c.chpId AS [Champion Id],
c.chpName AS [Champion Name],
1 - SUM(CAST(pa.isWinnerTeam AS DECIMAL(14,4))) /
COUNT(c.chpId) AS [Win Rate]
FROM [LOL.Champion] c JOIN [LOL.Perform] pe ON c.chpId = pe.chpId
JOIN [LOL.Player] p ON p.plyId = pe.plyId
JOIN [LOL.Participate] pa ON pa.rndId = pe.rndId AND pa.temId =
p.temId
GROUP BY c.chpId, c.chpName
ORDER BY [Win Rate] DESC, c.chpId

-- create a view that stores each player's KDA figure in every match they have attended
DROP VIEW IF EXISTS KDA
CREATE VIEW KDA AS
SELECT p.rndId, p.plyId, p.plyPos,
CASE
WHEN p.plyDeath = 0 THEN p.plyAssist + p.plyKill
ELSE CAST((p.plyAssist + p.plyKill) AS DECIMAL(10,2)) /
CAST(p.plyDeath AS DECIMAL(10,2))
END AS kda
FROM [LOL.Perform] p


--3. To find the player with the best performance (defined as (player kill +
-- player assist) / player death) in a single round.
SELECT k.rndId,
CONCAT(pl.plyFirstName, ' ', pl.plyLastName) AS 'PlayerName',
pl.plyNickname,
CONVERT(DECIMAL(10, 2),ROUND(k.kda, 2)) AS 'KDA'FROM KDA k JOIN [LOL.Player] pl ON k.plyId = pl.plyId
WHERE k.kda = (
SELECT MAX(k1.kda) AS 'MaxKDA'
FROM KDA k1
WHERE k1.rndId = k.rndId
)
ORDER BY k.rndId


--4.To find the player with the best average performance (defined as the
-- average of the players performance in all the
-- matches he attended) for each position (i.e. top, mid, jungle, adc, support)
SELECT CONCAT(pl.plyFirstName, ' ', pl.plyLastName) AS [PlayerName],
pl.plyNickname,
k.plyPos,
CONVERT(DECIMAL(10, 2),ROUND(k.kda, 2)) AS 'KDA'
FROM KDA k JOIN [LOL.Player] pl ON k.plyId = pl.plyId,
(
SELECT K.plyPos, MAX(k.kda) AS 'MaxKDA'
FROM KDA k JOIN [LOL.Player] p ON k.plyId = p.plyId
GROUP BY k.plyPos
) maxKDA
WHERE k.plyPos = maxKDA.plyPos AND k.kda = maxKDA.MaxKDA
ORDER BY k.plyPos, [PlayerName]


-- 5. To describe the average performance of players from different regions.
SELECT c.clbRegion,
CONVERT(DECIMAL(10, 2), ROUND(AVG(k.kda) ,2)) AS [Regional Avg. Perf.]
FROM [LOL.Player] pl
JOIN KDA k ON pl.plyId=k.plyId
JOIN [LOL.Perform] pe ON pl.plyId = pe.plyId
JOIN [LOL.Team] t ON pl.temId = t.temId
JOIN [LOL.Club] c ON t.clbId = c.clbId
GROUP BY c.clbRegion