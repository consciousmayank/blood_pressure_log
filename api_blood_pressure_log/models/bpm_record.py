from datetime import datetime
from pydantic import BaseModel
from typing import Optional


class BpmRecord(BaseModel):
    id: int | None = None


class BpmRecordIn(BpmRecord):
    systolic_value: int
    diastolic_value: int
    image_url: str | None


class BpmRecordOut(BpmRecord):
    systolic_value: int
    diastolic_value: int
    log_date: datetime
    image_url: Optional[str] = None
