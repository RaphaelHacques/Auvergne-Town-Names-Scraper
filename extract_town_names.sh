#!/bin/bash

# URL of the webpage
url="https://www.annuaire-administration.com/commune/region/auvergne.html"

# Download the webpage content using curl
html_content=$(curl -s "$url")

# Extract the content of the target table using awk
table_content=$(echo "$html_content" | awk '/<table.*class="departement_commune"/,/<\/table>/')

# Remove HTML tags and extract lines containing "Commune de"
cleaned_content=$(echo "$table_content" | sed -n -e 's/<[^>]*>//g' -e '/Commune de/p')

# Remove "Commune de"
cleaned_content_without_prefix=$(echo "$cleaned_content" | sed -e 's/Commune de//g')

# Remove special characters and invisible characters
cleaned_municipalities=$(echo "$cleaned_content_without_prefix" | sed -e 's/[^[:print:]]//g')

# Store cleaned municipalities in an array
IFS=$'\n' read -d '' -r -a municipalities <<< "$cleaned_municipalities"

# Function to choose a random municipality
choose_random_municipality() {
  rand_index=$(( RANDOM % ${#municipalities[@]} ))
  selected_municipality="${municipalities[$rand_index]}"
}

# Loop to prompt user and choose a random municipality
while true; do
  choose_random_municipality
  echo "Do you want to choose a random municipality from Auvergne? (y/n)"
  read choice
  if [ "$choice" = "y" ]; then
    echo "Selected municipality: $selected_municipality"
  else
    break
  fi
done
