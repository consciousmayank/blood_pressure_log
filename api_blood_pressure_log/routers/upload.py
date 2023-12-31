import logging
import tempfile
from typing import Annotated

import aiofiles
from fastapi import APIRouter, HTTPException, UploadFile, status, Depends


from models.users import User
from security import get_current_user, check_if_user_exists

from database import database, images

from libs.b2 import b2_upload_file

logger = logging.getLogger(__name__)

router = APIRouter()

CHUNK_SIZE = 1024 * 1024


@router.post("/upload", status_code=201)
async def upload_file(
    current_user: Annotated[User, Depends(get_current_user)],
    file: UploadFile,
    record_id: int = None,
):
    if check_if_user_exists(user=current_user):
        try:
            with tempfile.NamedTemporaryFile() as temp_file:
                filename = temp_file.name
                logger.info(f"Saving uploaded file temporarily to {filename}")
                async with aiofiles.open(filename, "wb") as f:
                    while chunk := await file.read(CHUNK_SIZE):
                        await f.write(chunk)

                file_url = b2_upload_file(local_file=filename, file_name=file.filename)
                query = images.insert().values(image_url=file_url, record_id=record_id)
                last_record_id = await database.execute(query)
                return {
                    "detail": f"Successfully uploaded image {last_record_id}",
                    "file_url": file_url,
                }
        except Exception as e:
            raise HTTPException(
                status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                detail=f"There was an error uploading the file {e}",
            )
