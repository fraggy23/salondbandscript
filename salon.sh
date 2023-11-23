#! /bin/bash



#psql --username=freecodecamp --dbname=salon -c "SELECT * FROM services" | grep "[0-9] |" | sed 's/ |/)/'
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"
SERVICES=$($PSQL "SELECT * FROM services" | grep "[0-9] |" | sed 's/ |/)/')
servicenumbers=$($PSQL "SELECT COUNT(*) FROM services" | grep "[0-9]" | grep -v "(1 row)" | sed 's/ //g')
echo $SERVICES


MAIN_MENU() {

  


  psql --username=freecodecamp --dbname=salon -c "SELECT * FROM services" | grep "[0-9] |" | sed 's/ |/)/'
  
  #psql --username=freecodecamp --dbname=salon -c "SELECT * FROM services" | grep "2 |" | sed 's/ |/)/'
  #psql --username=freecodecamp --dbname=salon -c "SELECT * FROM services" | grep "3 |" | sed 's/ |/)/'
  read SERVICE_ID_SELECTED

  case $SERVICE_ID_SELECTED in
    1) cut ;;
    2) color ;;
    3) dread ;;
    *) MAIN_MENU "Please enter a valid option." ;;
  esac
}


SALON_MENU() {
    read SERVICE_ID_SELECTED
    if [[ $SERVICE_ID_SELECTED > $servicenumbers  ]]
    then
        #psql --username=freecodecamp --dbname=salon -c "SELECT * FROM services" | grep "[0-9] |" | sed 's/ |/)/'
        echo $SERVICES
        SALON_MENU
    else
        
    

    for (( i=1; i<=$servicenumbers; i++ ))

        do
            if [[ $SERVICE_ID_SELECTED = $i ]]
            then
                SERVICE_SELECTED=${service[$i]}
                
                
        
            fi

    done

    echo $SERVICE_SELECTED
    
    echo -e "\nPHONE NUMBER"
    read CUSTOMER_PHONE
     CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")

     #if customer doesnt exist
     if [[ -z $CUSTOMER_NAME ]]
      then 
      
        # get new customer name
        echo -e "\nname"
        read CUSTOMER_NAME
        
     fi

     echo -e "\ntime"
     read SERVICE_TIME
     echo $CUSTOMER_NAME $CUSTOMER_PHONE $SERVICE_SELECTED $SERVICE_TIME
     psql --username=freecodecamp --dbname=salon -c "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE') ON CONFLICT DO NOTHING"
     CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
     echo $CUSTOMER_ID
     psql --username=freecodecamp --dbname=salon -c "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')"
       

        

        
    fi

  
echo "I have put you down for a ${service[$SERVICE_ID_SELECTED]} at $SERVICE_TIME,$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")."
  

}




for (( i=1; i<=$servicenumbers; i++ ))



   do



      echo "Loop number:" $i
      service[i]=$($PSQL "SELECT * FROM services WHERE service_id=$i" | grep "[0-9] |" | sed 's/ |//g'  | sed 's/ //g' | sed -E "s|$i||")


      #echo ${service[*]}


done


SALON_MENU

