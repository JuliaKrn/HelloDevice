# HelloDevice
A project that loads information about all devices enrolled in the HelloWorld enterprise product.

## Description

This project provides an API to retrieve information about all devices enrolled in the HelloWorld enterprise product and present it in the form of macOS app for HelloWorld admins.

## Existing Features

- Fetches data on enrolled devices
- Displays information such as user name, access code and the latest date of scan
- Displays administrator name
- Supports search by user name
- Supports pagination and basic error handling

## Features to be added later
- Adding loading state representation while waiting for API response
- Better error hadling by adding more UI friendly localised error massage and posibility to retry the request 
- Secure storage of token
- Improvement of app architecture
