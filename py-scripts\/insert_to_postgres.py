import psycopg2
import csv

# Set the name of the CSV file and the table to insert into
input_file = 'health_data.csv'
table_name = 'health_data'

# Set up a connection to the PostgreSQL database
conn = psycopg2.connect(database="postgres", user="user", password="user", host="localhost", port="5433")

# Open the CSV file and create a cursor object
with open(input_file, 'r') as f:
    reader = csv.reader(f)
    headers = next(reader, None)
    col_count = len(headers)

    # Create a SQL statement to create the table
    sql = f"CREATE TABLE IF NOT EXISTS {table_name} ({','.join([f'{h} TEXT' for h in headers])})"

    # Create a cursor and execute the SQL statement to create the table
    cur = conn.cursor()
    cur.execute(sql)

    # Reset the file pointer to the beginning of the file
    f.seek(0)

    # Create a SQL statement to insert the data
    placeholders = ', '.join(['%s'] * col_count)
    sql = f"INSERT INTO {table_name} ({','.join(headers)}) VALUES ({placeholders})"

    # Create a cursor and execute the SQL statement in batches
    batch_size = 10000
    batch = []
    for row in reader:
        batch.append(row)
        if len(batch) >= batch_size:
            cur.executemany(sql, batch)
            batch.clear()
            conn.commit()

    # Insert any remaining rows
