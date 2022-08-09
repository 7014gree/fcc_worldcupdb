#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo "$($PSQL "TRUNCATE TABLE games, teams")"

cat games.csv | while IFS="," read -a line
do
if [[ ${line[0]} != "year" ]]
  then
  GET_WINNER_ID="$($PSQL "SELECT team_id FROM teams WHERE name='${line[2]}'")"
  if [[ -z $GET_WINNER_ID ]]
    then
    ADD_WINNER="$($PSQL "INSERT INTO teams(name) VALUES('${line[2]}')")"
    GET_WINNER_ID="$($PSQL "SELECT team_id FROM teams WHERE name='${line[2]}'")"
  fi

  GET_LOSER_ID="$($PSQL "SELECT team_id FROM teams WHERE name='${line[3]}'")"
  if [[ -z $GET_LOSER_ID ]]
    then
    ADD_LOSER="$($PSQL "INSERT INTO teams(name) VALUES('${line[3]}')")"
    GET_LOSER_ID="$($PSQL "SELECT team_id FROM teams WHERE name='${line[3]}'")"
  fi

  INSERT="$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES(${line[0]}, '${line[1]}', $GET_WINNER_ID, $GET_LOSER_ID, ${line[4]}, ${line[5]})")"
  if [[ $INSERT = "INSERT 0 1" ]]
  then
    echo "Insert line ${line[0]}, ${line[1]}, ${line[2]}, ${line[3]}, ${line[4]}, ${line[5]}"
  fi

fi
done
