import asyncio
import logging
import os

from pynput.keyboard import Listener as k_Listener
from pynput.mouse import Listener as m_Listener

logging.basicConfig(filename='/home/k/myScript/careEye/log_care_eye.txt', filemode='w', level=logging.INFO,
                    format='%(asctime)s - %(levelname)s: %(message)s')


class CalcWatchTime:
    LISTEN_TIME = 15
    INTERVAL_TIME = 5 * 60
    NOTIFY_TIME = 20 * 60

    def __init__(self, watch_time=0):
        self.watch_time = watch_time
        self.is_watch = 0

    def mouse_on_move(self, x, y):
        logging.info(f'mouse move: {x} {y}')
        self.is_watch = 1
        return False

    def key_on_release(self, key):
        logging.info(f'key release: {key}')
        self.is_watch = 1
        raise k_Listener.StopException

    async def get_watch_stat(self):
        while True:
            mouse_listener = m_Listener(on_move=self.mouse_on_move)
            keyboard_listener = k_Listener(on_release=self.key_on_release)
            self.is_watch = 0
            logging.info('start listen')
            mouse_listener.start()
            keyboard_listener.start()
            await asyncio.sleep(self.LISTEN_TIME)
            mouse_listener.stop()
            keyboard_listener.stop()
            del mouse_listener
            del keyboard_listener
            logging.info('stop listen, sleep...')
            await asyncio.sleep(self.INTERVAL_TIME)

    async def set_watch_time(self):
        while True:
            if self.is_watch == 1:
                self.watch_time += self.INTERVAL_TIME
            elif self.is_watch == 0:
                self.watch_time -= self.INTERVAL_TIME * 0.5
                self.watch_time = 0 if self.watch_time < 0 else self.watch_time
            logging.info(f'watch time: {self.watch_time}')
            if self.watch_time >= self.NOTIFY_TIME:
                logging.info('start notify')
                self.notify()
                logging.info('stop notify')
                self.watch_time = 0
            await asyncio.sleep(self.INTERVAL_TIME)

    def notify(self):
        logging.info('notify')
        os.system('notify-send -u critical -a "护眼提醒" -t 30000 "⚠️ 注意" "您已连续注视屏幕 {:d} 分钟"'.format(
            round(self.watch_time / 60)))
        #  os.system('zenity --info --text "⚠️ 注意 您已连续注视屏幕 {:d} 分钟"'.format(
        #      round(self.watch_time / 60)))

    def main(self):
        loop = asyncio.new_event_loop()
        asyncio.set_event_loop(loop)
        tasks = [self.get_watch_stat(), self.set_watch_time()]
        loop.run_until_complete(asyncio.wait(tasks))
        loop.close()


if __name__ == "__main__":
    cwt = CalcWatchTime()
    cwt.main()
