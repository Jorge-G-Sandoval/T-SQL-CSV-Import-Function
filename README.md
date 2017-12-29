# T-SQL-CSV-Import-Function

This is a function created to perform a specific import function on a system written in C #, receiving as a parameter the extraction type and the file path. The system receives several different types of CSV formats, called "extractions". Once executed, the function checks whether the file has already been imported by name. If it was not, it inserts it into the imported file table, extracts the file name from the full path, and imports the CSV into the table according to the extraction type.
