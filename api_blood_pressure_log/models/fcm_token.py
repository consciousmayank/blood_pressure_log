from pydantic import BaseModel, Field


class FcmTokenIn(BaseModel):
    token: str = "" #= Field(None, description="The fcm token received from the front end")
