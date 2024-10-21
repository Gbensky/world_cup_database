#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

#INSERT
echo $($PSQL "TRUNCATE games, teams RESTART IDENTITY")
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
if [[ $WINNER != winner ]]
  then
  #get winner
  WINNER_NAME=$($PSQL "SELECT name FROM teams WHERE name='$WINNER' LIMIT 1")
  #if not found
  if [[ -z $WINNER_NAME ]]
    then
    #insert team
    INSERT_TEAM_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
    if [[ $INSERT_TEAM_RESULT == 'INSERT 0 1' ]]
      then
        echo Inserted into teams, $WINNER
    fi
  fi
  
  #get winner_id
  WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
  
  #get opponent
  OPPONENT_NAME=$($PSQL "SELECT name FROM teams WHERE name='$OPPONENT' LIMIT 1")
  #if not found
  if [[ -z $OPPONENT_NAME ]]
    then
    #insert team 
    INSERT_TEAM_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
    if [[ $INSERT_TEAM_RESULT == 'INSERT 0 1' ]]
      then
        echo Inserted into teams, $OPPONENT
    fi
  fi
  #get opponent_id
  OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

  INSERT_GAMES_RESULT=$($PSQL "INSERT INTO games(year, winner_id, opponent_id, winner_goals, opponent_goals, round) VALUES($YEAR, $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS, '$ROUND')")
  if [[ $INSERT_GAMES_RESULT == 'INSERT 0 1' ]]
    then
      echo Inserted into games, $ROUND : $WINNER, $WINNER_ID vs $OPPONENT, $OPPONENT_ID in $YEAR
  fi
fi
done