import pandas as pd
from sqlalchemy import create_engine

df= pd.read_csv("superstore_sales_data.csv")

print(df.shape)

print(df.info())
print(df.duplicated().sum())

print("Before:", df.shape)

df = df.drop_duplicates()

print("After:", df.shape)

print(df.isna().sum())

df['Customer Name'] = df['Customer Name'].fillna(
    df.groupby('Customer ID')['Customer Name'].transform('first')
)

print(df["Customer ID"].isna().sum())

print(df.isna().sum())

print(df['Ship Mode'].value_counts())
print(df['Ship Mode'].isna().sum())

df['Ship Mode'] = df['Ship Mode'].fillna(df['Ship Mode'].mode()[0])
print(df['Ship Mode'].isna().sum())

print(df.isna().sum())

df["Order Date"] = pd.to_datetime(df["Order Date"])
df["Ship Date"] = pd.to_datetime(df["Ship Date"])

df["Region"] = df["Region"].str.title()

print(df[["Order Date", "Ship Date", "Region"]].head(20))
print(df["Region"].value_counts())


df=df.drop_duplicates()
print(df["Order ID"].duplicated().sum())

print(df.info())
print(df.shape)

print("Negative Sales:", (df['Sales'] < 0).sum())
print("Zero/Negative Quantity:", (df['Quantity'] <= 0).sum())
print("Negative Discount:", (df['Discount'] < 0).sum())
print("Discount > 1:", (df['Discount'] > 1).sum())
print("Final missing values check:")
print(df.isna().sum())
print("Final shape:", df.shape)


df['Order Year'] = df['Order Date'].dt.year
df['Order Month'] = df['Order Date'].dt.month
df['Order Month Name'] = df['Order Date'].dt.strftime('%b')  

# Delivery Days
df['Delivery Days'] = (df['Ship Date'] - df['Order Date']).dt.days

# Profit Margin percentage
df['Profit Margin %'] = round((df['Profit'] / df['Sales']) * 100, 2)

print(df[['Order Date', 'Order Year', 'Order Month Name', 'Delivery Days', 'Profit Margin %']].head(10))


df.columns = (
    df.columns
    .str.strip()
    .str.lower()
    .str.replace(' ', '_')
    .str.replace('-', '_')
    .str.replace('%', 'pct')
)

print(df.columns.tolist())


df.to_csv('superstore_cleaned.csv', index=False)


from sqlalchemy import create_engine

# # MySQL connection
username = 'root'
password = 'Your_Password'
host = 'localhost'
port = '3306'
database = 'superstore_db'

engine = create_engine(f'mysql+pymysql://{username}:{password}@{host}:{port}/{database}')


df.to_sql('sales', con=engine, if_exists='replace', index=False)

print("Data successfully loaded into MySQL!")

# Verify
check = pd.read_sql('SELECT COUNT(*) as total_rows FROM sales', con=engine)
print(check)

