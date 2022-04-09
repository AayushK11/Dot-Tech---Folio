import requests
from bs4 import BeautifulSoup
import pandas as pd
import io
import requests
import os
import sqlite3
import Model.model_creation


def get_nifty50():

    return pd.read_csv(
        "C:\\Users\\Aayus\\Desktop\\temp\\Backend\\fintech\\API\\ind_nifty50list.csv"
    )


def table_create(connection):
    connection.execute(
        """CREATE TABLE TICKERS (
            CODE VARCHAR(250) NOT NULL,
            PREDICTIONDAY VARCHAR(50), 
            PREDICTIONWEEK VARCHAR(50), 
            PREDICTIONMONTH VARCHAR(50),
            PREVCLOSE VARCHAR(50),
            PREVDATE VARCHAR(50));"""
    )


def table_addition(connection, data):
    for i in data.iterrows():
        connection.execute(
            "INSERT INTO TICKERS (CODE) VALUES ('{}')".format(i[1][1].replace("'", ""))
        )
        connection.commit()


def database_init():
    open("Databases//tickerdb.sqlite3", "a").close()
    data = get_nifty50()

    con = sqlite3.connect("Databases//tickerdb.sqlite3")
    table_create(con)

    table_addition(con, data)
    con.close()


def search_and_add(ticker):
    con = sqlite3.connect("Databases//tickerdb.sqlite3")
    cur = con.cursor()
    cur.execute("SELECT * FROM TICKERS WHERE CODE = '{}'".format(ticker.upper()))
    rows = cur.fetchall()

    if len(rows) == 0:
        return add_new_ticker(ticker, con)
    else:
        return rows


def add_new_ticker(ticker, connection):
    connection.execute(
        "INSERT INTO TICKERS (CODE) VALUES ('{}')".format(
            ticker.replace("'", "").upper()
        )
    )
    connection.commit()
    return [(ticker, None, None, None, None, None)]

    con.close()


def add_prediction(
    Code, PredictionDay, PredictionWeek, PredictionMonth, PrevClose, PrevDate
):
    con = sqlite3.connect("Databases//tickerdb.sqlite3")
    cur = con.cursor()
    cur.execute(
        """UPDATE TICKERS SET 
        PREDICTIONDAY='{PredictionDay}', 
        PREDICTIONWEEK='{PredictionWeek}', 
        PREDICTIONMONTH='{PredictionMonth}',
        PREVCLOSE='{PrevClose}',
        PREVDATE='{PrevDate}' 
        WHERE CODE='{Code}'""".format(
            PredictionDay=PredictionDay,
            PredictionWeek=PredictionWeek,
            PredictionMonth=PredictionMonth,
            PrevClose=PrevClose,
            PrevDate=PrevDate,
            Code=Code,
        )
    )
    con.commit()
    con.close()


def db_train():
    con = sqlite3.connect("Databases//tickerdb.sqlite3")
    cur = con.cursor()
    cur.execute("SELECT * FROM TICKERS")
    rows = cur.fetchall()
    for i in rows:
        Code = i[0]
        print("---->Training {}".format(Code))
        (
            [PredictionDay, PredictionWeek, PredictionMonth],
            PrevClose,
            PrevDate,
        ) = Model.model_creation.start_train(Code)
        add_prediction(
            Code, PredictionDay, PredictionWeek, PredictionMonth, PrevClose, PrevDate
        )
    con.close()


def clear_temp_values():
    con = sqlite3.connect("Databases//tickerdb.sqlite3")
    cur = con.cursor()
    cur.execute(
        """DELETE FROM TICKERS WHERE 
        PREDICTIONDAY LIKE 'Insufficient data%' AND 
        PREDICTIONWEEK LIKE 'Insufficient data%' AND 
        PREDICTIONMONTH LIKE 'Insufficient data%';"""
    )
    con.commit()


def auto_train(ticker=None):
    if "tickerdb.sqlite3" in os.listdir("Databases"):
        pass
    else:
        database_init()

    if ticker == None:
        print("---->Starting Auto-Update -- Stocks")
        db_train()
        clear_temp_values()
        print("---->Auto-Update Stocks Complete -- Stocks")
    else:
        (
            Code,
            PredictionDay,
            PredictionWeek,
            PredictionMonth,
            PrevClose,
            PrevDate,
        ) = search_and_add(ticker)[0]
        if PredictionDay == None:
            print("---->Learning New Ticker")
            (
                [PredictionDay, PredictionWeek, PredictionMonth],
                PrevClose,
                PrevDate,
            ) = Model.model_creation.start_train(Code)
            add_prediction(
                Code,
                PredictionDay,
                PredictionWeek,
                PredictionMonth,
                PrevClose,
                PrevDate,
            )
            return (
                PredictionDay,
                PredictionWeek,
                PredictionMonth,
                str(PrevClose),
                str(PrevDate),
            )
        return (
            PredictionDay,
            PredictionWeek,
            PredictionMonth,
            str(PrevClose),
            str(PrevDate),
        )
