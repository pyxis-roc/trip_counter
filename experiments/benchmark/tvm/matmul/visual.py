import matplotlib.pyplot as plt
import numpy as np
import pandas as pd

plt.style.use('tableau-colorblind10')

matmul_init1 = pd.read_csv('results/matmul_init1.csv')

matmul_exp1 = pd.read_csv('results/matmul_exp1.csv')
matmul_exp2 = pd.read_csv('results/matmul_exp2.csv')

instr_analysis_time = [matmul_init1['instr_analysis'][0]] * len(matmul_exp1)
proxy_analysis_time = [matmul_init1['proxy_analysis'][0]] * len(matmul_exp1)

sizes = matmul_exp1['size'].astype(str)
instr_exec_time = (matmul_exp1['instr_exec_time'] + matmul_exp2['instr_exec_time']) / 2 * 1000
proxy_exec_time = (matmul_exp1['proxy_exec_time'] + matmul_exp2['proxy_exec_time']) / 2 * 1000

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
plt.savefig('results/matmul-execution-time-comparison.pdf')

# Figure 2: Analysis Time
fig2, ax2 = plt.subplots()

ax2.bar(index, instr_analysis_time, bar_width, label='LLVM PGO')
ax2.bar(index + bar_width, proxy_analysis_time, bar_width, label='Proxy')

ax2.set_xticks(index + bar_width / 2)
ax2.set_xticklabels(sizes)

ax2.set_xlabel('Input Size')
ax2.set_ylabel('Analysis Time (ms)')
ax2.set_title('Analysis Time of LLVM PGO Instrumentation and Proxy')
# ax2.set_yscale('log')

plt.legend()
plt.savefig('results/matmul-analysis-time-comparison.pdf')