import taichi as ti
import time
import numpy as np

import sys
import psutil
import os

# from guppy import hpy
# hp = hpy()
# before = hp.heap()


ti.init(debug=True, arch=ti.cpu)
# ti.init(arch=ti.gpu)

# y = np.zeros((28_000,2)) # ~ 10 MB/s
y = np.zeros((350_000,2)) # ~ 100 MB/s

i = 0
gui = ti.GUI("Mem leak")
while not gui.get_event(ti.GUI.ESCAPE):
    time.sleep(0.1)
    gui.circles(y)
    gui.clear()
    gui.show()

    # mem use output
    i = i + 1
    if i % 5 == 0:
        info = psutil.Process(os.getpid()).memory_info()
        print(time.strftime("[%H:%M:%S] ", time.localtime()), end='')
        print(f'vms={info.vms/1024/1024:.1f}MB, rss={info.rss/1024/1024:.1f}MB')

# after = hp.heap()
# leftover = after - before
# import pdb; pdb.set_trace()
