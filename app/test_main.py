from fastapi.testclient import TestClient
from main import app

client = TestClient(app)

def test_read_main():
    # GIVEN the root endpoint
    response = client.get("/")
    
    # THEN it should return a 200 status and the correct JSON
    assert response.status_code == 200
    assert response.json() == {"status": "ok", "message": "API is running"}

def test_say_hello():
    # GIVEN a specific name parameter
    name = "Alice"
    response = client.get(f"/hell/{name}")
    
    # THEN it should include the name in the greeting
    assert response.status_code == 200
    assert response.json()["greeting"] == "Hello, Alice!"