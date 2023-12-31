from datetime import datetime
from pydantic import BaseModel


class BpmRecord(BaseModel):
    id: int | None = None


class BpmRecordIn(BpmRecord):
    systolic_value: int
    diastolic_value: int


class BpmRecordOut(BpmRecord):
    systolic_value: int
    diastolic_value: int
    log_time: datetime
    image_url: str | None
