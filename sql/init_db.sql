DROP TABLE Matches;
DROP TABLE Scores;
DROP TABLE Kills;
DROP TABLE SpecKills;
DROP TABLE Players;

CREATE TABLE Matches (
  id  INTEGER PRIMARY KEY,
  start_time  TIMESTAMP,
  map_id  VARCHAR (32),
  gamemode  VARCHAR (30),
  players  VARCHAR (255),
  params VARCHAR (1024)
);

CREATE TABLE Scores (
  player_id  VARCHAR (32),
  match_id  INT, 
  score  FLOAT,
  PRIMARY KEY (player_id, match_id),
  FOREIGN KEY (player_id) REFERENCES Players(id),
  FOREIGN KEY (match_id) REFERENCES Matches(id)
);

CREATE TABLE Kills (
  match_id   INT,
  match_time FLOAT,
  killer_id  VARCHAR (32),
  victim_id  VARCHAR (32),
  weapon     VARCHAR (48),
  dmgtype    VARCHAR (48),
  PRIMARY KEY (match_id, match_time, killer_id, victim_id),
  FOREIGN KEY (killer_id) REFERENCES Players(id),
  FOREIGN KEY (victim_id) REFERENCES Players(id)
);

CREATE TABLE SpecKills (
  match_id   INT,
  match_time FLOAT,
  player_id  VARCHAR (32),
  kill_type  VARCHAR (64),
  PRIMARY KEY (match_id, match_time, player_id, kill_type),
  FOREIGN KEY (player_id) REFERENCES Players(id),
  FOREIGN KEY (match_id) REFERENCES Matches(id)
);

CREATE TABLE Players (
  id  VARCHAR (32),
  uid  VARCHAR (64),
  p_name  VARCHAR (32),
  cdkey  VARCHAR (29),
  bot BOOLEAN,
  PRIMARY KEY (id)
);
