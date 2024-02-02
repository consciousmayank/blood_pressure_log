import logging
from random import randint

from fastapi import APIRouter, BackgroundTasks, HTTPException, Request, status, Depends

import tasks
from database import database, user_table
from libs.firebase_lib import send_single_notification
from models.fcm_token import FcmTokenIn
from models.users import UserIn, User, UserAvailable, RefreshToken
from security import (  # create_confirmation_token,
    authenticate_user,
    create_access_token,
    create_refresh_token,
    get_password_hash,
    get_user_from_user_table, get_current_user, get_subject_for_token_type,
)
from typing import Annotated

logger = logging.getLogger(__name__)
router = APIRouter()


@router.post("/register", status_code=201)
async def register(user: UserIn, background_tasks: BackgroundTasks, request: Request):
    old_user = await get_user_from_user_table(user.email)
    otp_to_verify: str = ''
    if old_user is not None:
        if old_user.c.confirmed:
            raise HTTPException(
                status_code=status.HTTP_409_CONFLICT,
                detail="A user with that email already exists",
            )
        else:
            otp_to_verify = old_user.c.verification_code

    if len(otp_to_verify) == 0:
        otp_to_verify = str(randint(100000, 999999))

    try:

        # insert otp_to_verify to user_table
        user_id = await database.execute(user_table.insert().values(
            email=user.email,
            password=get_password_hash(password=user.password),
            confirmed=False,
            verification_code=otp_to_verify
        ))
        print(otp_to_verify)
        print(user_id)

        background_tasks.add_task(
            tasks.send_user_registration_email,
            user.email,
            confirmation_url=otp_to_verify,
        )
        return {
            "detail": "User created. Please confirm your email.",
            "OTP": otp_to_verify,
        }

    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=str(e),
        )


@router.post("/token")
async def login(user: UserIn):
    user = await authenticate_user(user.email, user.password)
    access_token = create_access_token(user.email)
    refresh_token = create_refresh_token(email=user.email)
    return {"access_token": access_token, "token_type": "bearer", "refresh_token": refresh_token}


@router.post("/token_refresh")
async def token_refresh(refresh_token: RefreshToken):
    user_email = get_subject_for_token_type(token=refresh_token.token, token_type="refresh")
    access_token = create_access_token(user_email)
    return {"access_token": access_token, "token_type": "refresh", "refresh_token": refresh_token.token}


@router.get("/verify/{otp}")
async def verify_email_via_otp(otp: str):
    user_with_received_otp_query = user_table.select().where(
        user_table.c.verification_code == otp
    )

    user_with_received_otp = await database.fetch_one(user_with_received_otp_query)

    if user_with_received_otp is None:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Otp does not match",
        )
    else:
        if user_with_received_otp.verification_code != otp:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Otp does not match",
            )
        else:
            user_id = await database.execute(user_table.update().values(
                confirmed=True,
                verification_code=None
            ))
    return {"detail": "User confirmed", "user_id": user_id}


@router.post("/saveFcmToken")
async def save_fcm_token(
        current_user: Annotated[User, Depends(get_current_user)],
        token: FcmTokenIn,
):
    try:
        print(token)
        if token is None:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Token cannot be empty",
            )
        query = user_table.update().where(user_table.c.id == current_user.id).values(fcm_token=token.token)
        edited_row = await database.execute(query)
        return {"message": "Token saved", "id": edited_row}
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=e,
        )


@router.post("/sendPushNotification", include_in_schema=False)
async def send_push_notification(current_user: Annotated[User, Depends(get_current_user)], ):
    try:

        response = await send_single_notification(user_id=current_user.id, title="Hello World", body="Hello World")

        if isinstance(response, str):
            return {
                "message": "Message Sent"
            }
        else:
            return {
                "message": "Message Not Sent"
            }

    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=e,
        )


@router.post("/user_name_available")
async def user_name_available(user: UserAvailable):
    if await get_user_from_user_table(user.user_name):
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail="A user with that email already exists",
        )
    return {"detail": "UserName Available", }
