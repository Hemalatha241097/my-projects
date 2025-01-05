#!/bin/bash

#text_file="My name is Hemalatha. Hemalatha is my name. My daughter name is Aadhya"

text_file=$(read textfile)

WORDS=$(cut -d " " -f1 $text_file)

echo $WORDS
