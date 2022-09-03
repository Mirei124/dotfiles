import os.path
import re
import subprocess
import time

import eventlet
import requests

# mirrorlist_url = "https://archlinux.org/mirrorlist/?country=CN&protocol=http&protocol=https&ip_version=4"
mirrorlist_url = "https://archlinux.org/mirrorlist/?country=CN&protocol=https&ip_version=4"

headers = {
    "User-Agent": "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.5060.134 "
                  "Safari/537.36 Edg/103.0.1264.71 "
}
GET_TIMEOUT = 10
DOWN_TIMEOUT = 30
MAX_TIME = 999.0


def get_package():
    package = r"/archlinux/core/os/x86_64/glibc-{}-x86_64.pkg.tar.zst"
    result = subprocess.run(['LC_ALL=C pacman -Si glibc'],
                            capture_output=True, text=True, shell=True).stdout
    version = re.search(r'Version +: ([\d.-]+)', result).group(1)
    return package.format(version)


def get_mirror_list():
    if os.path.exists("mirror_list.txt"):
        with open("mirror_list.txt", "r") as fp:
            mirrors = fp.readlines()
        a = map(lambda x: str.strip(x), mirrors)
        return list(a)

    try:
        resp = requests.get(url=mirrorlist_url,
                            headers=headers, timeout=GET_TIMEOUT).text
        pattern = re.compile(r"#Server = (\S+)/archlinux")
        mirrors = re.findall(pattern, resp)

        with open("mirror_list.txt", "w") as fp:
            for i in mirrors:
                fp.write(i)
                fp.write("\n")

        return mirrors
    except Exception as e:
        print(e)
        exit(-1)


def get_task(mirrors, times):
    package = get_package()
    speed_result = dict()
    for t_n in range(times):
        for mirror in mirrors:
            print("start test: " + mirror)
            speed = test_speed(mirror + package)
            # speed = random.random() * 10
            print("      time: {:.3f}s".format(speed), end="\n\n")
            if t_n == 0:
                speed_result[mirror] = [speed]
            else:
                speed_result[mirror].append(speed)
    return speed_result


def test_speed(url):
    # if "163" in url:
    #     return MAX_TIME
    start = time.time()
    try:
        resp = requests.get(url=url, headers=headers,
                            timeout=GET_TIMEOUT, stream=True)
        if resp.status_code == 200:
            try:
                with eventlet.Timeout(DOWN_TIMEOUT):
                    _ = resp.content
            except eventlet.Timeout:
                return MAX_TIME
        else:
            print('\033[91m' + " " * 6 + str(resp.status_code) + '\033[0m')
            return MAX_TIME
        stop = time.time()
    except Exception as e:
        print(str(e))
        return MAX_TIME
    return stop - start


def analyze_result(result):
    analyzed_result = {}
    for key, value in result.items():
        ave = sum(value) / len(value)
        min_ = min(value)
        max_ = max(value)
        analyzed_result[key] = [min_, max_, ave]

    sorted_result = sorted(analyzed_result.items(), key=lambda x: x[1][2])
    print("        MIRROR                          	 MIN 	 MAX 	 AVE ")
    for key, value in sorted_result:
        print("{:40}\t{:.3f}\t{:.3f}\t{:.3f}".format(
            key, value[0], value[1], value[2]))

    print("\n====================\n")
    for key, _ in sorted_result:
        print("Server = " + key + "/archlinux/$repo/os/$arch")


if __name__ == "__main__":
    mirror_list = get_mirror_list()
    rlt = get_task(mirrors=mirror_list, times=1)
    analyze_result(rlt)
