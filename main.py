import asyncio
from concurrent.futures import ProcessPoolExecutor, as_completed
from contextlib import redirect_stdout
import io
import multiprocessing
import time
from fastapi import FastAPI, WebSocket, Form
from flask import jsonify
from pydantic import BaseModel

class CodeRequest(BaseModel):
    code: str
    fileUrl: str | None = None
    dependencies: str | None = None
    messageId: str | None = None
    userId: str | None = None

class CodeResponse(BaseModel):
    codeOutput: str
    codeError: str | None = None
    fileUrl: str | None = None
    messageId: str | None = None
    userId: str | None = None

app = FastAPI()
executor = ProcessPoolExecutor(max_workers=25)

def worker(task_params):
    # Capture stdout output
    stdout_capture = io.StringIO()

    # TODO: Add code to download the file from the given URL
    # TODO: Add code to install the dependencies
    
    # Security measures: Pre-execution checks can go here
    # Example: Regex to disallow certain patterns, static code analysis, etc.
    
    execution_result = {"output": "", "errors": ""}
    try:
        # Redirect stdout to capture print statements from the executed code
        with redirect_stdout(stdout_capture):
            # Execute the code within the defined safe environment
            exec(task_params["code"])
    except Exception as e:
        execution_result["errors"] = str(e)
    
    # Capture any output from the execution
    execution_result["output"] = stdout_capture.getvalue()
    
    # Return the execution result
    return execution_result

# Receives a JSON body as : 
# {
#     "code": "string",
#     "fileUrl": "string" or null (S3 temporary URL for data processing)
#     "dependencies": "string" or null (comma separated list of dependencies)
#     "messageId": "string" or null (messageId of the message that initiated the request)
#     "userId": "string" or null (userId of the user that initiated the request)
# }
# Returns a JSON body as :
# {
#     "codeOutput": "string",
#     "codeError": "string" or null,
#     "fileUrl": "string" or null (S3 temporary URL of a generated file),
#     "messageID": "string" or null (messageId of the message that initiated the request),
#     "userId": "string" or null (userId of the user that initiated the request)
# }
# Downloads the file from the given URL, runs the code in a secure environment and returns the output and error if any
# pass the code to one of the worker nodes and get the response
@app.post("/api/generateCodeResponse")
async def generateCodeResponse(request: CodeRequest):
    loop = asyncio.get_running_loop()
    
    # Submit a task to the pool and wait for the result asynchronously
    task_params = {
        "code": request.code,
        "fileUrl": request.fileUrl,
        "dependencies": request.dependencies,
    }
    future_result = loop.run_in_executor(executor, worker, task_params)
    result = await future_result
    
    return CodeResponse(codeOutput=result["output"], codeError=result["errors"], fileUrl=request.fileUrl, messageId=request.messageId, userId=request.userId)
