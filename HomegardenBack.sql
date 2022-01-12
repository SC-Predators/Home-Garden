DROP SCHEMA HOMEGARDEN;
CREATE DATABASE HOMEGARDEN;
USE HOMEGARDEN;

CREATE TABLE Homegarden_Client
(
    homegardenID VARCHAR(50) NOT NULL COMMENT '홈가든 고유 ID',
    clientID      VARCHAR(50)     NOT NULL COMMENT '사용자 홈가든 앱 가입 ID',
    clientPW      VARCHAR(50) NOT NULL COMMENT '사용자 가입 PW',
    buy_date      TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '장치 구입 일자',
    plantNickName char(100) COMMENT '식물 별명',
    mode          char(5)      DEFAULT 'A' COMMENT '자동모드는 (A)uto, 수동모드는 (M)anual',
    activeStatus char(5) DEFAULT 'A' COMMENT '활성: (A)ctivated, 블락:(B)locked, 삭제:(D)eleted',
    PRIMARY KEY (homegardenID)
);
SELECT * FROM Homegarden_Client HC;
SELECT * FROM Desired_state;

insert into Homegarden_Client (homegardenID,clientID, clientPW, plantNickName, mode) VALUES();

delete FROM Desired_state WHERE homegardenID = "homegarden2";
delete FROM Homegarden_Client WHERE homegardenID = "homegarden2";


CREATE TABLE Present_state
(
  homegardenID  VARCHAR(50)  NOT NULL COMMENT '장치 ID',
  writeTime TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '기록된 시간 저장',
  temperature FLOAT COMMENT '온도',
  humidity FLOAT COMMENT '습도',
  light FLOAT COMMENT '조도',
  water_level FLOAT COMMENT '물통의 수위',
  phStatus FLOAT COMMENT '토양 산성도',
  img text COMMENT 'S3 URL 저장',
  FOREIGN KEY (homegardenID) references Homegarden_Client(homegardenID)
);

DROP TABLE Desired_state;
CREATE TABLE Desired_state
(
    homegardenID  VARCHAR(50)  NOT NULL COMMENT '장치 ID',
    clientID VARCHAR(50) NOT NULL COMMENT '고객 ID',
    desired_temperature FLOAT DEFAULT 20 COMMENT '목표 온도',
    desired_humidity FLOAT DEFAULT 50 COMMENT  '목표 습도',
    desired_light FLOAT DEFAULT 200 COMMENT  '목표 조도',
    FOREIGN KEY (homegardenID) references Homegarden_Client(homegardenID)
);

INSERT INTO Present_state (homegardenID, temperature, humidity, light, water_level, phStatus, img) VALUES ("homegarden1", 00, 00, 00, 00, 00,"https://homegarden-images.s3.ap-northeast-2.amazonaws.com/jjh63360/2022-01-04+04-05-35.jpg");
INSERT INTO Present_state (homegardenID, temperature, humidity, light, water_level, phStatus) VALUES ("homegarden1", 11, 11, 11, 11, 11);
INSERT INTO Present_state (homegardenID, temperature, humidity, light, water_level, phStatus) VALUES ("homegarden1", 22, 22, 22, 22, 22);
INSERT INTO Present_state (homegardenID, temperature, humidity, light, water_level, phStatus) VALUES ("homegarden1", 33, 33, 33, 33, 33);
INSERT INTO Present_state (homegardenID, temperature, humidity, light, water_level, phStatus, img) VALUES ("homegarden1", 44, 44, 44, 44, 44,"https://homegarden-images.s3.ap-northeast-2.amazonaws.com/jjh63360/2022-01-04+04-05-50.jpeg");
INSERT INTO Present_state (homegardenID, temperature, humidity, light, water_level, phStatus) VALUES ("homegarden1", 55, 55, 55, 55, 55);
INSERT INTO Present_state (homegardenID, temperature, humidity, light, water_level, phStatus) VALUES ("homegarden1", 66, 66, 66, 66, 66);
INSERT INTO Present_state (homegardenID, temperature, humidity, light, water_level, phStatus) VALUES ("homegarden1", 12, 34, 56, 78, 90);

INSERT INTO Desired_state(homegardenID, clientID) VALUES ("homegarden1", "jjh63360");

UPDATE Present_state SET temperature =44, humidity=44, light=44, water_level=44, phStatus=44 WHERE img="https://homegarden-images.s3.ap-northeast-2.amazonaws.com/jjh63360/2022-01-04+04-05-50.jpeg";

SELECT * FROM Present_state;
SELECT  temperature, humidity, light, water_level, phStatus FROM Present_state PS, Homegarden_Client HC WHERE PS.homegardenID = HC.homegardenID AND HC.clientID="jjh63360"
ORDER BY writeTime DESC LIMIT 1;

SELECT desired_humidity

SELECT img FROM Present_state PS, Homegarden_Client HC WHERE img IS NOT NULL AND  PS.homegardenID = HC.homegardenID AND HC.clientID="jjh63360" ORDER BY  writeTime DESC LIMIT 1;

SELECT * FROM Present_state PS, Homegarden_Client HC WHERE PS.homegardenID = HC.homegardenID AND HC.clientID="jjh63360" AND writeTime = YEAR(2022) AND writeTime=MONTH(1) AND writeTime = DATE (4) AND writeTime < HOUR(5) AND writeTime < MINUTE(13);

#________________________________________히스토리 확인하기
SELECT COUNT(*) FROM Present_state PS, Homegarden_Client HC WHERE PS.homegardenID=HC.homegardenID AND HC.clientID = "jjh63360" AND writeTime < '2022-1-8 14:15:00';

CREATE VIEW HistoryVIEW AS
        SELECT writeTime, temperature, humidity, light, water_level, phStatus, img
        FROM Present_state PS, Homegarden_Client HC WHERE PS.homegardenID = HC.homegardenID AND HC.clientID= "jjh63360" AND writeTime < '2022-1-4 14:15:00';
SELECT  temperature, humidity, light, water_level, phStatus FROM HOMEGARDEN.HistoryVIEW ORDER BY writeTime DESC LIMIT 1;
SELECT * FROM HistoryVIEW;
SELECT img FROM HOMEGARDEN.HistoryVIEW WHERE img IS NOT NULL ORDER BY  writeTime DESC LIMIT 1;
DROP VIEW HistoryVIEW;

CREATE VIEW HistoryVIEW AS SELECT writeTime, temperature, humidity, light, water_level, phStatus, img FROM Present_state PS, Homegarden_Client HC WHERE PS.homegardenID = HC.homegardenID AND HC.clientID= "jjh63360" AND writeTime < '2022-1-4 5:15:00'

CREATE VIEW HistoryVIEW AS SELECT writeTime, temperature, humidity, light, water_level, phStatus, img FROM Present_state PS, Homegarden_Client HC WHERE PS.homegardenID = HC.homegardenID AND HC.clientID= "jjh63360" AND writeTime < '2022-1-4 14:15:00'
#-----------------------------------------

#________________________________________모드 변경 및 받아오기
UPDATE Homegarden_Client SET mode = 'A' WHERE clientID = "jjh63360";
SELECT * FROM Homegarden_Client;

SELECT * FROM Desired_state;
UPDATE Desired_state DS SET desired_light = 1000, desired_humidity = 60 WHERE  DS.clientID = "jjh63360";
SELECT * FROM Desired_state DS, Homegarden_Client HC WHERE  HC.clientID = DS.clientID  AND DS.clientID = "jjh63360";
SELECT desired_humidity, desired_light FROM Desired_state where homegardenID = "homegarden1";
#-----------------------------------------

SELECT @@GLOBAL.time_zone, @@SESSION.time_zone;

set global time_zone = 'Asia/Seoul';
set time_zone = 'Asia/Seoul';

SELECT COUNT(ClientID) FROM Homegarden_Client WHERE clientID="jjh63360"