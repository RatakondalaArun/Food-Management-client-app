# Food-Management-client-app

An application for Food Management client check in app
made with flutter

### How it works?

This app scan QR code and send a request to server with *user UID*,
than server process the request and response with this 5 status code,
for each status code a result will be provided.

| Response Code  | FeedBack to user |
| -------------- | ---------------- |
| `380`  | Successfully Updated       |
| `381`  | Already Exists             |
| `382`  | Unknown Error              |
| `404.1`| Invalid User ID            |
| `404.2`| Invalid Mode               |

## Server-side
- For server side code refer [GitHub repo](https://github.com/monish-1234/Food-Management-Using-Flutter-PHP-and-SQL)
### How it works?
This Script Decodes the JSON, Verifies the USER ID, 
Checks/Updates the DB and send back appropriate response codes.

