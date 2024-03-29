import datetime
import logging
from typing import Annotated, Literal

from fastapi import Depends, HTTPException, status
from fastapi.security import OAuth2PasswordBearer
from jose import ExpiredSignatureError, JWTError, jwt
from passlib.context import CryptContext

from database import database, user_table
from models.users import User

logger = logging.getLogger(__name__)

SECRET_KEY = "9b73f2a1bdd7ae163444473d29a6885ffa22ab26117068f72a5a56a74d12d1fc"
ALGORITHM = "HS256"
oauth2_scheme = OAuth2PasswordBearer(tokenUrl="token")
pwd_context = CryptContext(schemes=["bcrypt"])


def create_credentials_exception(detail: str) -> HTTPException:
    return HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail=detail,
        headers={"WWW-Authenticate": "Bearer"},
    )


def access_token_expire_minutes() -> int:
    return 60 * 60 * 24 * 1  # 1 day (in minutes)


def refresh_token_expire_minutes() -> int:
    return 60 * 60 * 24 * 3  # 3 days (in minutes)


def create_access_token(email: str):
    logger.debug("Creating access token", extra={"email": email})
    expire = datetime.datetime.now(datetime.timezone.utc) + datetime.timedelta(
        minutes=access_token_expire_minutes()
    )
    jwt_data = {"sub": email, "exp": expire, "type": "access"}
    encoded_jwt = jwt.encode(jwt_data, key=SECRET_KEY, algorithm=ALGORITHM)
    return encoded_jwt


def create_refresh_token(email: str):
    logger.debug("Creating refresh token", extra={"email": email})
    expire = datetime.datetime.now(datetime.timezone.utc) + datetime.timedelta(
        minutes=refresh_token_expire_minutes()
    )
    jwt_data = {"sub": email, "exp": expire, "type": "refresh"}
    encoded_jwt = jwt.encode(jwt_data, key=SECRET_KEY, algorithm=ALGORITHM)
    return encoded_jwt


def get_subject_for_refresh_token(token: str, ) -> str:
    try:
        payload = jwt.decode(token, key=SECRET_KEY, algorithms=[ALGORITHM])
    except ExpiredSignatureError as e:
        raise create_credentials_exception("Token has expired") from e
    except JWTError as e:
        raise create_credentials_exception("Invalid token") from e

    email = payload.get("sub")
    if email is None:
        raise create_credentials_exception("Token is missing 'sub' field")

    token_type = payload.get("type")
    if token_type is None or token_type != token_type:
        raise create_credentials_exception(
            f"Token has incorrect type, unexpected type '{token_type}'"
        )

    return email


def get_subject_for_token_type(
        token: str, token_type: Literal["access", "refresh"]
) -> str:
    try:
        payload = jwt.decode(token, key=SECRET_KEY, algorithms=[ALGORITHM])
    except ExpiredSignatureError as e:
        raise create_credentials_exception("Token has expired") from e
    except JWTError as e:
        raise create_credentials_exception("Invalid token") from e

    email = payload.get("sub")
    if email is None:
        raise create_credentials_exception("Token is missing 'sub' field")

    token_type = payload.get("type")
    if token_type is None or token_type != token_type:
        raise create_credentials_exception(
            f"Token has incorrect type, unexpected type '{token_type}'"
        )

    return email


def get_password_hash(password: str) -> str:
    return pwd_context.hash(password)


def verify_password(plain_password: str, hashed_password: str) -> bool:
    return pwd_context.verify(plain_password, hashed_password)


async def get_user(email: str):
    logger.debug("Fetching user from the database", extra={"email": email})
    query = user_table.select().where(user_table.c.email == email)
    result = await database.fetch_one(query)
    if result:
        return result


async def check_if_user_exists(user: User) -> bool:
    query = user_table.select().where(user_table.c.id == user.id)
    result = await database.fetch_one(query)
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    return True


# async def get_user_from_temp_user_table(email: str):
#     logger.debug("Fetching user from the pre_otp_verification_user_table", extra={"email": email})
#     query = otp_verification_table.select().where(user_table.c.email == email)
#     result = await database.fetch_one(query)
#     if result:
#         return result


async def get_user_from_user_table(email: str):
    query = user_table.select().where(user_table.c.email == email)
    result = await database.fetch_one(query)
    if result:
        return result


async def authenticate_user(email: str, password: str):
    user = await get_user(email)
    if not user:
        raise create_credentials_exception("Invalid email or password")
    if not verify_password(password, user.password):
        raise create_credentials_exception("Invalid email or password")
    if not user.confirmed:
        raise create_credentials_exception("User has not confirmed email")
    return user


async def get_current_user(token: Annotated[str, Depends(oauth2_scheme)],
                           # token_type: Literal["access", "refresh"] = 'access',
                           ):
    email = get_subject_for_token_type(token, "access")
    user = await get_user(email=email)
    if user is None:
        raise create_credentials_exception("Could not find user for this token")
    return user
