from fastapi import FastAPI, UploadFile, File, Form, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from app.api.endpoints import pronunciation
import uvicorn

app = FastAPI(
    title="Pronounce Perfect API",
    description="AI-powered pronunciation analysis API",
    version="1.0.0"
)

# Configure CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # In production, specify allowed origins
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Include routers
app.include_router(pronunciation.router, prefix="/api", tags=["pronunciation"])

@app.get("/")
async def root():
    return {"message": "Pronounce Perfect API", "status": "running"}

@app.get("/health")
async def health_check():
    return {"status": "healthy"}

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)
