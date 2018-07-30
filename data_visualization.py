import pandas as pd
import numpy as np
import seaborn as sns
import matplotlib.pyplot as plt

# df = pd.read_excel('ptxdiffconc.xlsx')
# df.dropna(inplace=True)
# df2 = df.groupby('Group').mean()
# df2 = df2.reindex(['ctrl', 'ptx 1nM', 'ptx 10nM', 'ptx 100nM', 'ptx 150nM', 'ptx 200nM'])
# df2 = df2.reset_index()
# print(df2)

# variable = 'Scaled NCV'
# sns.boxplot(x='Group',y=variable,data=df)
# plt.title(variable+' vs Group')
# plt.show()

# dataframe of means
df = pd.DataFrame(index=['1 - Control', '2 - 1 nM', '3 - 10 nM', '4 - 100 nM', '5 - 200 nM', '6 - 400 nM', '7 - 600 nM', '8 - 1 uM'],
                  data={'mine': [0.327550258, 0.288936793, 0.284344072, 0.254287591, 0.215150756, 0, 0, 0],
                        'hieu': [0.342806646, 0.266375129, 0.283745423, 0.236454349, 0.279466029, 0, 0, 0]})
# dataframe of medians
df_1 = df
df_1['mine'] = [0.319019154, 0.248037378, 0.294670001, 0.249406688, 0.210229277, 0, 0, 0]
df_1['hieu'] = [0.319850276, 0.234918587, 0.269359568, 0.233535354, 0.295, 0, 0, 0]


# df = df[np.abs(df.Amplitude-df.Amplitude.mean()) <= (2*df.Amplitude.std())] # remove outliers
# sns.barplot(x='Group', y='Amplitude', data=df, order=['ctrl', 'ptx 1nM', 'ptx 10nM', 'ptx 100nM', 'ptx 150nM', 'ptx 200nM'])
# plt.show()
#
# sns.pointplot(x='Group', y='Amplitude', data=df, order=['ctrl', 'ptx 1nM', 'ptx 10nM', 'ptx 100nM', 'ptx 150nM', 'ptx 200nM'])
# plt.show()

sns.set(style="darkgrid")
fig, ax = plt.subplots(2, 1, figsize=(10,5))
sns.lineplot(x=df.index, y=df['mine'], marker='o', label='Program Estimation', color="#bb3f3f", ax=ax[0])
sns.lineplot(x=df.index, y=df['hieu'], marker='o', label='Hieu\'s Estimation', color="#000000", ax=ax[0])

ax[0].set_xlabel('Ptx Concentrations')
ax[0].set_ylabel('Mean NCV')
ax[0].legend()

sns.lineplot(x=df_1.index, y=df_1['mine'], marker='o', label='Program Estimation', color="#bb3f3f", ax=ax[1])
sns.lineplot(x=df_1.index, y=df_1['hieu'], marker='o', label='Hieu\'s Estimation', color="#000000", ax=ax[1])

ax[1].set_xlabel('Ptx Concentrations')
ax[1].set_ylabel('Median NCV')
ax[1].legend()

ax[0].set_title('Paclitaxel dose response 7d NCV')
plt.tight_layout()

df2 = pd.DataFrame(index=['1 - Control', '2 - 1 nM', '3 - 2 nM', '4 - 5 nM', '5 - 10 nM'],
                  data={'mine': [0.326084092, 0.391629325, 0.374289705, 0.38324933, 0],
                        'hieu': [0.333790098, 0.396568593, 0.411618231, 0.367230476, 0]})

df2_1 = df2
df2_1['mine'] = [0.326905418, 0.35059066, 0.359875845, 0.35614242, 0]
df2_1['hieu'] = [0.339102564, 0.37623241, 0.395156137, 0.356483703, 0]


fig2, ax2 = plt.subplots(2,1,figsize=(7,5))
sns.lineplot(x=df2.index, y=df2['mine'], marker='o', label='Program Estimation', color="#bb3f3f",ax=ax2[0])
sns.lineplot(x=df2.index, y=df2['hieu'], marker='o', label='Hieu\'s Estimation', color="#000000",ax=ax2[0])

ax2[0].set_xlabel('Bz Concentrations')
ax2[0].set_ylabel('Mean NCV')
ax2[0].legend()

sns.lineplot(x=df2.index, y=df2['mine'], marker='o', label='Program Estimation', color="#bb3f3f",ax=ax2[1])
sns.lineplot(x=df2.index, y=df2['hieu'], marker='o', label='Hieu\'s Estimation', color="#000000",ax=ax2[1])

ax2[1].set_xlabel('Bz Concentrations')
ax2[1].set_ylabel('Median NCV')
ax2[1].legend()

ax2[0].set_title('Bortezomib dose response 7d NCV')
plt.tight_layout()
plt.show()