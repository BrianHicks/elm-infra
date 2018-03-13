#!/usr/bin/env python
from __future__ import unicode_literals, print_function
from argparse import ArgumentParser
from collections import defaultdict
import json
import os.path
import sys


def local_to_script(path):
    return os.path.join(os.path.dirname(__file__), path)


def tfstates():
    for path in [local_to_script('terraform.tfstate')]:
        if not os.path.exists(path):
            continue

        with open(path, 'r') as fh:
            yield json.load(fh)


def modules():
    for state in tfstates():
        for module in state['modules']:
            yield module


def vms():
    for module in modules():
        for (name, value) in module['resources'].items():
            if value['type'] != 'digitalocean_droplet':
                continue

            yield value['primary']['attributes']


class Inventory(object):
    def __init__(self):
        self.meta = {}
        self.groups = defaultdict(list)

    def add_host(self, host, meta):
        self.meta[host] = meta
        self.join_group(host, 'all')

    def join_group(self, host, group):
        self.groups[group].append(host)

    def format_host(self, host):
        return json.dumps(self.meta.get(host, {}))

    def format_list(self):
        base = {
            '_meta': {'hostvars': self.meta}
        }
        base.update(self.groups)

        return json.dumps(base)


def main(args):
    inventory = Inventory()

    for vm in vms():
        meta = {
            k: v
            for (k, v) in vm.items()
            if '.' not in k
        }

        meta['ansible_host'] = meta['ipv4_address']
        meta['ansible_user'] = 'root'
        meta['ansible_ssh_private_key_file'] = 'iac/id_rsa'

        inventory.add_host(vm['name'], meta)

        for key in vm:
            if key.startswith('tags.') and key != 'tags.#':
                inventory.join_group(vm['name'], vm[key])

    if args.host is not None:
        print(inventory.format_host(args.host))
    elif args.list:
        print(inventory.format_list())
    else:
        print('either one of --list or --host {name} is required')
        return 1

    return 0

if __name__ == '__main__':
    parser = ArgumentParser(__file__)
    parser.add_argument('--list', action='store_true')
    parser.add_argument('--host')

    sys.exit(main(parser.parse_args()))
