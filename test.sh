#!/bin/bash

# Define the URL of the FastAPI application
URL="http://localhost:8000/api/generateCodeResponse"

# Send a request with a simple print statement
curl -X 'POST' "$URL" \
  -H 'accept: application/json' \
  -H 'Content-Type: application/json' \
  -d @- <<EOF
{
  "code": "print('Hello, world!')",
  "fileUrl": null,
  "dependencies": null,
  "messageId": "1",
  "userId": "user1"
}
EOF

# Send a request that calculates a mathematical expression
curl -X 'POST' "$URL" \
  -H 'accept: application/json' \
  -H 'Content-Type: application/json' \
  -d @- <<EOF
{
  "code": "print(2 + 2 * 10)",
  "fileUrl": null,
  "dependencies": null,
  "messageId": "2",
  "userId": "user2"
}
EOF

# Send a request that iterates over a list
curl -X 'POST' "$URL" \
  -H 'accept: application/json' \
  -H 'Content-Type: application/json' \
  -d @- <<EOF
{
  "code": "for i in range(5): print(i)",
  "fileUrl": null,
  "dependencies": null,
  "messageId": "3",
  "userId": "user3"
}
EOF

# Send a request with a multiline script
curl -X 'POST' "$URL" \
  -H 'accept: application/json' \
  -H 'Content-Type: application/json' \
  -d @- <<EOF
{
  "code": "def greet(name):\\n    return f'Hello, {name}!'\\n\\nprint(greet('FastAPI'))",
  "fileUrl": null,
  "dependencies": null,
  "messageId": "4",
  "userId": "user4"
}
EOF

# Attempt to access a file (this should be handled securely by your API)
curl -X 'POST' "$URL" \
  -H 'accept: application/json' \
  -H 'Content-Type: application/json' \
  -d @- <<EOF
{
  "code": "with open('/etc/passwd') as f:\\n    print(f.read_line())",
  "fileUrl": null,
  "dependencies": null,
  "messageId": "securityTest",
  "userId": "user5"
}
EOF

# Send a request with a more complex function and sleep to simulate long processing
curl -X 'POST' "$URL" \
  -H 'accept: application/json' \
  -H 'Content-Type: application/json' \
  -d @- <<EOF
{
  "code": "import time\\ndef complex_computation():\\n    print('Starting complex computation...')\\n    time.sleep(5)\\n    return 'Computation finished'\\n\\nif __name__ == '__main__':\\n    result = complex_computation()\\n    print(result)",
  "fileUrl": null,
  "dependencies": null,
  "messageId": "complex1",
  "userId": "userComplex1"
}
EOF

# Send a request with a function that generates a list of numbers, simulates processing with sleep
curl -X 'POST' "$URL" \
  -H 'accept: application/json' \
  -H 'Content-Type: application/json' \
  -d @- <<EOF
{
  "code": "import time\\ndef generate_numbers(n):\\n    for i in range(n):\\n        time.sleep(1)\\n        yield i\\n\\nif __name__ == '__main__':\\n    for number in generate_numbers(3):\\n        print(f'Generated number: {number}')",
  "fileUrl": null,
  "dependencies": null,
  "messageId": "generator1",
  "userId": "userGenerator1"
}
EOF

# Send a request with a recursive function to simulate CPU-bound computation
curl -X 'POST' "$URL" \
  -H 'accept: application/json' \
  -H 'Content-Type: application/json' \
  -d @- <<EOF
{
  "code": "import time\\ndef recursive_computation(n):\\n    if n <= 1:\\n        return n\\n    else:\\n        time.sleep(1) # Simulate processing time\\n        return recursive_computation(n-1) + recursive_computation(n-2)\\n\\nif __name__ == '__main__':\\n    result = recursive_computation(5)\\n    print(f'Result of recursive computation: {result}')",
  "fileUrl": null,
  "dependencies": null,
  "messageId": "recursive1",
  "userId": "userRecursive1"
}
EOF

# Send a request executing a loop that simulates long running task with sleep inside
curl -X 'POST' "$URL" \
  -H 'accept: application/json' \
  -H 'Content-Type: application/json' \
  -d @- <<EOF
{
  "code": "import time\\nfor i in range(3):\\n    print(f'Starting iteration {i}')\\n    time.sleep(2)\\n    print('Iteration complete')\\nprint('All iterations complete')",
  "fileUrl": null,
  "dependencies": null,
  "messageId": "loop1",
  "userId": "userLoop1"
}
EOF

