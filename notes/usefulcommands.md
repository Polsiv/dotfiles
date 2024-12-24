# Count lines
- `... | wc -l`


# xargs
- A bridge between the sdout and stdin for pipes
- **wrong**: `ls *.txt | rm`
- **correct**: `ls *.txt | xargs rm`

