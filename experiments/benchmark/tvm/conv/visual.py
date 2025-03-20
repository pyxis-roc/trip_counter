import matplotlib.pyplot as plt
import numpy as np
import pandas as pd

plt.style.use('tableau-colorblind10')

conv_init1 = pd.read_csv('results/conv_init1.csv')

conv_exp1 = pd.read_csv('results/conv_exp1.csv')
conv_exp2 = pd.read_csv('results/conv_exp2.csv')
conv_exp3 = pd.read_csv('results/conv_exp3.csv')

instr_analysis_time = [conv_init1['instr_analysis'][0]] * len(conv_exp1)
proxy_analysis_time = [conv_init1['proxy_analysis'][0]] * len(conv_exp1)

sizes = conv_exp1['size'].astype(str)
instr_exec_time = (conv_exp1['instr_exec_time'] + conv_exp2['instr_exec_time'] + conv_exp3['instr_exec_time']) / 3 * 1000
proxy_exec_time = (conv_exp1['proxy_exec_time'] + conv_exp2['proxy_exec_time'] + conv_exp3['proxy_exec_time']) / 3 * 1000

fig, ax = plt.subplots()
bar_width = 0.35
index = np.arange(len(sizes))

ax.bar(index, instr_exec_time + instr_analysis_time, bar_width, label='instr_exec_time')
ax.bar(index, instr_analysis_time, bar_width, label='instr_analysis_time')
ax.bar(index + bar_width, proxy_exec_time + proxy_analysis_time, bar_width, label='proxy_exec_time')
ax.bar(index + bar_width, proxy_analysis_time, bar_width, label='proxy_analysis_time')

ax.set_xticks(index + bar_width / 2)
ax.set_xticklabels(sizes)

ax.set_xlabel('Input Size')
ax.set_ylabel('Execution Time (ms)')
ax.set_title('Execution Time of Instr and Proxy')
ax.set_yscale('log')

plt.legend()

plt.savefig('results/conv_runtime_comparison.pdf')