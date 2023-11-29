import sys
import subprocess

# Specify the path to the input DVD
if len(sys.argv) > 1:
    dvd_path = sys.argv[1]
else:
    quit("You need to provide the path")

# Extract specific title using HandBrake CLI
desired_title = 1
output_file = 'output.mkv'

handbrake_cmd = [
    'HandBrakeCLI',
    '-i', dvd_path,
    '-Z', 'H.265 MKV 2160p60',
    '-o', output_file,
]

subprocess.run(handbrake_cmd)

print("Successfully extracted title to file.")
