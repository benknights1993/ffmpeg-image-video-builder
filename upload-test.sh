#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import os
import requests

DROPBOX_TOKEN = os.environ.get("ACCESS_TOKEN")

with open("output_video.mp4", "rb") as f:
    print("📤 Uploading video to Dropbox...")
    r = requests.post(
        "https://content.dropboxapi.com/2/files/upload",
        headers={
            "Authorization": f"Bearer {DROPBOX_TOKEN}",
            "Dropbox-API-Arg": '{"path": "/output_video.mp4", "mode": "overwrite"}',
            "Content-Type": "application/octet-stream"
        },
        data=f,
    )
    print("✅ Upload complete!" if r.ok else f"❌ Upload failed: {r.text}")
