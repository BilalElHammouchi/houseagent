# House Agent

This project is a Flutter application that utilizes artificial neural networks and DialogFlow to provide a house price prediction service. It was developed for the Hackathon I2A'01 contest.

## Website
https://houseprices-agent-vkjq.web.app/


## Table of Contents

- [Description](#description)
- [Features](#features)
- [Screenshots](#screenshots)
- [Technologies Used](#technologies-used)
- [Setup and Usage](#setup-and-usage)
- [Contributing](#contributing)

## Description

The project consists of a Flutter application with two main pages: 

1. **House Property Input Page**: This page allows users to input relevant details of a house, such as number of bedrooms, bathrooms, square footage, etc. The input data is sent to the Flask backend for house price prediction using artificial neural networks and TensorFlow.

2. **Chat Window with DialogFlow**: This page provides a chat interface where users can communicate with the DialogFlow agent. The agent responds to user queries and facilitates the conversation.

The application's backend is built with Flask, which handles the machine learning tasks for house price prediction and handles the post requests from DialogFlow. Firebase is used for hosting the site, while PythonAnywhere hosts the Flask backend.

## Features

- House price prediction based on input property details
- Interactive chat interface with DialogFlow agent
- Seamless integration of Flutter, TensorFlow, Flask, DialogFlow, Firebase, and PythonAnywhere

## Screenshots

![Measurements Page](https://github.com/GoldenDovah/houseagent/assets/19519174/216ec9f8-2c39-45c7-a102-5611f398e5a5)

![Chat Page](https://github.com/GoldenDovah/houseagent/assets/19519174/17c2de7c-df40-473b-a71b-809982dec123)


## Technologies Used

- Flutter
- TensorFlow
- Flask
- DialogFlow
- Firebase
- PythonAnywhere

![architecture](https://github.com/GoldenDovah/houseagent/assets/19519174/6137d3d3-10ef-44e9-bde7-77384a778a5f)


## Setup and Usage

To run the project locally, follow these steps:

1. Clone the repository.
2. Set up the Flutter environment on your machine.
3. Configure the necessary dependencies and packages.
4. Launch the Flutter application.
5. Connect to the Flask backend and DialogFlow agent.

## Contributing

We welcome contributions from the community! If you'd like to contribute to the project, please follow these guidelines:

1. Fork the repository.
2. Create a new branch for your feature or bug fix.
3. Develop your feature or bug fix on the branch.
4. Commit your changes and push them to your fork.
5. Create a pull request with a detailed description of your changes.

