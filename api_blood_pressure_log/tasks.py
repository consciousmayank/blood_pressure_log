import logging
from json import JSONDecodeError

import httpx
from databases import Database
from fastapi_mail import ConnectionConfig, FastMail, MessageSchema, MessageType
from starlette.responses import JSONResponse

from config import config

logger = logging.getLogger(__name__)


class APIResponseError(Exception):
    pass


async def send_simple_email_via_gmail(to: str, subject: str, body: str):
    """This function sends email via gmail servers."""
    logger.debug(f"Sending email to '{to[:3]}' with subject '{subject[:20]}'")

    mail_config = ConnectionConfig(
        MAIL_USERNAME=config.MAIL_USERNAME,
        MAIL_PASSWORD=config.MAIL_PASSWORD,
        MAIL_FROM=config.MAIL_FROM,
        MAIL_PORT=config.MAIL_PORT,
        MAIL_SERVER=config.MAIL_SERVER,
        MAIL_FROM_NAME=config.MAIL_FROM_NAME,
        MAIL_STARTTLS=True,
        MAIL_SSL_TLS=False,
        USE_CREDENTIALS=True,
        VALIDATE_CERTS=True,
    )

    try:
        message = MessageSchema(
            subject=subject,
            recipients=[to],
            body=body,
            subtype=MessageType.html,
        )

        fm = FastMail(mail_config)
        await fm.send_message(message)

        logger.debug(f"Sent email to '{to[:3]}' with subject '{subject[:20]}'")

        return JSONResponse(status_code=200, content={"message": "email has been sent"})
    except httpx.HTTPStatusError as err:
        raise APIResponseError(
            f"API request failed with status code {err.response.status_code}"
        ) from err


async def send_simple_email(to: str, subject: str, body: str):
    logger.debug(f"Sending email to '{to[:3]}' with subject '{subject[:20]}'")
    async with httpx.AsyncClient() as client:
        try:
            response = await client.post(
                f"https://api.mailgun.net/v3/{config.MAILGUN_DOMAIN}/messages",
                auth=("api", config.MAILGUN_API_KEY),
                data={
                    "from": f"Jose Salvatierra <mailgun@{config.MAILGUN_DOMAIN}>",
                    "to": [to],
                    "subject": subject,
                    "text": body,
                },
            )
            response.raise_for_status()

            logger.debug(response.content)

            return response
        except httpx.HTTPStatusError as err:
            raise APIResponseError(
                f"API request failed with status code {err.response.status_code}"
            ) from err


async def send_user_registration_email(email: str, confirmation_url: str):
    return await send_simple_email_via_gmail(
        email,
        "Successfully signed up",
        f"""\
        <html>
        <body>
            <p style="font-size:35px"><span class="s1">Hi <b>{email}</b>!</span></p>
    <p style="font-size:26px"><span class="s1">You have successfully signed up to the Social Api. Please verify your
            email by
            entering the below OTP in the mobile application.</span></p>
    <p style="font-size:40px"><span class="s1"><b>{confirmation_url}</b></span></p>
        </body>
        </html>
        """,
    )


async def _generate_cute_creature_api(prompt: str):
    logger.debug("Generating cute creature")
    async with httpx.AsyncClient() as client:
        try:
            response = await client.post(
                "https://api.deepai.org/api/cute-creature-generator",
                data={"text": prompt},
                headers={"api-key": config.DEEPAI_API_KEY},
                timeout=60,
            )
            logger.debug(response)
            response.raise_for_status()
            return response.json()
        except httpx.HTTPStatusError as err:
            raise APIResponseError(
                f"API request failed with status code {err.response.status_code}"
            ) from err
        except (JSONDecodeError, TypeError) as err:
            raise APIResponseError("API response parsing failed") from err


