import os
# Set your OpenAI API key
os.environ['OPENAI_API_KEY'] = "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"

from llama_index.core import StorageContext, load_index_from_storage

# Initialize the storage context and load the index
storage_context = StorageContext.from_defaults(persist_dir='./storage')
index = load_index_from_storage(storage_context)
# chat_engine = index.as_chat_engine(chat_mode="react", llm=llm, verbose=True)

query_engine = index.as_query_engine()

# Initialize an empty list to store the conversation history
conversation_history = []

# Interactive loop for querying the AI tutor
# while True:
#     query = input()

#     if query.lower() == 'exit':
#         print("All the best! Happy studying.")
#         break

#     # Add the user's query to the conversation history
#     conversation_history.append(f"user: {query}")

#     # Concatenate the conversation history to form the context for the query
#     context = " ".join(conversation_history)
#     # Get the response from the query engine
#     response = query_engine.query(context)

#     # Add the AI's response to the conversation history
#     conversation_history.append(f"AI Tutor: {response}")

#     print("\nAI Tutor :)", response)
#     print(" ")

