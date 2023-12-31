from datetime import datetime
from http.client import HTTPException
import logging
from typing import Annotated
from sqlalchemy import select, join
from fastapi import APIRouter, Depends
from models.bpm_record import BpmRecordIn, BpmRecordOut

from database import database, bpm_record, images

from models.users import User
from security import get_current_user

router = APIRouter()

logger = logging.getLogger(__name__)


@router.get(
    "/get_records",
    # response_model=list[BpmRecordOut],
)
async def get_records(current_user: Annotated[User, Depends(get_current_user)], ):
    try:
        all_records_query = bpm_record.select().where(bpm_record.c.user_id == current_user.id)
        all_records = await database.fetch_all(all_records_query)
        result = []
        for record in all_records:
            image_for_record_query = images.select().where(images.c.record_id == record.id)
            image = await database.fetch_one(image_for_record_query)
            image_url = ""
            if image is not None:
                image_url = image.image_url
            result.append(
                BpmRecordOut(image_url=image_url, systolic_value=record.systolic_value,
                             diastolic_value=record.diastolic_value,
                             log_time=record.log_date, id=record.id, ), )

        return result
    except Exception as e:
        return {"error": str(e)}


@router.post("/save_record", status_code=201)
async def save_record(
        record: BpmRecordIn, current_user: Annotated[User, Depends(get_current_user)]
):
    try:
        data = {
            **record.model_dump(),
            "user_id": current_user.id,
            "log_date": datetime.now(),
        }
        query = bpm_record.insert().values(data)
        last_record_id = await database.execute(query)
        return {"id": last_record_id}

    except Exception as e:
        return {"error": str(e)}
