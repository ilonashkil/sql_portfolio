# Project Title: Netflix Personal Data Exploration

This project involves exploring personal viewing habits on Netflix by analyzing data downloaded from a user's Netflix account. The data is cleaned and organized using SQL and visualized in a dashboard using Tableau Public.

## Downloading Data from Netflix

To download personal data from Netflix, follow these steps:

1. Log in to your Netflix account and go to the "Account" page.
2. Scroll down to the "My Profile" section and click on "Viewing activity."
3. Click on the "Download all" button at the bottom of the page.
4. You will receive an email from Netflix with a link to download a zip file containing your data.

## Cleaning and Preparing Data

The downloaded data is cleaned and prepared for analysis using SQL. The cleaning steps include:

- Creating separate columns for TV show names, seasons, and episodes using the SPLIT_PART function
- Creating a column for content type (movie or TV show) based on whether the tv_show_name column is null or not
- Converting the duration data from text to interval
- Converting the start time from text to timestamp

The full SQL code for cleaning the data can be found in the project portfolio [here](https://github.com/ilonashkil/sql_portfolio/blob/main/Netflix_Personal_data_exploration/Personal_Netflix_Data_Analysis.sql)

## Visualizing Data with Tableau Public

After cleaning the data, a CSV file is uploaded to [Tableau Public](https://public.tableau.com/app/profile/ilona.shkil/viz/NetflixPersonal/Dashboard2), and a dashboard is created. The dashboard displays personal viewing habits on Netflix over a four-year period, from the beginning of 2019 until the end of 2022. The dashboard provides an overview of the user's total hours of movies and TV shows watched during this time, as well as insights into specific viewing habits.

## Personal Insights

Using the cleaned and organized data, the user can gain insights into their own viewing habits. For example:

- The user tends to watch more TV shows than movies.
- The top two TV shows watched were Friends and The Big Bang Theory.
- The user tends to watch Friends in shorter sessions of 12-20 minutes.
- The movie The Da Vinci Code proved to be a difficult movie for the user to finish, with no less than six attempts to complete it.
- The user loved the movie El Camino so much that they watched it twice, but it took five attempts to finish both times.

## Conclusion

This project demonstrates how Netflix users can download their personal data and use it to gain insights into their own viewing habits. By cleaning and organizing the data, users can gain a better understanding of their preferences and make more informed decisions about what to watch next.