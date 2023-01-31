USE BUDT703_Project_0501_06
-- drop tables
DROP TABLE IF EXISTS [LOL.Perform];
DROP TABLE IF EXISTS [LOL.Participate];
DROP TABLE IF EXISTS [LOL.Contract];
DROP TABLE IF EXISTS [LOL.Player];
DROP TABLE IF EXISTS [LOL.Team];
DROP TABLE IF EXISTS [LOL.Club];
DROP TABLE IF EXISTS [LOL.Champion];
DROP TABLE IF EXISTS [LOL.Round];
DROP TABLE IF EXISTS [LOL.Match];
DROP TABLE IF EXISTS [LOL.Championship];
--Championship (chpsId, chpsSeason, chpsRegion, chpsYear)
CREATE TABLE [LOL.Championship] (
chpsId CHAR(4) NOT NULL,
chpsSeason VARCHAR(30),
chpsRegion VARCHAR (10),
chpsYear INTEGER,
CONSTRAINT pk_Championship_chpsId PRIMARY KEY (chpsId));
--Match(matId, matBestOfGames, chpsID)
CREATE TABLE [LOL.Match] (
matId CHAR(7) NOT NULL,
matBestOfGames INTEGER,
chpsID CHAR(4),
CONSTRAINT pk_Match_matId PRIMARY KEY (matId),
CONSTRAINT fk_Match_chpsId FOREIGN KEY (chpsId)
REFERENCES [LOL.Championship] (chpsId)
ON DELETE CASCADE ON UPDATE CASCADE);
--Round(rndId, rndDate, rndLength, rndViewerCount, matId)
CREATE TABLE [LOL.Round] (
rndId CHAR(9) NOT NULL,
rndDate DATE,
rndLength TIME,
rndViewerCount INTEGER,
matId CHAR(7),
CONSTRAINT pk_Round_rndId PRIMARY KEY (rndId),
CONSTRAINT fk_Round_matId FOREIGN KEY (matId)
REFERENCES [LOL.Match] (matId)
ON DELETE CASCADE ON UPDATE CASCADE);
--Club(clbId, clbName, clbRegion)
CREATE TABLE [LOL.Club](
clbId CHAR(6) NOT NULL,
clbName VARCHAR(25),
clbRegion VARCHAR(10),
CONSTRAINT pk_Club_clbId PRIMARY KEY (clbId));
--Team(temId, temName, temTriCode, clbId)
CREATE TABLE [LOL.Team] (
temId CHAR(6) NOT NULL,
temName VARCHAR (25),
temTriCode VARCHAR(10),
clbId CHAR(6),
CONSTRAINT pk_Team_temId PRIMARY KEY (temId),
CONSTRAINT fk_Team_clbId FOREIGN KEY (clbId)
REFERENCES [LOL.Club] (clbId)ON DELETE CASCADE ON UPDATE CASCADE);
-- Player(plyId, plyFirstName, plyLastName, plyNickname, plyBirthDate,
plyCitizenShip, temId)
CREATE TABLE [LOL.Player] (
plyId CHAR(6) NOT NULL,
plyFirstName VARCHAR (15),
plyLastName VARCHAR(15),
plyNickname VARCHAR(10),
plyBirthDate DATE,
plyCitizenShip VARCHAR(20),
temId CHAR(6),
CONSTRAINT pk_Player_plyId PRIMARY KEY (plyId),
CONSTRAINT fk_Player_temId FOREIGN KEY (temId)
REFERENCES [LOL.Team] (temId)
ON DELETE SET NULL ON UPDATE CASCADE);
--Champion(chpId, chpName, chpTitle)
CREATE TABLE [LOL.Champion](
chpId CHAR(4) NOT NULL,
chpName VARCHAR(20),
chpTitle VARCHAR(30),
CONSTRAINT pk_Champion_chpId PRIMARY KEY (chpId));
--Contract(conId, conStartDate,conEndDate, clbId, plyId)
CREATE TABLE [LOL.Contract](
conId CHAR(7) NOT NULL,
conStartDate DATE,
conEndDate DATE,
clbId CHAR(6),
plyId CHAR(6)
CONSTRAINT pk_Contract_conId PRIMARY KEY (conId),
CONSTRAINT fk_Contract_clbId FOREIGN KEY (clbId)
REFERENCES [LOL.Club] (clbId)
ON DELETE SET NULL ON UPDATE CASCADE,
CONSTRAINT fk_Contract_plyId FOREIGN KEY (plyId)
REFERENCES [LOL.Player] (plyId)
ON DELETE CASCADE ON UPDATE NO ACTION)
--Participate(temId, rndId, isBlueTeam, isWinnerTeam)
CREATE TABLE [LOL.Participate](
temId CHAR(6) NOT NULL,
rndId CHAR(9) NOT NULL,
isBlueTeam BIT,
isWinnerTeam BIT,
CONSTRAINT pk_Participate_temId_rndId PRIMARY KEY (temId, rndId),
CONSTRAINT fk_Participate_temId FOREIGN KEY (temId)
REFERENCES [LOL.Team] (temId)
ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT fk_Participate_rndId FOREIGN KEY (rndId)
REFERENCES [LOL.Round] (rndId)
ON DELETE CASCADE ON UPDATE CASCADE)
--Perform(rndId, plyId, plyKill, plyDeath, plyAssist, plyPos, chpId)
CREATE TABLE [LOL.Perform](
plyId CHAR(6) NOT NULL,
rndId CHAR(9) NOT NULL,
plyKill INTEGER,
plyDeath INTEGER,plyAssist INTEGER,
plyPos CHAR(3) CHECK (plyPos In ('TOP','MID','JUG','ADC','SUP')) ,
chpId CHAR(4),
CONSTRAINT pk_Perform_plyId_rndId PRIMARY KEY (plyId, rndId),
CONSTRAINT fk_Perform_plyId FOREIGN KEY (plyId)
REFERENCES [LOL.Player] (plyId)
ON DELETE NO ACTION ON UPDATE CASCADE,
CONSTRAINT fk_Perform_rndId FOREIGN KEY (rndId)
REFERENCES [LOL.Round] (rndId)
ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT fk_Perform_chpId FOREIGN KEY (chpId)
REFERENCES [LOL.Champion] (chpId)
ON DELETE NO ACTION ON UPDATE CASCADE);
-- Player(plyId, plyFirstName, plyLastName, plyNickname, plyBirthDate,
plyCitizenShip, temId)
CREATE TABLE [LOL.Player] (
plyId CHAR(6) NOT NULL,
plyFirstName VARCHAR (15),
plyLastName VARCHAR(15),
plyNickname VARCHAR(10),
plyBirthDate DATE,
plyCitizenShip VARCHAR(20),
temId CHAR(6),
CONSTRAINT pk_Player_plyId PRIMARY KEY (plyId),
CONSTRAINT fk_Player_temId FOREIGN KEY (temId)
REFERENCES [LOL.Team] (temId)
ON DELETE SET NULL ON UPDATE CASCADE);
--Champion(chpId, chpName, chpTitle)
CREATE TABLE [LOL.Champion](
chpId CHAR(4) NOT NULL,
chpName VARCHAR(20),
chpTitle VARCHAR(30),
CONSTRAINT pk_Champion_chpId PRIMARY KEY (chpId));
--Contract(conId, conStartDate,conEndDate, clbId, plyId)
CREATE TABLE [LOL.Contract](
conId CHAR(7) NOT NULL,
conStartDate DATE,
conEndDate DATE,
clbId CHAR(6),
plyId CHAR(6)
CONSTRAINT pk_Contract_conId PRIMARY KEY (conId),
CONSTRAINT fk_Contract_clbId FOREIGN KEY (clbId)
REFERENCES [LOL.Club] (clbId)
ON DELETE SET NULL ON UPDATE CASCADE,
CONSTRAINT fk_Contract_plyId FOREIGN KEY (plyId)
REFERENCES [LOL.Player] (plyId)
ON DELETE CASCADE ON UPDATE NO ACTION)
--Participate(temId, rndId, isBlueTeam, isWinnerTeam)
CREATE TABLE [LOL.Participate](
temId CHAR(6) NOT NULL,
rndId CHAR(9) NOT NULL,
isBlueTeam BIT,
isWinnerTeam BIT,
CONSTRAINT pk_Participate_temId_rndId PRIMARY KEY (temId, rndId),
CONSTRAINT fk_Participate_temId FOREIGN KEY (temId)REFERENCES [LOL.Team] (temId)
ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT fk_Participate_rndId FOREIGN KEY (rndId)
REFERENCES [LOL.Round] (rndId)
ON DELETE CASCADE ON UPDATE CASCADE)
--Perform(rndId, plyId, plyKill, plyDeath, plyAssist, plyPos, chpId)
CREATE TABLE [LOL.Perform](
plyId CHAR(6) NOT NULL,
rndId CHAR(9) NOT NULL,
plyKill INTEGER,
plyDeath INTEGER,
plyAssist INTEGER,
plyPos CHAR(3) CHECK (plyPos In ('TOP','MID','JUG','ADC','SUP')) ,
chpId CHAR(4),
CONSTRAINT pk_Perform_plyId_rndId PRIMARY KEY (plyId, rndId),
CONSTRAINT fk_Perform_plyId FOREIGN KEY (plyId)
REFERENCES [LOL.Player] (plyId)
ON DELETE NO ACTION ON UPDATE CASCADE,
CONSTRAINT fk_Perform_rndId FOREIGN KEY (rndId)
REFERENCES [LOL.Round] (rndId)
ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT fk_Perform_chpId FOREIGN KEY (chpId)
REFERENCES [LOL.Champion] (chpId)
ON DELETE NO ACTION ON UPDATE CASCADE)
-- fake data
INSERT INTO[LOL.Championship]VALUES ('0001',Null,'World', 2022)
INSERT INTO[LOL.Championship]VALUES ('0002', 'Summer', 'LPL', 2022)
INSERT INTO[LOL.Match]VALUES ('M000001', 5, '0001')
INSERT INTO[LOL.Round]VALUES ('R00000001', '2022-11-05', '00:31:10', 113884,
'M000001')
INSERT INTO[LOL.Club]VALUES ('CLB001', 'T1', 'LCK')
INSERT INTO[LOL.Club]VALUES ('CLB002', 'DRX', 'LCK')
INSERT INTO[LOL.Team]VALUES('T00001', 'T1', 'T1', 'CLB001')
INSERT INTO[LOL.Team]VALUES ('T00002', 'DRX', 'DRX', 'CLB002')
INSERT INTO[LOL.Player]VALUES ('P00001', 'Woo-Je', 'Choi', 'Zeus','2004-01-31',
'South Korea', 'T00001' )
INSERT INTO[LOL.Player]VALUES ('P00002', 'Seong-hoon', 'Hwang', 'Kingen','2000-03-
11', 'South Korea', 'T00002')
INSERT INTO [LOL.Champion] VALUES ('C001', 'Yone', 'The Unforgotten');
INSERT INTO [LOL.Champion] VALUES ('C002', 'Lin Sin', 'The Blind Monk');
INSERT INTO [LOL.Contract] VALUES ('CT00001', '2020-11-01', '2023-11-20' ,
'CLB001','P00001');
INSERT INTO [LOL.Contract] VALUES ('CT00002', '2020-11-01', '2022-11-21' ,
'CLB002','P00002');
INSERT INTO [LOL.Participate] VALUES ('T00001', 'R00000001', 1, 0);
INSERT INTO [LOL.Participate] VALUES ('T00002', 'R00000001', 0 , 1);
INSERT INTO [LOL.Perform] VALUES ('P00001','R00000001', 4,1,5, 'TOP','C001');
INSERT INTO [LOL.Perform] VALUES ('P00002','R00000001', 3,2,1, 'JUG','C002');

-- validate
SELECT * FROM [LOL.Champion]
SELECT * FROM [LOL.Championship]
SELECT * FROM [LOL.Club]
SELECT * FROM [LOL.Contract]
SELECT * FROM [LOL.Match]
SELECT * FROM [LOL.Participate]
SELECT * FROM [LOL.Perform]
SELECT * FROM [LOL.Player]SELECT * FROM [LOL.Round]
SELECT * FROM [LOL.Team]