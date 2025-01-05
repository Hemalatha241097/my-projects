#!/bin/bash

#text_file="My name is Hemalatha. Hemalatha is my name. My daughter name is Aadhya"

read $text_file

WORDS=$(echo $text_file | cut -d " ")

echo $WORDS
 