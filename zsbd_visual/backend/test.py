from main import create_connection
import datetime

conn = create_connection()
cursor = conn.cursor()
cursor.execute("SELECT * FROM client")
print(cursor.fetchall())