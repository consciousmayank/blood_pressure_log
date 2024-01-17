from datetime import datetime
import logging
from typing import Annotated
from sqlalchemy import select, join
from fastapi import APIRouter, Depends, Form, File, UploadFile, HTTPException
from starlette import status

from models.bpm_record import BpmRecordIn, BpmRecordOut

from database import database, bpm_record

from models.users import User
from routers.upload import upload_file
from security import get_current_user

router = APIRouter()

logger = logging.getLogger(__name__)


@router.get(
    "/get_records",
    response_model=list[BpmRecordOut],
)
async def get_records(current_user: Annotated[User, Depends(get_current_user), ]):
    try:
        all_records_query = bpm_record.select().where(bpm_record.c.user_id == current_user.id)
        all_records = await database.fetch_all(all_records_query)
        return all_records
    except Exception as e:
        return {"error": str(e)}


@router.post("/save_records", status_code=201)
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


@router.post("/save_record")
async def upload_record_and_image(
        current_user: Annotated[User, Depends(get_current_user)],
        diastolic_value: int = Form(...),
        systolic_value: int = Form(...),
        image: UploadFile = File(None),
):
    try:

        image_url: str = ""
        if image is not None:
            image_url = await upload_file(current_user=current_user, file=image, )
            print(f"image_url {image_url}")

        record = BpmRecordIn(systolic_value=systolic_value, diastolic_value=diastolic_value, image_url=image_url)
        # Save record data to database
        data = {
            **record.model_dump(),
            "user_id": current_user.id,
            "log_date": datetime.now(),
        }
        query = bpm_record.insert().values(data)
        saved_record_id = await database.execute(query)

        return {"message": "Record saved successfully", "id": saved_record_id}

    except Exception as e:
        return HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"API request failed with status code {e.response.status_code} And reason: {e.__repr__()}",
        )


@router.put("/update_record/{record_id}", status_code=200, response_model=BpmRecordOut)
async def update_record(current_user: Annotated[User, Depends(get_current_user)], record_id: int, record: BpmRecordIn):
    try:
        data = {
            **record.model_dump(),
            "user_id": current_user.id,
            "log_date": datetime.now(),
        }
        query = bpm_record.update().where(bpm_record.c.id == record_id).values(data)
        await database.execute(query)
        return {"id": record_id}
    except Exception as e:
        return {"error": str(e)}
