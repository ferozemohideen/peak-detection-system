import pandas as pd
import numpy as np
import seaborn as sns
import matplotlib.pyplot as plt

df = pd.read_excel('realallcontrols.xlsx')
df.reset_index()
boxplot = df.boxplot(df.columns)
#plt.show()

