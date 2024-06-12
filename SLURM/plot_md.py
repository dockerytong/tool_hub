import numpy as np
import matplotlib.pyplot as plt
from matplotlib.animation import FuncAnimation

# 初始化图表
fig, ax = plt.subplots()
line, = ax.plot([], [], marker='o', color='b', linestyle='-')
ax.set_xlabel('Steps')
ax.set_ylabel('Temperature (K)')
ax.set_title('Real-time Temperature vs Steps Relationship')

# 读取数据并初始化变量
def read_data():
    data = np.genfromtxt('md-1.ener', skip_header=1)
    steps = data[:, 0]
    temperature = data[:, 3]
    return steps, temperature

# 初始化数据
steps, temperature = read_data()
num_frames = len(steps)
current_frame = 0

# 更新函数
def update(frame):
    global current_frame
    new_steps, new_temperature = read_data() # 重新读取数据
    if len(new_steps) > current_frame:
        # 只获取新的数据点
        new_data_steps = new_steps[current_frame:]
        new_data_temperature = new_temperature[current_frame:]
        
        # 更新当前帧
        current_frame = len(new_steps)
        
        # 更新图表数据
        line.set_data(new_steps, new_temperature)
        ax.relim() # 调整坐标轴范围
        ax.autoscale_view() # 自动缩放视图以适应数据范围
        return line,
    else:
        return line,

# 创建动画
ani = FuncAnimation(fig, update, frames=num_frames, blit=True, interval=1000, save_count=10) # 每秒更新一次

plt.show()
