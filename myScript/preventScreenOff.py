from pynput.mouse import Controller
from time import sleep

mouse = Controller()
while True:
    mouse.move(-1, -1)
    sleep(55)
