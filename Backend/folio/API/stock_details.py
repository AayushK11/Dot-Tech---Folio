import pandas as pd
from nsepy import get_history
from datetime import datetime
from dateutil.relativedelta import *


def return_logo(symbol):
    df = pd.read_csv("API\ind_nifty50list.csv")
    df = df[df["Symbol"] == symbol]
    return df["Logo"].values[0]


def return_company(symbol):
    df = pd.read_csv("API\ind_nifty50list.csv")
    df = df[df["Symbol"] == symbol]
    return df["Company"].values[0]


def return_latest_close(symbol):
    data = get_history(
        symbol=symbol, start=datetime.now() - relativedelta(days=5), end=datetime.now()
    )
    return data.iloc[-1]["Close"]


def return_symbols():
    df = pd.read_csv("API\ind_nifty50list.csv")
    return df["Symbol"].values