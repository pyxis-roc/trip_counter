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

# Figure 1: Initialization Time
fig1, ax1 = plt.subplots()
bar_width = 0.35
index = np.arange(len(sizes))

ax1.bar(index, instr_analysis_time, bar_width, label='instr_analysis_time')
ax1.bar(index + bar_width, proxy_analysis_time, bar_width, label='proxy_analysis_time')

ax1.set_xticks(index + bar_width / 2)
ax1.set_xticklabels(sizes)

ax1.set_xlabel('Input Size')
ax1.set_ylabel('Initialization Time (ms)')
ax1.set_title('Initialization Time of Instr and Proxy')
ax1.set_yscale('log')

plt.legend()
plt.savefig('results/conv_init_time_comparison.pdf')

# Figure 1: Execution Time
fig1, ax1 = plt.subplots()
bar_width = 0.35
index = np.arange(len(sizes))

ax1.bar(index, instr_exec_time, bar_width, label='LLVM PGO')
ax1.bar(index + bar_width, proxy_exec_time, bar_width, label='Proxy')

ax1.set_xticks(index + bar_width / 2)
ax1.set_xticklabels(sizes)

ax1.set_xlabel('Input Size')
ax1.set_ylabel('Execution Time (ms)')
ax1.set_title('Execution Time of LLVM PGO Instrumentation and Proxy')
ax1.set_yscale('log')
ax1.yaxis.grid(True, which='both', linestyle='--', linewidth=0.5)

plt.legend()
plt.savefig('results/conv-execution-time-comparison.pdf')