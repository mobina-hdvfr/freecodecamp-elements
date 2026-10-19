#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# if no argument
if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
  exit
fi

# if number
if [[ $1 =~ ^[0-9]+$ ]]
then
  atomic_n=$1
  result=$($PSQL "select e.atomic_number, e.name, e.symbol, t.type, p.atomic_mass,
          p.melting_point_celsius, p.boiling_point_celsius
          from elements e
          join properties p using(atomic_number)
          join types t using(type_id)
          where e.atomic_number=$atomic_n")

# if string
else
  result=$($PSQL "select e.atomic_number, e.name, e.symbol, t.type, p.atomic_mass,
          p.melting_point_celsius, p.boiling_point_celsius
          from elements e
          join properties p using(atomic_number)
          join types t using(type_id)
          where e.symbol='$1' or e.name='$1'")
fi

# if result exists
if [[ ! -z $result ]]
then
  echo $result | while IFS='|' read atomic_n name symbol e_type mass melt boil
  do
    echo "The element with atomic number $atomic_n is $name ($symbol). It's a $e_type, with a mass of $mass amu. $name has a melting point of $melt celsius and a boiling point of $boil celsius."
  done
else
  echo "I could not find that element in the database."
fi


