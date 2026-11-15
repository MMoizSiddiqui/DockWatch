"""Demo background worker: pretends to process uploaded files from the shared volume."""

import time
from pathlib import Path

UPLOADS = Path("/data/uploads")

while True:
    if UPLOADS.is_dir():
        for item in UPLOADS.iterdir():
            print(f"would process {item.name}", flush=True)
    time.sleep(30)
