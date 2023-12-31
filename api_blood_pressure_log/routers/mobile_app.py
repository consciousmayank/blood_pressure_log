import logging
from json import JSONDecodeError

import httpx
from fastapi import APIRouter, status, HTTPException

router = APIRouter()

logger = logging.getLogger(__name__)


@router.get(
    "/app_configs",
    # response_model=list[BpmRecordOut],
)
async def get_app_config():
    try:

        response = await b2_authorize_account()
        return {'token': response['authorizationToken']}
    except Exception as e:
        return {"error": str(e)}


async def b2_authorize_account():
    async with (httpx.AsyncClient() as client):
        try:
            response = await client.get(
                "https://api.backblazeb2.com/b2api/v1/b2_authorize_account",
                headers={
                    "Authorization": "Basic MDA1Yjg0N2UwYzc0MjhiMDAwMDAwMDAwMTpLMDA1WW5CYXZ0aFFiYW0rN1NSVmxzbTNOK0hwQ1NJ"
                },
                timeout=60,
            )
            logger.debug(response)
            response.raise_for_status()
            return response.json()
        except httpx.HTTPStatusError as err:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail=f"API request failed with status code {err.response.status_code} And reason: {err.__repr__()}",
            )
        except (JSONDecodeError, TypeError) as err:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="API response parsing failed",
            )
