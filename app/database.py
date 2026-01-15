import os
import time
from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker
from sqlalchemy.exc import OperationalError

URL_DATABASE = os.getenv("DATABASE_URL")

# Retry connecting to the database
for _ in range(5):
    try:
        engine = create_engine(URL_DATABASE)
        engine.connect()
        break
    except OperationalError:
        time.sleep(5)
else:
    raise Exception("Could not connect to the database")

SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
Base = declarative_base()
