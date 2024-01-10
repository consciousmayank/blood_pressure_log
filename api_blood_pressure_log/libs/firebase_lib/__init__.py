from config import config

from functools import lru_cache

import firebase_admin
from firebase_admin import credentials, messaging

from database import database, user_table


@lru_cache()
def get_firebase_client():
    firebase_cred = credentials.Certificate(config.GOOGLE_SERVER_KEY_JSON_PATH)
    firebase_app = firebase_admin.initialize_app(firebase_cred)
    return firebase_app


async def send_single_notification(user_id: int, title: str, body: str, data: dict = None):
    try:
        get_firebase_client()
        query = user_table.select().where(user_table.c.id == user_id)
        row = await database.fetch_one(query)
        # This registration token comes from the client FCM SDKs.
        registration_token = row["fcm_token"]

        # See documentation on defining a message payload.
        message = messaging.Message(
            data=data,
            notification=messaging.Notification(title="title", body="body"),
            token=registration_token,
        )

        response = messaging.send(message)
        # Response is a message ID string.
        return response
    except Exception as e:
        return e


async def send_notification_to_all(title: str, body: str, data: dict = None):
    try:
        get_firebase_client()
        query = user_table.select()
        allUsers = await database.fetch_all(query)
        registration_tokens: list[str]
        # This registration token comes from the client FCM SDKs.
        for singleToken in allUsers:
            registration_tokens.append(singleToken["fcm_token"])

        # See documentation on defining a message payload.
        message = messaging.MulticastMessage(
            data=data,
            notification=messaging.Notification(title="title", body="body"),
            tokens=registration_tokens,
        )

        # Send a message to the device corresponding to the provided
        # registration token.
        response = messaging.send(message)
        # Response is a message ID string.
        print('Successfully sent message:', response)
    except Exception as e:
        print(f"Error:, {e.__repr__()}")
