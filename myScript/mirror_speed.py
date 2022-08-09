import operator
import re
import subprocess
import time

import eventlet
import requests

mirrorlist_url = "https://archlinux.org/mirrorlist/?country=CN&protocol=http&protocol=https&ip_version=4"
# mirrorlist_url = "https://archlinux.org/mirrorlist/?country=CN&protocol=https&ip_version=4"

headers = {
    "User-Agent": "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.5060.134 "
                  "Safari/537.36 Edg/103.0.1264.71 "
}
get_time_out = 10


def get_package():
    package = r"/archlinux/core/os/x86_64/glibc-{}-x86_64.pkg.tar.zst"
    result = subprocess.run(['LC_ALL=C pacman -Si glibc'],
                            capture_output=True, text=True, shell=True).stdout
    version = re.search(r'Version +: ([\d.-]+)', result).group(1)
    return package.format(version)


def get_mirror_list():
    try:
        resp = requests.get(url=mirrorlist_url,
                            headers=headers, timeout=get_time_out).text
        pattern = re.compile(r"#Server = (\S+)/archlinux")
        mirrors = re.findall(pattern, resp)
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
            print("      time: " + str(speed), end="\n\n")
            if t_n == 0:
                speed_result[mirror] = [speed]
            else:
                speed_result[mirror].append(speed)
    return speed_result


def test_speed(url, down_time_out=30, max_time=999.0):
    # if "163" in url:
    #     return max_time
    start = time.time()
    try:
        resp = requests.get(url=url, headers=headers,
                            timeout=get_time_out, stream=True)
        if resp.status_code == 200:
            try:
                with eventlet.Timeout(down_time_out):
                    a = resp.content
            except eventlet.Timeout:
                return max_time
        else:
            print('\033[91m' + str(resp.status_code) + '\033[0m')
            return max_time
        stop = time.time()
    except Exception as e:
        print(str(e))
        return max_time
    return stop - start


def analyze_result(result):
    analyzed_result = {}
    for key, value in result.items():
        ave = sum(value) / len(value)
        analyzed_result[key] = ave

    sorted_result = sorted(analyzed_result.items(), key=operator.itemgetter(1))
    for key, value in sorted_result:
        print("{}\t{:.3f}".format(key, value))

    print("\n====================\n")
    for key, _ in sorted_result:
        print("Server = " + key + "/archlinux/$repo/os/$arch")


if __name__ == "__main__":
    mirror_list = get_mirror_list()
    rlt = get_task(mirrors=mirror_list, times=1)
    analyze_result(rlt)
