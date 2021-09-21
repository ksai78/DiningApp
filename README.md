# Dining App

#### This Dining App is a replica of the Penn Mobile Dining feature. It lists all the dining halls shown on [this figma link](https://www.figma.com/file/bFEGKMbQhgBQGYZJ0cJQHH/Penn-Mobile---iOS-Challenge?node-id=0%3A1). 

For each dining hall the following is shown: the name, the hours of operation, a picture, and a link to the dining hall's homepage. The feature left out was the ability to detect if the dining hall is open or closed based on the current time of day.

## Project Design
1. I began by designing the UI and establishing two Lists of dining halls. One was for college house dining halls and the other was for the retail dining areas. 
2. After this I used an online JSON Parser to understand the data structure of the JSON Data. 
3. Here I ran into several bugs in my organized data structure. Through trial and error, I was eventually able to model the data as a large array containing the baseline information such as the dining hall name, imageURL, facilityURL, and an array of dates with open/close times for each meal type. 
4. To decode the JSON Data I used a URLSession and then broke down the data into separate arrays for each UI Element.
5. After this there was an array for imageURLs, facilityURLs, dining location names, and hours of operation. 
6. To asychronously update image times 
7. The first 3 arrays were easy to create. For the hours of operation an extensive and non-ideal sequence of if-statements was used to format the hours out of military time and innto ranges.
8. The if-statements used could have easily been changed into a loop that checked the same conditions. However, a time constraint required the approach that would ensure accuracy. 
9. Unfortunately, at this point I didn't have time to add the open/closed option. However, this could be implemented by checking if the current time fell into the time intervals for each meal time at each location. 
