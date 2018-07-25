import pandas as pd
import numpy as np
import seaborn as sns
import matplotlib.pyplot as plt

df = pd.read_excel('ptxdiffconc.xlsx')
df.dropna(inplace=True)
df2 = df.groupby('Group').mean()
df2 = df2.reindex(['ctrl', 'ptx 1nM', 'ptx 10nM', 'ptx 100nM', 'ptx 150nM', 'ptx 200nM'])
df2 = df2.reset_index()
print(df2)

# variable = 'Scaled NCV'
# sns.boxplot(x='Group',y=variable,data=df)
# plt.title(variable+' vs Group')
# plt.show()



df = df[np.abs(df.Amplitude-df.Amplitude.mean()) <= (2*df.Amplitude.std())] # remove outliers
sns.barplot(x='Group', y='Amplitude', data=df, order=['ctrl', 'ptx 1nM', 'ptx 10nM', 'ptx 100nM', 'ptx 150nM', 'ptx 200nM'])
plt.show()

sns.pointplot(x='Group', y='Amplitude', data=df, order=['ctrl', 'ptx 1nM', 'ptx 10nM', 'ptx 100nM', 'ptx 150nM', 'ptx 200nM'])
plt.show()
