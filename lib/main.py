from flask import Flask, jsonify, request
from sklearn.preprocessing import StandardScaler, PolynomialFeatures
from flask_cors import CORS, cross_origin
import pandas as pd
import os
import numpy as np
import warnings
import pickle
import random
import tensorflow as tf

warnings.filterwarnings("ignore", message="X does not have valid feature names, but StandardScaler was fitted with feature names")


"""
    Scaler for ANN
"""
scaler = StandardScaler()
X_train = pd.read_csv(os.path.join(os.path.dirname(os.path.abspath(__file__)), 'train_data.csv'))
X_train_scaled = scaler.fit_transform(X_train)



"""
    Cleaned Multiple Non Linear Regression
"""
X_train_cleaned = pd.read_csv(os.path.join(os.path.dirname(os.path.abspath(__file__)), 'X_train_cleaned.csv'))
degree = 2
poly_features = PolynomialFeatures(degree=degree)
poly_features.fit_transform(X_train_cleaned)

mulModel_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'cleaned_mulnonlinear_model.pkl')

with open(mulModel_path, 'rb') as file:
    cleaned_mulnonlinear_model = pickle.load(file)




app = Flask(__name__)
cors = CORS(app)
app.config['CORS_HEADERS'] = 'Content-Type'

annModel_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'model.tflite')
interpreter = tf.lite.Interpreter(model_path=annModel_path)

# Get input and output details
input_details = interpreter.get_input_details()
output_details = interpreter.get_output_details()


interpreter.allocate_tensors()

@app.route('/ann', methods=['POST'])
@cross_origin()
def create_card():
    request_data = request.get_json()
    input_array = list(request_data.values())
    input_2d = np.array(input_array).reshape(1, -1)
    input_scaled = scaler.transform(input_2d)
    input_tensor = np.array(input_scaled, dtype=np.float32)
    
    # Set the input tensor data
    interpreter.set_tensor(input_details[0]['index'], input_tensor)

    interpreter.invoke()

    # Get the output tensor
    output_data = interpreter.get_tensor(output_details[0]['index'])

    print(output_data)

    response_data = {
        'price': output_data.tolist()[0][0],
    }

    return jsonify(response_data)




dictio = {
    'Bedrooms': 3,
    'bathrooms': 1,
    'sqft-living': 1180,
    'sqft-lot': 5650,
    'floors': 1,
    'waterfront': 0,
    'views': 0,
    'condition-name': 3,
    'grade': 7,
    'sqft-above': 1180,
    'sqft-basement': 0,
    'year-built': 1955,
    'year-renovated': 0,
    'latitude': 47.5112,
    'longitude': -122.257,
}

dictio_condition = {
    'Excellent': 5,
    'Good': 4,
    'Fair': 3,
    'Poor': 2,
    'Distressed': 1
}

prices = ["Here it is, the moment we've been waiting for: X dollars, an irresistible offer that's hard to believe! If the price doesn't make sense, make sure that the inputs given are consistent with each other!",
    "Drumroll, please! The final price is X dollars, an absolute bargain! If the price doesn't make sense, make sure that the inputs given are consistent with each other!",
    "Ta-da! After meticulous consideration, the price stands at X dollars, a real steal! If the price doesn't make sense, make sure that the inputs given are consistent with each other!",
    "And the price is locked in at X dollars, talk about an incredible deal! If the price doesn't make sense, make sure that the inputs given are consistent with each other!",
    "Behold, the price has been set at X dollars, an offer you can't refuse! If the price doesn't make sense, make sure that the inputs given are consistent with each other!",
    "Finally, the moment we've been waiting for! The price is X dollars, a remarkable bargain! If the price doesn't make sense, make sure that the inputs given are consistent with each other!",
    "Ladies and gentlemen, I present to you the price of X dollars – an unbeatable deal! If the price doesn't make sense, make sure that the inputs given are consistent with each other!",
    "Hold your breath as I reveal the price: X dollars, an offer too good to pass up! If the price doesn't make sense, make sure that the inputs given are consistent with each other!",
    "It's official! The price has been finalized at X dollars, a real steal of a deal! If the price doesn't make sense, make sure that the inputs given are consistent with each other!",
    "Brace yourself for the fantastic news! The price has dropped to X dollars, an incredible steal! If the price doesn't make sense, make sure that the inputs given are consistent with each other!",
    "Drumroll, please! The price is X dollars, a true gem at a wallet-friendly rate! If the price doesn't make sense, make sure that the inputs given are consistent with each other!",
    "Prepare to be amazed! The price stands at X dollars, a phenomenal value for your investment! If the price doesn't make sense, make sure that the inputs given are consistent with each other!",
    "Ladies and gentlemen, behold the price: X dollars, a steal you won't find anywhere else! If the price doesn't make sense, make sure that the inputs given are consistent with each other!",
    "Get ready for a jaw-dropping moment! The price has been set at X dollars, a fantastic bargain! If the price doesn't make sense, make sure that the inputs given are consistent with each other!",
    "Here it is, the moment we've been waiting for: X dollars, an irresistible offer that's hard to believe! If the price doesn't make sense, make sure that the inputs given are consistent with each other!"]

@app.route('/dialogflow', methods=['POST'])
@cross_origin()
def treat_request():
    print(cleaned_mulnonlinear_model.coef_)
    request_data = request.get_json()
    print(request_data)
    if request_data['queryResult']['allRequiredParamsPresent'] and ('number' in request_data['queryResult']['parameters'].keys() or 'condition' in request_data['queryResult']['parameters'].keys()):
        if 'number' in request_data['queryResult']['parameters'].keys():
            param = None
            for key in request_data['queryResult']['parameters'].keys():
                if key != 'number':
                    param = key
                    break
            num = request_data['queryResult']['parameters']['number']
            print(f"parameter found by the name of {param} with a number of {num}")
            dictio[param] = request_data['queryResult']['parameters']['number']
        elif 'condition' in request_data['queryResult']['parameters'].keys():
            con = request_data['queryResult']['parameters']['condition']
            val = dictio_condition[request_data['queryResult']['parameters']['condition']]
            print(f"condition found by the name of {con} with a value of {val}")
            dictio['condition_name'] = dictio_condition[request_data['queryResult']['parameters']['condition']]
    elif 'action' in request_data['queryResult'].keys():
        if request_data['queryResult']['action'] == 'Get-Floors.Get-Floors-no':
            print("Remove waterfront detected")
            dictio['waterfront'] = 0
        elif request_data['queryResult']['action'] == 'Get-Floors.Get-Floors-yes':
            print("Add waterfront detected")
            dictio['waterfront'] = 1
        elif request_data['queryResult']['action'] == 'Get-Longitude.Get-Longitude-yes': # Predict Price
            return send_price()
    elif 'price' in request_data['queryResult']['parameters'].keys():
        return send_price()
    print(dictio)


def send_price():
    price = int(get_prediction())
    fullfillment_text = random.choice(prices)
    fullfillment_text = fullfillment_text.replace('X', str(price))
    condition_found = None

    for key, value in dictio_condition.items():
        if value == dictio['condition-name']:
            condition_found = key
            break
    fullfillment_text += "\nThe house properties are:\n{} bedrooms,\n{} bathroom,\n{} square feet of living area,\n{} square feet of lot,\n{} floors,\n{} waterfront,\n{} views,\nin {} condition,\nwith a grade of {},\n{} square feet of above area,\n{} square feet of the basement,\nbuilt in the year {},\nrenovated in the year {},\nwith a latitude of {},\nand a longitude of {}.".format(
        dictio['Bedrooms'], dictio['bathrooms'], dictio['sqft-living'], dictio['sqft-lot'], dictio['floors'], dictio['waterfront'],
        dictio['views'], condition_found, dictio['grade'], dictio['sqft-above'], dictio['sqft-basement'], dictio['year-built'],
        dictio['year-renovated'], dictio['latitude'], dictio['longitude']
    )
    return jsonify({'fulfillmentText': fullfillment_text}) # Send Fullfillment text back to dialogflow for the end of conversation

def get_prediction():
    """
        Function that predicts the price based on house properties
    """
    params = list(dictio.values())
    print(f"Ready to predict with this list of values: {params}")
    X_new = [params]
    #reshaped_data = np.array(X_new).reshape(1, -1)
    X_new_poly = poly_features.transform(X_new)
    print(X_new_poly)
    predictions = cleaned_mulnonlinear_model.predict(X_new_poly)
    print(f"HERE ARE THE PREDICTIONS: {predictions}")
    return predictions[0]
    

json_file = {}

print("TEST")
@app.route('/')
@cross_origin()
def hello_world():
    json_file['query'] = 'Hi, this is the python backend for the Hackathon project, thanks for visiting!'
    return jsonify(json_file)


if __name__ == '__main__':
    app.run()