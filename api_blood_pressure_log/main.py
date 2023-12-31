# from fastapi import FastAPI
# 
# app = FastAPI()
# 
# 
# @app.get("/")
# async def root():
#     return {"message": "Hello World"}
# 
# 
# @app.get("/hello/{name}")
# async def say_hello(name: str):
#     return {"message": f"Hello {name}"}


import logging
from contextlib import asynccontextmanager

from asgi_correlation_id import CorrelationIdMiddleware
from fastapi import FastAPI, HTTPException
from fastapi.exception_handlers import http_exception_handler
from config import config

from api_analytics.fastapi import Analytics

from database import database
# from logging_conf import configure_logging
# from routers.post import router as post_router
from routers.upload import router as upload_router
from routers.user import router as user_router
from routers.bpm_record_router import router as record_router
from routers.mobile_app import router as mobile_app__router

logger = logging.getLogger(__name__)


@asynccontextmanager
async def lifespan(app: FastAPI):
    # configure_logging()
    await database.connect()
    yield
    await database.disconnect()


app = FastAPI(lifespan=lifespan)
app.add_middleware(CorrelationIdMiddleware)
app.add_middleware(Analytics, api_key=config.FAST_API_ANALYTICS)  # Add middleware


@app.get("/", status_code=200, include_in_schema=False)
async def root_path():
    return {
        "message": "Hello Blood Pressure Monitoring API",
    }


# app.include_router(post_router)
app.include_router(upload_router)
app.include_router(user_router)
app.include_router(record_router)
app.include_router(mobile_app__router)


@app.exception_handler(HTTPException)
async def http_exception_handle_logging(request, exc):
    logger.error(f"HTTPException: {exc.status_code} {exc.detail}")
    return await http_exception_handler(request, exc)
