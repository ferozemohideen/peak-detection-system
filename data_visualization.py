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

df = pd.DataFrame(index=['1 - Control', '2 - 1 nM', '3 - 10 nM', '4 - 100 nM', '5 - 200 nM', '6 - 400 nM', '7 - 600 nM', '8 - 1 uM'],
                  data={'mine': [0.327550258, 0.288936793, 0.284344072, 0.254287591, 0.215150756, 0, 0, 0],
                        'hieu': [0.342806646, 0.266375129, 0.283745423, 0.236454349, 0.279466029, 0, 0, 0]})
print(df)


# df = df[np.abs(df.Amplitude-df.Amplitude.mean()) <= (2*df.Amplitude.std())] # remove outliers
# sns.barplot(x='Group', y='Amplitude', data=df, order=['ctrl', 'ptx 1nM', 'ptx 10nM', 'ptx 100nM', 'ptx 150nM', 'ptx 200nM'])
# plt.show()
#
# sns.pointplot(x='Group', y='Amplitude', data=df, order=['ctrl', 'ptx 1nM', 'ptx 10nM', 'ptx 100nM', 'ptx 150nM', 'ptx 200nM'])
# plt.show()

sns.set(style="darkgrid")
fig = plt.figure(figsize=(10,5))
ax = sns.lineplot(x=df.index, y=df['mine'], marker='o', label='Program Estimation', color="#bb3f3f")
ax = sns.lineplot(x=df.index, y=df['hieu'], marker='o', label='Hieu\'s Estimation', color="#000000")

plt.xlabel('Ptx Concentrations')
plt.ylabel('NCV')
plt.legend()
plt.title('Paclitaxel dose response 7d NCV')
plt.tight_layout()
plt.show()