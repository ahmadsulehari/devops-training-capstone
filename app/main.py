from fastapi import FastAPI

app = FastAPI()

@app.get("/")
def read_root():
    return {"status": "ok", "message": "API is running"}

@app.get("/hello/{name}")
def say_hello(name: str):
    return {"greeting": f"Hello, {name}!"}