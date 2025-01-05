#!/bin/bash

#text_file="My name is Hemalatha. Hemalatha is my name. My daughter name is Aadhya"

text_file=$(read textfile)

WORDS=$(echo $text_file | cut -d " " -f1)

echo $WORDS
