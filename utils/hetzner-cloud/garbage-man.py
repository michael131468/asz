#!/usr/bin/env python3

import os
import sys

from datetime import datetime, timedelta, timezone

from hcloud import Client

def main():
    hcloud_token = os.getenv("HCLOUD_TOKEN")
    if not hcloud_token:
        print("HCLOUD_TOKEN not set.")
        return 1

    client = Client(token=hcloud_token)
    servers = client.servers.get_all()

    for server in servers:
        print(f"{server.name}: created at {server.created}")
        uptime = datetime.now(timezone.utc) - server.created
        uptime_in_hours = uptime.total_seconds() / 3600
        indent = " " * (len(server.name)+2)
        print(f"{indent}uptime: {uptime}")
        print(f"{indent}labels: {server.labels}")

        if "asz" not in server.labels:
            continue
        if uptime_in_hours < 1:
            continue

        print(f"{indent}Deleting server...")
        server.delete()
        print(f"{indent}Done.")

if __name__ == "__main__":
    sys.exit(main())
