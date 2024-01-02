
# Blood Pressure Log

In this project I am trying to learn and build 
- Api's via FastApi Python, and
- An accompanying application made in Flutter, consuming the api's. As of now the application is for Android and iOS. Plan is there to support web platform soon.



## Environment Variables

To run this project, you will need to add the following environment variables to your .env file

`ENV_STATE` - it can be dev/prod

`DEV_B2_KEY_ID`, `DEV_B2_APPLICATION_KEY` `DEV_B2_BUCKET_NAME` - for image upload in BlackBlaze
`DEV_MAIL_USERNAME`, `DEV_MAIL_PASSWORD`, `DEV_MAIL_FROM`, `DEV_MAIL_PORT`, `DEV_MAIL_SERVER`, `DEV_MAIL_FROM_NAME` - for sending mail via Gmail Smtp Server.
`DEV_FAST_API_ANALYTICS` - for analytics.


## Features

Api Side
- Register User
- Login User
- Implementation of JWT Token, for authorization.
- OTP Verification via mail. Using gmail smtp server.
- Save a blood pressure reading (systolic and diastolic Values).
- Provision of Image upload to BlackBlaze.
- Retrieve all the records from DB.

Application
- Sign In 
- Sign up
- Saving of token in shared preferences, and sending in headers, to api's which require them
- Fetching all the records and showing them as per the date entered.
- Showing the image from BlackBlaze bucket. The bucket is private and can be downloaded only after fetching the image_token from BlackBlaze.




## Roadmap

- Provision to update a record, where user can update the diastolic, systolic values and image. Once done the time will be saved in updated_on.
- Implement pagination while fetching records.
- Profile for a user. 
- Push notification implementation
- A better and mordern looking UI for the application. As of now only using the native elements from flutter.
- Support the web front of the application too with proper UI.


