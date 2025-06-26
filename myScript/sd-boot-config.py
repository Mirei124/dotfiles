#!/bin/python3

import difflib
import os
from pathlib import Path
import re

ENTRY_DIR = "/boot/loader/entries/"
RAMFS_DIR = "/boot/"


class Entry:
    root_arg = "root=UUID=138010eb-80c7-48dc-b937-b41ec48d28c9 rw rootflags=subvol=@"

    param_list = [
        # kernel parameters
        "resume=UUID=418b17ce-c6d3-4701-85f5-0191a7fb10e9",
        "loglevel=5",
        # "audit=0",
        # "nowatchdog",
        # "modprobe.blacklist=sp5100_tco",
        "nvidia_drm.modeset=1",
        # "nvidia.NVreg_EnableGpuFirmware=0",
        # "amd_pstate=passive",
        # "zswap.enabled=1",
        # "splash quiet",
        "sysrq_always_enabled=1",
    ]

    ucode_initrd = "amd-ucode.img"

    def __init__(self,
                 title: str,
                 linux: str,
                 initrd: list[str],
                 extra_params: list[str] | None = None,
                 conf_path: Path | None = None,
                 add_ucode: bool = False):
        self.title = title
        self.linux = linux
        self.conf_path = conf_path
        self.initrd = initrd[:]
        if add_ucode:
            self.initrd.insert(0, Entry.ucode_initrd)
        self.param_list = Entry.param_list[:]
        if extra_params and len(extra_params):
            self.param_list.extend(extra_params)

    def __str__(self) -> str:
        return f"Entry(title={self.title} linux={self.linux} initrd={self.initrd})"


def log(msg: str | Exception, color: str = "r"):
    color_dict = {
        "r": "\033[1;31m",
        "g": "\033[1;32m",
        "b": "\033[1;34m\033[0m"
    }
    start = color_dict[color]
    end = "\033[0m"
    print(start + str(msg) + end)


def find_initramfs(dir: str = RAMFS_DIR) -> list:
    p = Path(dir)
    ramfs = p.glob("initramfs*.img")
    return [i.name for i in ramfs]


def generate_entry(ramfs_name: str) -> Entry | None:
    # initramfs-linux-xanmod.img
    m = re.match(r"initramfs-(.+)\.img", ramfs_name)
    if m:
        m = m.group(1)
    else:
        m = "default"

    linux = find_linux(m.replace("-fallback", ""))
    if not linux:
        return None

    return Entry(m.replace("-", " "), linux, [ramfs_name])


def find_linux(name: str, dir: str = RAMFS_DIR) -> str | None:
    file_name = f"vmlinuz-{name}"
    if os.path.isfile(os.path.join(dir, file_name)):
        return file_name
    else:
        return None


def generate_conf(entry: Entry, dir: str = ENTRY_DIR) -> tuple[list, list]:
    new_conf = f"title   Arch {entry.title}\nlinux   /{entry.linux}\n"
    for i in entry.initrd:
        new_conf += f"initrd  /{i}\n"
    options = f"{Entry.root_arg} " + " ".join(entry.param_list) + "\n"
    new_conf += f"options {options}"

    file_path = os.path.join(dir, entry.title.replace(" ", "-") + ".conf")
    if not os.path.exists(file_path):
        old_conf = []
    else:
        with open(file_path, "r") as f:
            old_conf = list(map(str.strip, f.readlines()))
    return old_conf, new_conf.splitlines()


def is_diff_conf(old_conf: list[str],
                 new_conf: list[str],
                 title: str = "config") -> bool:
    diff = list(
        difflib.unified_diff(old_conf,
                             new_conf,
                             fromfile=f"Old {title}",
                             tofile=f"New {title}",
                             lineterm=""))
    if not len(diff):
        return False

    diff_str = "\n".join(diff)
    print("")
    os.system(f"echo '{diff_str}' | bat --style changes")
    print("")
    if ask_input("Write"):
        return True

    return False


def ask_input(prompt: str) -> bool:
    r = input(f"\033[1;32m{prompt}? [y/N] \033[0m")
    # print("")
    if r and r in "yY":
        return True
    return False


def write_conf(entry: Entry, conf: list[str], dir: str = ENTRY_DIR):
    if entry.conf_path:
        file_name = entry.conf_path
    else:
        file_name = (entry.title.replace(" ", "-") + ".conf")
    try:
        with open(os.path.join(dir, file_name), "w") as f:
            for line in conf:
                f.write(f"{line}\n")
        log(f"Write {file_name} Successfully", "g")
    except PermissionError as e:
        log(e)


def conf_to_entry(file_path: Path) -> Entry | None:
    title = None
    linux = None
    initrd = []
    with open(file_path, "r") as f:
        while line := f.readline().strip():
            delim = line.find(" ")
            k = line[:delim]
            v = line[delim:].strip()
            match k:
                case "title":
                    title = v.replace("-", " ")
                case "linux":
                    linux = v
                case "initrd":
                    initrd.append(v)

    # print(f"{title=} {linux=} {initrd=}")
    if title and linux and initrd and len(initrd):
        return Entry(title,
                     linux,
                     initrd,
                     add_ucode=False,
                     conf_path=file_path)
    return None


def check_conf(entry: Entry, dir: str = RAMFS_DIR) -> bool:
    if not os.path.exists(os.path.join(dir, entry.linux[1:])):
        return False
    for initrd in entry.initrd:
        if not os.path.exists(os.path.join(dir, initrd[1:])):
            return False

    return True


def check_all_conf(dir: str = ENTRY_DIR) -> tuple[list[Entry], list[Path]]:
    valid = []
    invalid = []
    for file_path in Path(dir).glob("*.conf"):
        if file_path.name == "windows.conf":
            valid.append(
                Entry("Windows",
                      "shellx64.efi", [],
                      conf_path=Path("/boot/loader/entries/windows.conf")))
            continue
        entry = conf_to_entry(file_path)
        if entry and check_conf(entry):
            valid.append(entry)
        else:
            invalid.append(file_path)
    return valid, invalid


def set_default_boot(valid_confs: list[Entry]):
    default = "null"
    conf = []
    with open(os.path.join(RAMFS_DIR, "loader/loader.conf"), "r") as f:
        while line := f.readline():
            if "default" in line:
                default = line.strip().split(" ")[-1]
                continue
            conf.append(line)

    default_valid = default in map(
        lambda x: x.conf_path.name,  # pyright:ignore
        valid_confs)
    if default_valid:
        print(f"\nCurrent default: \033[1;34m{default}\033[0m")
    else:
        print(f"\nCurrent default: \033[1;31m{default}\033[0m")

    # select
    if default_valid and not ask_input("Change default"):
        return

    for (i, entry) in enumerate(valid_confs):
        print(f"\033[1;34m{i})\033[0m {entry.title}")

    while True:
        s = input("\nSelect default: ")
        try:
            if not s:
                log("Skip", "g")
                return
            s = int(s)
        except ValueError:
            log("Input error")
            continue
        if s >= 0 and s < len(valid_confs):
            break
        else:
            log("Input error")

    # write loader.conf
    entry = valid_confs[s]
    try:
        with open(os.path.join(RAMFS_DIR, "loader/loader.conf"), "w") as f:
            if entry.conf_path:
                f.write("default " + entry.conf_path.name + "\n")
            else:
                f.write("default " + entry.title.replace(" ", "-") + ".conf\n")

            for i in conf:
                f.write(i)
    except PermissionError as e:
        log(e)


def remove_invalid_conf(invalid_confs: list[Path]):
    if len(invalid_confs):
        log("\nRemove invalid conf\n", "b")
    for conf in invalid_confs:
        print("{:*^40}".format(f" {conf.name} "))
        with open(conf, "r") as f:
            while line := f.readline():
                print(line, end="")
        print("*" * 40 + "\n")
        if ask_input(f"Remove {conf.name}"):
            try:
                os.remove(conf)
                log(f"{conf.name} Removed", "g")
            except PermissionError as e:
                log(e)


def add_vfio_conf():
    entry = Entry("linux vfio", "vmlinuz-linux-lts",
                  ["initramfs-linux-vfio.img"])
    entry.param_list = [
        i for i in entry.param_list if i != "nvidia_drm.modeset=1"
    ]
    entry.param_list.append("iommu=pt")

    old_conf, new_conf = generate_conf(entry)
    if is_diff_conf(old_conf, new_conf, entry.title):
        write_conf(entry, new_conf)


def update_conf():
    ramfs_list = find_initramfs()
    for i in ramfs_list:
        if "vfio" in i:
            continue

        entry = generate_entry(i)
        if entry:
            old_conf, new_conf = generate_conf(entry)
            if is_diff_conf(old_conf, new_conf, entry.title):
                write_conf(entry, new_conf)


if __name__ == "__main__":
    update_conf()
    add_vfio_conf()
    valid_confs, invalid_confs = check_all_conf()
    remove_invalid_conf(invalid_confs)
    set_default_boot(valid_confs)
