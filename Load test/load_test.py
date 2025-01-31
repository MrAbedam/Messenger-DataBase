import pg8000
from faker import Faker
import time
from concurrent.futures import ThreadPoolExecutor

DB_HOST = "sour-spaniel-4371.jxf.gcp-europe-west1.cockroachlabs.cloud"
DB_PORT = 26257
DB_NAME = "telegram"
DB_USER = "mmdhossein"
DB_PASSWORD = "mbmwWrhtDTFFRkltuUFCSQ"

fake = Faker()


def create_connection():
    return pg8000.connect(
        host=DB_HOST,
        port=DB_PORT,
        database=DB_NAME,
        user=DB_USER,
        password=DB_PASSWORD
    )


def insert_human_user():
    conn = create_connection()
    cursor = conn.cursor()
    try:
        # Generate random data
        username = fake.user_name()[:10]
        phone_number = fake.phone_number()[:10]
        first_name = fake.first_name()[:10]
        last_name = fake.last_name()[:10]
        dob = fake.date_of_birth(minimum_age=18, maximum_age=65)

        # SQL query for add new human users
        cursor.execute(
            """
            WITH new_user AS (
                INSERT INTO Users (user_id, username, bio)
                VALUES (gen_random_uuid(), %s, '')
                ON CONFLICT (username) DO NOTHING
                RETURNING user_id
            )
            INSERT INTO Human_user (user_id, phone_number, first_name, last_name, dob)
            SELECT user_id, %s, %s, %s, %s
            FROM new_user
            UNION ALL
            SELECT user_id, %s, %s, %s, %s
            FROM Users
            WHERE username = %s LIMIT 1;
            """,
            (username, phone_number, first_name, last_name, dob,
             phone_number, first_name, last_name, dob, username)
        )
        conn.commit()
    except Exception as e:
        print(f"Error inserting Human_user: {e}")
    finally:
        cursor.close()
        conn.close()


def run_load_test(num_workers=10, duration=60):
    start_time = time.time()
    with ThreadPoolExecutor(max_workers=num_workers) as executor:
        while time.time() - start_time < duration:
            executor.submit(insert_human_user)
    print("Load test completed.")


if __name__ == "__main__":
    run_load_test(num_workers=10, duration=60)
