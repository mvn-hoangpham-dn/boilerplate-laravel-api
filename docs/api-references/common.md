Application API
=======

# Overview

API document for Application
Verion: 1.0

## Post data to server
All request form data must be in `json` format

- Request header `Content-Type`: `application/json`
- Request body content : `json` format.

## Authentication

##### Client
- Call the login api, send params to server
    + username
    + password
    + device_token
    + device_type: android | ios

##### Server
- Check credential, if OK then generate a `api_token`
- Send `api_token` back to client

When client access the protected endpoints they have to send back `api_token` to server. There are to ways to send:

- Request query: http(s)://api-endpoind?api_token=token_value
- Request header
    + Header key: Authorization
    + Header value: Bearer token_value

##### Params sent to server side
- client_id: This is code to verify use API, it's private.
- api_token: Code from auth

## Error response

- `4xx`: client error
- `5xx`: server error

|Status code| Meaning|
|---|---|
|400|Bad request|
|401|Unauthoziration|
|403|Permission denied|
|500|Internal server error|

#### Body response
All response body in case error must follow the format
```json
{
    "message": "The error content message"
}
```

`400` is also used in case validation error

## Maintenance

#### Response
- Status code: 503
- Body:
```json
{
    "message": "Maintenance message"
}
```

# EndPoint
