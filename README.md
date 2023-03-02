# Hotel Booking Dashboard

Team members: Mengjun Chen, Wilfred Hass, Mohammad Reza Nabizadeh, Roan
Raina

## Hotel Industry at a Glace!

The purpose of this visualization dashboard is to present the hotel
booking data for exploratory data analysis (EDA) and predictive
purposes. The primary objective of the dashboard is to summarize booking
information, including the number of bookings, cancellation rates,
average booking value, and other important metrics. This allows users to
gain a comprehensive understanding of the data and identify significant
patterns and trends. The dashboard also serves as a valuable tool for
hotel managers and marketers to make informed decisions regarding
pricing, promotions, and inventory management. For instance, the
dashboard showcases the most popular countries for bookings, the most
frequently booked room types, and the periods with the highest booking
rates.

## Use the App

You can access the deployed app on [shinyapps.io here](https://wilfhass.shinyapps.io/shiny_hotel_booking/)!

## About the Data

The data set presented and used in this project is adopted from the
[Hotel booking
demand](https://www.kaggle.com/datasets/jessemostipak/hotel-booking-demand)
data set on the Kaggle website. The data set comprises of reservation
details for a city hotel and a resort hotel. It contains information
about the booking date, duration of the stay, number of adults,
children, and babies, available parking spaces, and other related data.
A more in-depth explanation can be found in [the proposal](Proposal.md).
data dictionary.

## Description of the Dashboard

This dashboard contains three major sections:

-   `The interactivity control box`: This section of the dashboard
    enables the user to filter the data based on the date, hotel type,
    etc. to generate their desired plots.
-   `The map box`: This section contains an interactive map of countries
    that is highlighted based on the user's metric of choice.
-   `The chart box`: This section presents up to four plots of the
    metrics that the user chooses for the given filters.

The interactivity control box will allow the user to choose filters for
the data based on some of the data set features and metrics that the
user wants to view in the map box and the chart box sections. The
metrics could include things such as the total bookings for a country,
the average price of bookings in a country, etc. The filters will be in
the form of a date range of bookings, a dropdown list to select the
hotel type and a dropdown list to select multiple countries. Users will
then be able to compare the distributions of the metrics in the chart
box section to see if certain countries have the amenities or
hindrances, within range of the given filters.

## Sketch

![](img/sketch.png)
