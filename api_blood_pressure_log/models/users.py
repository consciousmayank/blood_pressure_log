from pydantic import BaseModel


class User(BaseModel):
    id: int | None = None
    email: str
    fcm_token: str | None = None


class UserIn(User):
    password: str


class UserAvailable(BaseModel):
    user_name: str


class RefreshToken(BaseModel):
    token: str
