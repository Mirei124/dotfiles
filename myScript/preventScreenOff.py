from pynput.mouse import Controller
from time import sleep

mouse = Controller()
while True:
    mouse.move(-10, -10)
    sleep(60 * 8)
