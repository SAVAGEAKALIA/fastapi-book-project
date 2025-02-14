from fastapi import APIRouter

from api.routes import books, health

api_router = APIRouter()
# api_router.include_router(books.router, prefix="/books", tags=["books"])
api_router.include_router(books.router, prefix="/books", tags=["books"])
# api_router.include_router(health.router, tags=["health"])
