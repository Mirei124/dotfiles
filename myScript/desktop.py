for i in ['suspend', 'hibernate', 'poweroff', 'reboot']:
    with open(i+'.desktop', 'w') as fp:
        string = \
f'''[Desktop Entry]
Name={i}
Comment={i}
Type=Application
Exec=systemctl {i}
'''
        fp.write(string)
