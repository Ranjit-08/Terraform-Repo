def lambda_handler(event, context):
    print("Hello from Lambda!")
    return {"statusCode": 200, "message": "Log group working!"}
