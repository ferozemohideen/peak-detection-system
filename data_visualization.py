import pandas as pd
import numpy as np
import seaborn as sns
import matplotlib.pyplot as plt

ctrldata = pd.read_csv('ctrlamplitudes', header=None)
ptxdata = pd.read_csv('ptxamplitudes', header=None)

# df1 = pd.DataFrame(data=ctrldata.values, columns=['ctrl'])
# print(df1)
fig, ax = plt.subplots(nrows=2, ncols=1)

ax[0].set_xlim(0, 12)
ax[0].set_xlabel('Control NCV')
ax[0].set_title("Amplitude Distributions in EPhys Data", fontsize=16)
ax[0].set_ylabel('Count')
ax[0].legend('yes')
ax[1].set_ylabel('Count')
ax[1].set_xlim(0, 12)
ax[1].set_xlabel('Ptx NCV')

sns.distplot(ctrldata, ax=ax[0], kde=False, rug=True)

sns.distplot(ptxdata, ax=ax[1], kde=False, rug=True)
plt.tight_layout()

plt.show()
