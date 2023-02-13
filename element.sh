#! /bin/bash
#connect to periodic_table database
PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"
 
 #if argumnet is provided
  if [[  $1 ]]
  then
     # if argument is not a number then get data from symbol or name
      if [[ ! $1 =~ ^[0-9]+$ ]]
      then
     
        GET_ATOMIC_NUMBER=$($PSQL "select atomic_number from elements where symbol='$1' or name='$1'")
      else
       #get values using the atomic_number
        GET_ATOMIC_NUMBER=$($PSQL "select atomic_number from elements where atomic_number=$1")
     
       
      fi
      #if atomic number is null  then send back the echo message
      if [[ -z $GET_ATOMIC_NUMBER ]] 
      then
        #fixed by removing newline 
        echo  I could not find that element in the database.
      else
      #else get the atomic details and print the message
        GET_ATOMIC_DETAILS=$($PSQL "select symbol,name,atomic_mass,melting_point_celsius,boiling_point_celsius,type from elements inner join properties using(atomic_number) inner join types using(type_id) where elements.atomic_number = $GET_ATOMIC_NUMBER")

        #read the details from the above query into individual variables
          echo "$GET_ATOMIC_DETAILS" | while read SYMBOL BAR NAME BAR ATOMIC_MASS BAR MELT_PT_CEL BAR BOIL_PT_CEL BAR TYPE
          do
            #print the message
            echo  "The element with atomic number $(echo $GET_ATOMIC_NUMBER | sed -r 's/^ *| *$//g') is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELT_PT_CEL celsius and a boiling point of $BOIL_PT_CEL celsius."
          done
        
      fi

  else
    #echo to provide an argument
    echo Please provide an element as an argument.
  fi


