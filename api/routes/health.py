from fastapi import APIRouter, status
from fastapi.responses import JSONResponse

router = APIRouter()

@router.get("/healthcheck", status_code=status.HTTP_200_OK)
async def health_check():
    return JSONResponse(status_code=status.HTTP_200_OK, content={"status": "ok"})
