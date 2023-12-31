import logging
from random import randint

from fastapi import APIRouter, BackgroundTasks, HTTPException, Request, status

import tasks
from database import database, otp_verification_table, user_table
from models.users import UserIn
from security import (  # create_confirmation_token,
    authenticate_user,
    create_access_token,
    get_password_hash,
    get_user_from_temp_user_table,
)

logger = logging.getLogger(__name__)
router = APIRouter()


@router.post("/register", status_code=201)
async def register(user: UserIn, background_tasks: BackgroundTasks, request: Request):
    if await get_user_from_temp_user_table(user.email):
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="A user with that email already exists",
        )

    otp_to_verify = str(randint(100000, 999999))

    try:
        otp_verification_table_insert_query = otp_verification_table.insert().values(
            email=user.email,
            password=get_password_hash(user.password),
            verification_code=otp_to_verify,
        )

        logger.debug(otp_verification_table_insert_query)
        await database.execute(otp_verification_table_insert_query)

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
    return {"access_token": access_token, "token_type": "bearer"}


@router.get("/verify/{otp}")
async def verify_email_via_otp(otp: str):
    insert_to_users_table_query = otp_verification_table.select().where(
        otp_verification_table.c.verification_code == otp
    )

    logger.debug(f"for finding email from otp {insert_to_users_table_query}")

    user = await database.fetch_one(insert_to_users_table_query)

    if user.email is None:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="OTP not found",
        )

    insert_to_users_table_query = user_table.insert().values(
        email=user.email,
        password=user.password,
        confirmed=True,
    )

    logger.debug(insert_to_users_table_query)

    delete_from_otp_table_query = otp_verification_table.delete().where(
        otp_verification_table.c.verification_code == otp
    )

    logger.debug(delete_from_otp_table_query)

    await database.execute(insert_to_users_table_query)
    await database.execute(delete_from_otp_table_query)
    return {"detail": "User confirmed"}
