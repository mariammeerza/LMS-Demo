from flask import Flask, request, jsonify
from app_cmd import query_engine, index, conversation_history

app = Flask(__name__)
# cors = CORS(app)
app.config['CORS_HEADERS'] = 'Content-Type'

@app.route('/query', methods=['GET'])
def hello_world():
    print("msg")
    query = request.args.get('query') if request.method == 'GET' else request.form.get('query')
    print(query)
    if query is not None:
        query_engine = index.as_query_engine()
        response = query_engine.query(query)
        conversation_history.append(f"user: {query}")
        context = " ".join(conversation_history)
        # Get the response from the query engine
        response = query_engine.query(context)
        return jsonify({"response": str(response)})
    else:
        return jsonify({"error": "query field is missing"}), 400
    # return 'Hello, World!'

# @app.route('/chat', methods=['GET', 'POST'])
# # @cross_origin()
# def chat():
#     query = request.args.get('query') if request.method == 'GET' else request.form.get('query')
#     if query is not None:
#         query_engine = index.as_query_engine()
#         response = query_engine.query(query)
#         return jsonify({"response": str(response)})
#     else:
#         return jsonify({"error": "query field is missing"}), 400
    
if __name__ == '__main__':
    app.run()


# from flask import Flask, request, jsonify
# from app_cmd import query_engine  # Import the query_engine from your appimport.py

# app = Flask(__name__)

# @app.route('/chat', methods=['POST'])
# def chat():
#     print("my message")
#     data = request.json
#     print(data)
#     user_message = data.get('message')
#     response = query_engine.query(user_message)  # Use your query engine to get the response
#     return jsonify({'response': response})

# @app.route('/query', methods=['POST'])
# def testing_query():
#     print("message")
#     payload = request.get_json()
#     name = payload.get("name")
#     hsn_code = payload.get("hsn_code")
#     print("My message")
#     # brand_name = payload.get("brand_name")
#     # currency = payload.get("currency")

# if __name__ == '__main__':
#     app.run(debug=True)


# # from flask import Flask, request, jsonify
# # from app_cmd import query_engine

# # app = Flask(__name__)

# # @app.route('/query', methods=['POST'])
# # def query():
# #     data = request.json
# #     user_query = data['query']
# #     response = query_engine.query(user_query)
# #     return jsonify({'response': response})

# # if __name__ == '__main__':
# #     app.run(debug=True)
