#!/usr/bin/env python
# 
# tournament.py -- implementation of a Swiss-system tournament
#

import psycopg2
import bleach

def connect():
    """Connect to the PostgreSQL database.  Returns a database connection."""
    return psycopg2.connect("dbname=tournament")


def deleteMatches():
	"""Remove all the match records from the database."""
	connection = connect()
	cursor = connection.cursor()
	cursor.execute("delete from matches")
	connection.commit()
	connection.close()
	

def deletePlayers():
	"""Remove all the player records from the database."""
	connection = connect()
	cursor = connection.cursor()
	cursor.execute("delete from players")
	connection.commit()
	connection.close()


def countPlayers():
	"""Returns the number of players currently registered."""
	connection = connect()
	cursor = connection.cursor()
	cursor.execute("select count (*) as num from players")
	playercount = cursor.fetchone()
	connection.close()
	players = playercount[0]
	return players

def registerPlayer(name):	
	"""Adds a player to the tournament database.
  
    The database assigns a unique serial id number for the player.  (This
    should be handled by your SQL database schema, not in your Python code.)
  
    Args:
      name: the player's full name (need not be unique).
    """
	connection = connect()
	cursor = connection.cursor()
	cursor.execute("insert into players (name) values (%s)",
	 					(bleach.clean(name),))
	connection.commit()
	connection.close()
	
    


def playerStandings():
	"""Returns a list of the players and their win records, sorted by wins.

    The first entry in the list should be the player in first place, or a player
    tied for first place if there is currently a tie.

    Returns:
      A list of tuples, each of which contains (id, name, wins, matches):
        id: the player's unique id (assigned by the database)
        name: the player's full name (as registered)
        wins: the number of matches the player has won
        matches: the number of matches the player has played
    """
	connection = connect()
	cursor = connection.cursor()
	cursor.execute("select id, name, wins, matches from standings")
	standings = cursor.fetchall()
	connection.close()
	return standings


def reportMatch(winner, loser):
	"""Records the outcome of a single match between two players.

    Args:
      winner:  the id number of the player who won
      loser:  the id number of the player who lost
    """
	connection = connect()
	cursor = connection.cursor()
	cursor.execute("insert into matches (winner_id, loser_id) values (%s,%s)",
	 					(bleach.clean(winner), bleach.clean(loser)),)
	connection.commit()
	connection.close()
    
 
def swissPairings():
	"""Returns a list of pairs of players for the next round of a match.
  
    Assuming that there are an even number of players registered, each player
    appears exactly once in the pairings.  Each player is paired with another
    player with an equal or nearly-equal win record, that is, a player adjacent
    to him or her in the standings.
  
    Returns:
      A list of tuples, each of which contains (id1, name1, id2, name2)
        id1: the first player's unique id
        name1: the first player's name
        id2: the second player's unique id
        name2: the second player's name
    """
	standings = playerStandings()
	swissPairings = []
	numberOfPlayers = len(standings)
	index = 0
	while index < numberOfPlayers:
		swissPairings.append((standings[index][0],
			standings[index][1],standings[index+1][0],
			standings[index+1][1]),)
		index = index + 2		
	return swissPairings
			
			
