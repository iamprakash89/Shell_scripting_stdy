#This script will gateher the input from the user and compared the values. If the values are negative , the condition will be end. IF not the next condidtion is checked and verifying the voting age.

#/bin/bash

echo "enter the age from 18 to 120"

read voteage

if [ $voteage -lt 0 ]
then
        echo " you have entered $voteage,enter the number between 18 to 120"

elif [ $voteage -gt 18 ] && [ $voteage -lt 121 ]
then
        echo "you are elgible for voting"
else
        echo "you are not eligible for voting"
fi
