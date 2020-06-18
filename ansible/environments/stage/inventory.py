#!/usr/bin/python3

import json
import subprocess


def get_gce():
    """
    Function to get IPs with a gcloud
    :return: Formatted List of lists from gcloud output [[name, tags, natIP], [name2, tags, natIP2]]
    """
    result = subprocess.run([
        "gcloud",
        "compute",
        "instances",
        "list",
        "--format=value(name,tags.items,EXTERNAL_IP,INTERNAL_IP)",
    ],
        stdout=subprocess.PIPE
    )
    gce = result.stdout.decode('utf-8').split('\n')

    return [i.split('\t') for i in gce]


def get_data_for_tag(data, tag):
    return [i for i in data if tag in i]


def get_app_data(gce):
    return get_data_for_tag(data=gce, tag='reddit-app')


def get_db_data(gce):
    return get_data_for_tag(data=gce, tag='reddit-db')


def gen_meta(data):
    return {
        i[0]: {'ansible_host': i[2], 'internal_ip': i[3]}
        for i in data
    }


def make_inventory():
    gce = get_gce()
    app_data = get_app_data(gce=gce)
    db_data = get_db_data(gce=gce)

    out = {
        "_meta": {
            "hostvars": {
                **gen_meta(app_data),
                **gen_meta(db_data),
            }
        },
        "all": {
            "children": [
                "app",
                "db"
            ]
        },
        "app": {
            "hosts": [i[0] for i in app_data]
        },
        "db": {
            "hosts": [i[0] for i in db_data]
        }
    }
    return out


if __name__ == '__main__':
    print(json.dumps(make_inventory()))
