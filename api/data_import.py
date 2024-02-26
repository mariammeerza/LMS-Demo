import os

os.environ['OPENAI_API_KEY'] = "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"

from llama_index.core import VectorStoreIndex, SimpleDirectoryReader

docse = SimpleDirectoryReader('./data').load_data()
index = VectorStoreIndex.from_documents(docse)

index.storage_context.persist()
print("Done") 

