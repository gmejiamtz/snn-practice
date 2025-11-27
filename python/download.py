#!/usr/bin/env python3
import os
import requests

BASE_URL = "https://dataverse.nl"
PERSISTENT_ID = "doi:10.34894/QTFHQX"
OUT_DIR = "downloaded_data"
CHUNK_SIZE = 1024 * 1024 * 10 # 10 MB chunks

def get_file_list():
    url = f"{BASE_URL}/api/datasets/:persistentId"
    params = {"persistentId": PERSISTENT_ID}
    resp = requests.get(url, params=params, timeout=30)
    resp.raise_for_status()
    meta = resp.json()
    return meta.get("data", {}).get("latestVersion", {}).get("files", [])

def download(file_id, filename):
    out_path = os.path.join(OUT_DIR, filename)

    # Skip if file already exists
    if os.path.exists(out_path):
        print(f"Skipping {filename}, already exists.")
        return

    url = f"{BASE_URL}/api/access/datafile/{file_id}"
    with requests.get(url, stream=True, timeout=60) as r:
        r.raise_for_status()
        total_size = int(r.headers.get("Content-Length", 0))
        downloaded = 0
        print(f"Downloading {filename} ({total_size / 1024 / 1024:.2f} MB)...")

        with open(out_path, "wb") as f:
            for chunk in r.iter_content(CHUNK_SIZE):
                if chunk:
                    f.write(chunk)
                    downloaded += len(chunk)
                    if total_size > 0:
                        done = int(50 * downloaded / total_size)
                        print(f"\r[{'█' * done}{'.' * (50 - done)}] "
                              f"{downloaded / 1024 / 1024:.2f}/{total_size / 1024 / 1024:.2f} MB",
                              end="")
        print("\nDownload finished.")

def main():
    os.makedirs(OUT_DIR, exist_ok=True)
    files = get_file_list()
    file_names = [f.get("dataFile", {}).get("filename") for f in files]
    print("Found files:", file_names)

    for f in files:
        data = f.get("dataFile", {})
        fid = data.get("id")
        fname = data.get("filename")
        if fid and fname:
            download(fid, fname)
        else:
            print("Skipping file with missing id or name:", f)

if __name__ == "__main__":
    main()

