-- Table definitions for the tournament project.
--
-- Put your SQL 'create table' statements in this file; also 'create view'
-- statements if you choose to use it.

-- Create the tournament database
CREATE DATABASE tournament;

-- Connect to tournament database
\c tournament;

-- Create the table players for all registered players
CREATE TABLE players(id serial primary key, name text);

-- Create the table matches to log output of all matches
CREATE TABLE matches (match_id serial primary key, 
					  winner_id text, loser_id text);

-- Create a view of wins for each player	 
CREATE VIEW wins as
	SELECT players.id, count (matches.*) as wins 
		 FROM players left join matches 
			ON players.id = CAST(matches.winner_id as int)
		 GROUP BY players.id;

-- Create a view of matches played by each player
CREATE VIEW matches_played as
	SELECT players.id, count (matches.*) as matches 
	FROM players left join matches 
		ON players.id = CAST(matches.winner_id as int)
		OR players.id = CAST(matches.loser_id as int)
	GROUP BY players.id;

-- Create a view of matches played and wins for each player
CREATE VIEW matches_and_wins as
	SELECT matches_played.id, sum (wins.wins) as wins, 
			sum (matches_played.matches) as matches
	FROM matches_played left join wins
		ON matches_played.id = wins.id
	GROUP BY matches_played.id;

-- Create a view for player standings
CREATE VIEW standings as 
	SELECT players.id, players.name, 
		sum(matches_and_wins.wins) as wins, 
		sum(matches_and_wins.matches) as matches
	FROM players left join matches_and_wins
		ON players.id = matches_and_wins.id
	GROUP BY players.id
	ORDER BY wins desc, matches, id;

