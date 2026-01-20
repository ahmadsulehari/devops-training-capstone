import random
import time
from dotenv import load_dotenv

# Load environment variables from .env file
load_dotenv()

from fastapi.testclient import TestClient
from main import app

client = TestClient(app)

# Track created user IDs for cleanup
created_user_ids = []


def get_random_name_and_email():
    unique_id = str(int(time.time() * 1000000))
    random_email = f"jane+{unique_id}@gmail.com"
    random_name = f"jane+{unique_id}"
    return random_name, random_email


def cleanup_users():
    """Delete all created users"""
    for user_id in created_user_ids:
        client.delete(f"/users/{user_id}")
    created_user_ids.clear()


def test_create_user():
    random_name, random_email = get_random_name_and_email()
    response = client.post(
        "/users/", params={"name": random_name, "email": random_email}
    )
    assert response.status_code == 200
    data = response.json()
    assert data["name"] == random_name
    assert data["email"] == random_email
    created_user_ids.append(data["id"])


def test_read_user():
    # First, create a user
    random_name, random_email = get_random_name_and_email()
    create_resp = client.post(
        "/users/", params={"name": random_name, "email": random_email}
    )
    user_id = create_resp.json()["id"]
    created_user_ids.append(user_id)
    # Now, read the user
    response = client.get(f"/users/{user_id}")
    assert response.status_code == 200
    data = response.json()
    assert data["name"] == random_name
    assert data["email"] == random_email


def test_list_users():
    # Create two users
    random_name_1, random_email_1 = get_random_name_and_email()
    random_name_2, random_email_2 = get_random_name_and_email()
    create_resp_1 = client.post(
        "/users/", params={"name": random_name_1, "email": random_email_1}
    )
    create_resp_2 = client.post(
        "/users/", params={"name": random_name_2, "email": random_email_2}
    )
    created_user_ids.append(create_resp_1.json()["id"])
    created_user_ids.append(create_resp_2.json()["id"])
    response = client.get("/all-users/")
    assert response.status_code == 200
    users = response.json()
    assert any(user["name"] == random_name_1 for user in users)
    assert any(user["name"] == random_name_2 for user in users)


def teardown_module():
    """Cleanup after all tests in this module"""
    cleanup_users()
