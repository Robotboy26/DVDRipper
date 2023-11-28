import pydvdread
import sys

# Specify the path to the input DVD
if len(sys.argv) > 1:
    dvd_path = sys.argv[1]
else:
    quit("you need to provide the path")

# Open the DVD using pydvdread
dvd = pydvdread.open(dvd_path)

# Access the DVD contents
for title in dvd:
    print(f"Title: {title.title_number}, Duration: {title.duration}s")

# Extract specific title to a file
desired_title = 1
output_file = '/home/output.mkv'

with open(output_file, 'wb') as f:
    dvd.extract_title(desired_title, f)
    print("Successfully extracted title to file.")

# Close the DVD
dvd.close()
