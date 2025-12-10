////////////// README //////////////

Group Members:

George Janulis - gnj18
- Contributions: Created the python scripts for the project and trained the llm to turn human language into sql queries.

Mark Tawfik - mgt62 
- Contributtions: Provided the scripts for the database, and assisted in getting it up and running for the llm to read from.

Showrya Bandi - snb124
- Contributions: Helped with logistical errors and wrapped up the project with the readme for submission

Sarthak Talukdar - st1332
- Contributions: Offered suggestions for training the llm to make better sense of the english provided to it to turn into real SQL queries.

What was challenging?

The challenging part was getting the llm to be able to turn human language into a valid sql query. I had this challenge where the llm 
was only able to create fragments of queries. I had to tell it to make a relational algebra statement first, which ended up making it work.

What was interesting?

I thought it was really interesting to interact with an AI to make the project, and seeing how it designed the frontend. I also thought
it was really interesting to see how the AI found a way to create an SSH tunnel because it is something I have never done in a project before.

Extra Credit? Yes, we did the extra credit.

Instructions on how to run:

First, make sure the database is setup on your ilab with these steps:
  - Make sure the bottom of Project_0_Preliminary.sql has the correct file path for the data csv.
  - Run scripts in this order: Project_0_Preliminary.sql -> project1_normalization.sql -> project2_normalization.sql

Next, make sure ilab_script.py is located on the ilab and ***CHANGE THE DB_NAME AND DB_USER AT THE TOP TO YOUR NETID***

Next, make sure the local files include: database_llm.py and llm_schema.sql
  - Note: for ILAB_USER and ILAB_SCRIPT_PATH: make sure you change those to be your correct path

Finally, run python3 database_llm.py.

NOTE* I created a python script (database_llm.py) to download the llm locally. I included that in the submission.

//Questions asked during recording:

- What is the total number of applications?
- How many mortgages have a loan value greater than the applicant income?
- What is the average income of owner occupied applications?
- What is the most common loan denial reason?
- What is the average loan amount for each type of property? List the property type and the average amount?

Video Link - https://www.youtube.com/watch?v=Ek7gg9lH10E

