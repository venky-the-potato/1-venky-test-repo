import os
import sqlite3

username = input("Username: ")

query = f"SELECT * FROM users WHERE name='{username}'"

conn = sqlite3.connect("test.db")
cursor = conn.cursor()
cursor.execute(query)

print(os.popen("dir").read())
