def lambda_handler(event, context):
    print("✅ Lambda executed successfully (EventBridge Trigger)")
    return {
        "statusCode": 200,
        "message": "Lambda executed via EventBridge schedule!"
    }
