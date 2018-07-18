import pandas as pd
import numpy as np
import seaborn as sns
import matplotlib.pyplot as plt

ctrlamp = pd.read_csv('ctrlamplitudes', header=None)
ctrlamp['Label'] = pd.Series(['ctrl' for x in ctrlamp[0]], index=ctrlamp.index)
ctrlamp.columns = ['Amplitude', 'Label']

ptxamp = pd.read_csv('ptxamplitudes', header=None)
ptxamp['Label'] = pd.Series(['ptx' for x in ptxamp[0]], index=ptxamp.index)
ptxamp.columns = ['Amplitude', 'Label']

ctrlatency = pd.read_csv('ctrllatencies', header=None)
ctrlatency['Label'] = pd.Series(['ctrl' for x in ctrlatency[0]], index=ctrlatency.index)
ctrlatency.columns = ['NCV', 'Label']

ptxlatency = pd.read_csv('ptxlatencies', header=None)
ptxlatency['Label'] = pd.Series(['ptx' for x in ptxlatency[0]], index=ptxlatency.index)
ptxlatency.columns = ['NCV', 'Label']

df1 = pd.concat([ctrlamp, ptxamp])
df2 = pd.concat([ctrlatency, ptxlatency])

fig, ax = plt.subplots(nrows=1, ncols=3)
fig.set_size_inches(10, 5, forward=True)

ax[0].set_title("Amplitudes")
ax[1].set_title("Scaled NCV")
ax[2].set_title("Scaled NCV Bargraph")

sns.boxplot(y='Label', x='Amplitude', data=df1, ax=ax[0])
sns.boxplot(y='Label', x='NCV', data=df2, ax=ax[1])
sns.barplot(x='Label', y='NCV', data=df2, ax=ax[2])

plt.tight_layout()
plt.show()
