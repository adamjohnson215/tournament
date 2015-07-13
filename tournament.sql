-- Table definitions for the tournament project.
--
-- Put your SQL 'create table' statements in this file; also 'create view'
-- statements if you choose to use it.
--
-- You can write comments in this file by starting them with two dashes, like
-- these lines here.

CREATE DATABASE tournament;
CREATE TABLE players(id serial primary key, name text);
CREATE TABLE matches (match_id serial primary key, winner_id text, loser_id text);
	 
CREATE VIEW wins as
	SELECT players.id, count (matches.*) as wins 
		 FROM players left join matches 
			ON players.id = CAST(matches.winner_id as int)
		 GROUP BY players.id;

CREATE VIEW matches_played as
	SELECT players.id, count (matches.*) as matches 
	FROM players left join matches 
		ON players.id = CAST(matches.winner_id as int)
		OR players.id = CAST(matches.loser_id as int)
	GROUP BY players.id;
	
CREATE VIEW matches_and_wins as
	SELECT matches_played.id, sum (wins.wins) as wins, sum (matches_played.matches) as matches
	FROM matches_played left join wins
		ON matches_played.id = wins.id
	GROUP BY matches_played.id;

CREATE VIEW standings as 
	SELECT players.id, players.name, 
		sum(matches_and_wins.wins) as wins, 
		sum(matches_and_wins.matches) as matches
	FROM players left join matches_and_wins
		ON players.id = matches_and_wins.id
	GROUP BY players.id
	ORDER BY wins desc, matches, id;
--CREATE TABLE tournaments(tourney_id serial, tourney_name text);
--CREATE TABLE player_records (id text, tourney_id text, rank int, wins int, losses int, ties int);

