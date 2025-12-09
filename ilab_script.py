# ilab_script.py (Upload this final version to your iLab machine)

import sys
import psycopg2
import textwrap

# --- ⚠️ CONFIGURATION (MUST MATCH YOUR ILAB SETUP) ⚠️ ---
# Using 'trust' authentication with your NetID as user and database name.
DB_HOST = "postgres.cs.rutgers.edu"
DB_NAME = "gnj18"     # <-- CHANGE THIS to your NetID (e.g., gnj18)
DB_USER = "gnj18"     # <-- CHANGE THIS to your NetID
# --- ---------------------------------------------------- ---

def format_results_as_table(cursor, results):
    """
    Manually formats the query results into a readable string table.
    """
    if not cursor.description:
        return "Query executed successfully, but returned no column descriptions."

    headers = [desc[0] for desc in cursor.description]
    col_widths = [len(header) for header in headers]
    
    data_rows = []
    for row in results:
        str_row = []
        for i, cell in enumerate(row):
            cell_str = str(cell) if cell is not None else "NULL"
            col_widths[i] = max(col_widths[i], len(cell_str))
            str_row.append(cell_str)
        data_rows.append(str_row)

    format_string = " | ".join([f"{{:<{w}}}" for w in col_widths])
    format_string = "| " + format_string + " |"
    
    separator_line = "-+-".join(["-" * w for w in col_widths])
    separator_line = "+" + separator_line + "+"

    output = []
    output.append(separator_line)
    output.append(format_string.format(*headers))
    output.append(separator_line)

    for row in data_rows:
        output.append(format_string.format(*row))

    output.append(separator_line)

    return "\n".join(output)

def execute_query(sql_query):
    """Connects to the database, executes the query, and prints the formatted results."""
    conn = None
    try:
        # Establish connection using 'trust' authentication
        conn = psycopg2.connect(
            host=DB_HOST,
            database=DB_NAME,
            user=DB_USER
        )
        cur = conn.cursor()

        cur.execute(sql_query)
        
        if cur.description:
            results = cur.fetchall()
            formatted_table = format_results_as_table(cur, results)
            # Output captured by local script via stdout
            print(formatted_table)
        else:
            print("Query executed successfully (0 rows returned or non-SELECT).")

        cur.close()

    except (Exception, psycopg2.Error) as error:
        # Print error message to standard error stream (stderr) for the local script to catch
        print(f"Database Error: {error}", file=sys.stderr)
    
    finally:
        if conn:
            conn.close()

def main():
    # ⚠️ CRITICAL CHANGE: Read SQL from standard input (stdin)
    if not sys.stdin.isatty():
        sql_query = sys.stdin.read().strip() 
        
        if not sql_query:
            print("Error: No SQL query received via stdin.", file=sys.stderr)
            sys.exit(1)
        
        # Basic check
        if not sql_query.upper().startswith("SELECT"):
            print("Error: Only SELECT queries are supported.", file=sys.stderr)
            sys.exit(1)
            
        execute_query(sql_query)
        
    else:
        # Fallback usage instruction
        print("Error: This script must receive SQL via stdin.", file=sys.stderr)

if __name__ == "__main__":
    main()
