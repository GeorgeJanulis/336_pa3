# database_llm.py (Run on your local machine)

import sys
import getpass
import paramiko
from llama_cpp import Llama
import textwrap
import re

# --- ⚠️ CONFIGURATION (UPDATE THESE) ⚠️ ---
# 1. SSH/iLab Configuration
ILAB_USER = "gnj18"  # <-- CHANGE THIS to your NetID
ILAB_HOST = "ilab.cs.rutgers.edu"
# This path must match the location where you uploaded ilab_script.py on iLab
ILAB_SCRIPT_PATH = "CS336/pa3/ilab_script.py" 

# 2. LLM/Model Configuration
MODEL_PATH = "./qwen2.5-3b-instruct-q5_k_m.gguf" 
SCHEMA_FILE_PATH = "llm_schema.sql" 

# 3. LLM Performance Settings
N_GPU_LAYERS = 0 # Set to > 0 if you have a GPU
# ----------------------------------------------------

def load_llm():
    """Loads the local GGUF model using llama-cpp-python."""
    print(f"Loading LLM from: {MODEL_PATH}...")
    try:
        llm = Llama(
            model_path=MODEL_PATH,
            n_gpu_layers=N_GPU_LAYERS,
            n_ctx=4096,  
            verbose=False,
        )
        print("✅ LLM loaded successfully.")
        return llm
    except Exception as e:
        print(f"❌ Error loading LLM: {e}")
        sys.exit(1)

def build_prompt(schema, user_question):
    """
    Constructs the prompt for the LLM using the schema and the user's question.
    """
    system_prompt = f"""You are an expert SQL generator for a PostgreSQL database. 
Your task is to convert a user's natural language question into a single, valid, and executable SQL SELECT query.
DO NOT include any explanation, context, or markdown formatting (like ```sql). Output ONLY the raw SQL query.
The user's question MUST be answered using ONLY the provided database schema.

--- SCHEMA ---
{schema}
--- SCHEMA ---
"""
    
    # Do NOT prime the assistant with any text. Let it generate the full query.
    prompt = f"<|im_start|>system\n{system_prompt}<|im_end|>\n<|im_start|>user\n{user_question}<|im_end|>\n<|im_start|>assistant\n"
    return prompt

def generate_sql(llm, schema_content, user_question):
    """Generates the SQL query using the LLM and strictly extracts the pure SQL."""
    full_prompt = build_prompt(schema_content, user_question)
    
    output = llm(
        full_prompt,
        max_tokens=256,
        stop=["<|im_end|>"], 
        temperature=0.0,
        echo=False, 
    )

    raw_response = output['choices'][0]['text']
    
    # 1. Use REGEX to strictly find and capture the complete SELECT...FROM statement.
    sql_match = re.search(r"SELECT.*FROM.*", raw_response, re.DOTALL | re.IGNORECASE)
    
    if sql_match:
        final_sql = sql_match.group(0).strip()
        
        # 2. Clean up: Ensure only one semicolon is at the end
        final_sql = final_sql.rstrip('; \n\r')
            
        # 3. CRITICAL FIX: Convert the entire query to lowercase for PostgreSQL compatibility.
        final_sql = final_sql.lower()

        # 4. Add the semicolon back and clean newlines/spaces
        return f"{final_sql.strip()};".replace('\n', ' ').replace('\r', '')
    
    # If regex fails, the LLM likely generated garbage or nothing useful.
    print(f"⚠️ LLM Output did not contain a valid SELECT...FROM statement: {raw_response.strip()}")
    return ""


def execute_remote_script(sql_query, password):
    """
    Connects to iLab via SSH and executes the remote script using stdin for safety.
    """
    ssh = None
    try:
        print(f"\n🔑 Connecting to {ILAB_USER}@{ILAB_HOST}...")
        
        # Establish SSH Connection
        ssh = paramiko.SSHClient()
        ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
        ssh.connect(ILAB_HOST, username=ILAB_USER, password=password)
        print("✅ SSH Connection established.")

        # Construct the Remote Command (simple, no arguments)
        remote_command = f'python3 {ILAB_SCRIPT_PATH}' 
        
        print(f"⚙️ Executing command: {remote_command}")
        
        # Execute the command
        stdin, stdout, stderr = ssh.exec_command(remote_command)
        
        # ⚠️ CRITICAL STEP: Write the SQL query to the remote process's stdin
        # This bypasses all complex shell quoting issues.
        stdin.write(sql_query)
        stdin.close() 
        
        query_output = stdout.read().decode('utf-8').strip()
        error_output = stderr.read().decode('utf-8').strip()

        if error_output:
            print(f"\n❌ Remote Script Error:\n{error_output}")
            return None
        
        return query_output

    except paramiko.AuthenticationException:
        print("❌ Authentication Failed: Check your NetID and password.")
        return None
    except Exception as e:
        print(f"❌ An unexpected error occurred: {e}")
        return None
    finally:
        if ssh:
            ssh.close()
            print("🔏 SSH Connection closed.")

def main():
    # 1. Load Schema Content
    try:
        with open(SCHEMA_FILE_PATH, 'r') as f:
            schema_content = f.read()
    except FileNotFoundError:
        print(f"❌ Error: Schema file not found at {SCHEMA_FILE_PATH}")
        sys.exit(1)

    # 2. Load LLM
    llm = load_llm()
    
    # 3. Securely Get iLab Password
    ilab_password = getpass.getpass(f"\nEnter iLab/NetID password for {ILAB_USER}: ")

    # 4. Interactive Loop
    print("\n--- SQL Generator & Executor Ready ---")
    print("Type 'exit' or 'quit' to end the session.")
    
    while True:
        try:
            user_question = input("\n❓ Your Question: ")
            
            if user_question.lower() in ['exit', 'quit']:
                break
            if not user_question.strip():
                continue

            # 5. Generate SQL
            print("🤖 Generating SQL...")
            sql_query = generate_sql(llm, schema_content, user_question)
            
            # Check if the generation step failed to produce a valid-looking query
            if not sql_query or not sql_query.upper().startswith("SELECT"):
                print("⚠️ LLM failed to generate a complete SELECT query. Try rephrasing.")
                continue
                
            print(f"➡️ Generated SQL: {sql_query}")

            # 6. Execute Remote Command
            results = execute_remote_script(sql_query, ilab_password)
                
            if results:
                print("\n\n--- 📊 QUERY RESULTS ---")
                print(results)
                print("-----------------------\n")

        except EOFError:
            break
        except Exception as e:
            print(f"An unexpected error occurred during the loop: {e}")
            break

    print("Session ended. Goodbye!")

if __name__ == "__main__":
    main()
