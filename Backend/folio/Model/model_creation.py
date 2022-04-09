import os
import warnings

warnings.filterwarnings("ignore")
os.environ["TF_CPP_MIN_LOG_LEVEL"] = "3"
from nsepy import get_history
import tensorflow as tf
from datetime import datetime
from dateutil.relativedelta import *
import numpy as np
import pandas as pd
from sklearn.preprocessing import MinMaxScaler
from sklearn.decomposition import PCA
from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import Dense, LSTM
from tensorflow.keras.callbacks import EarlyStopping
from tensorflow.keras import callbacks

# Parameters Required : Close, Prev Close, Open, High, Low, Volume, 50DMA, RSI14, VWAP, India Vix
scalerTable = MinMaxScaler(feature_range=(0, 1))
scalerClose = MinMaxScaler(feature_range=(0, 1))
pca = PCA(n_components=1)


def get_data(symbol):
    return get_ohlc(symbol)


def format_data(data, timeframe):
    data = get_indiavix(data, timeframe)
    data = format_timeframe(data, timeframe)
    data = calculate_dma(data)
    data = calculate_rsi(data)
    data = data.iloc[49:]
    data.reset_index(inplace=True, drop=True)
    data.dropna(inplace=True)
    return data


def get_ohlc(symbol):
    data = get_history(
        symbol=symbol,
        start=(datetime.today() - relativedelta(days=3600)),
        end=datetime.today(),
    )
    data = data.filter(
        ["Date", "Prev Close", "Open", "High", "Low", "VWAP", "Volume", "Close"]
    )
    return data


def calculate_dma(data):
    data["50DMA"] = data.iloc[:, 0].rolling(window=50).mean()
    return data


def calculate_rsi(data):
    close_delta = data["Close"].diff()
    up = close_delta.clip(lower=0)
    down = -1 * close_delta.clip(upper=0)

    ma_up = up.rolling(window=14).mean()
    ma_down = down.rolling(window=14).mean()

    rsi = ma_up / ma_down
    rsi = 100 - (100 / (1 + rsi))

    data["RSI14"] = rsi
    return data


def get_indiavix(data, timeframe):
    if timeframe == "Day":
        indiavix = get_history(
            symbol="INDIAVIX",
            start=(datetime.today() - relativedelta(days=500)),
            end=datetime.today(),
            index=True,
        )
    if timeframe == "Week":
        indiavix = get_history(
            symbol="INDIAVIX",
            start=(datetime.today() - relativedelta(days=1200)),
            end=datetime.today(),
            index=True,
        )
    if timeframe == "Month":
        indiavix = get_history(
            symbol="INDIAVIX",
            start=(datetime.today() - relativedelta(days=3600)),
            end=datetime.today(),
            index=True,
        )
    indiavix.dropna(inplace=True)
    data["IndiaVix"] = indiavix.Close
    return data


def format_timeframe(data, timeframe):
    if timeframe == "Day":
        data["Dates"] = data.index
        return data
    elif timeframe == "Week":
        data_copy = pd.DataFrame(columns=data.columns)
        data["Dates"] = data.index
        try:
            for i in range(0, data.shape[0] - 1, 5):
                data_copy = data_copy.append(
                    {
                        "Prev Close": data.iloc[i : i + 5]["Prev Close"].values[0],
                        "Open": data.iloc[i : i + 5]["Open"].values[0],
                        "High": data.iloc[i : i + 5]["Prev Close"].values.max(),
                        "Low": data.iloc[i : i + 5]["Prev Close"].values.min(),
                        "VWAP": np.average(data.iloc[i : i + 5]["VWAP"].values),
                        "Volume": np.average(data.iloc[i : i + 5]["Volume"].values),
                        "Close": data.iloc[i : i + 5]["Close"].values[-1],
                        "IndiaVix": np.average(data.iloc[i : i + 5]["IndiaVix"]),
                        "Dates": data.iloc[i + 5]["Dates"],
                    },
                    ignore_index=True,
                )
        except:
            pass

        # Backtest
        # data_copy = data_copy[:-1]
        return data_copy
    elif timeframe == "Month":
        data_copy = pd.DataFrame(columns=data.columns)
        data["Dates"] = data.index
        try:
            for i in range(0, data.shape[0] - 1, 21):
                data_copy = data_copy.append(
                    {
                        "Prev Close": data.iloc[i : i + 21]["Prev Close"].values[0],
                        "Open": data.iloc[i : i + 21]["Open"].values[0],
                        "High": data.iloc[i : i + 21]["Prev Close"].values.max(),
                        "Low": data.iloc[i : i + 21]["Prev Close"].values.min(),
                        "VWAP": np.average(data.iloc[i : i + 21]["VWAP"].values),
                        "Volume": np.average(data.iloc[i : i + 21]["Volume"].values),
                        "Close": data.iloc[i : i + 21]["Close"].values[-1],
                        "IndiaVix": np.average(data.iloc[i : i + 21]["IndiaVix"]),
                        "Dates": data.iloc[i + 21]["Dates"],
                    },
                    ignore_index=True,
                )
        except:
            pass

        # Backtest
        # data_copy = data_copy[:-1]
        return data_copy


def perform_pca(data):
    data[list(data.columns)] = scalerTable.fit_transform(data[data.columns.tolist()])
    return pca.fit_transform(data)


def format_X(data):
    x_data = []
    for i in range(7, len(data)):
        x_data.append(data[i - 7 : i, 0])

    x_data = np.array(x_data)
    x_data = np.reshape(x_data, (x_data.shape[0], x_data.shape[1], 1))
    return x_data


def format_Y(data):
    return np.array(data[7:])


def generate_model(X_data, Y_data, i, symbol):
    model = Sequential()
    model.add(LSTM(units=128, return_sequences=True))
    model.add(LSTM(units=64, return_sequences=True))
    model.add(LSTM(units=32, return_sequences=False))
    model.add(Dense(units=16))
    model.add(Dense(units=1))

    es = EarlyStopping(monitor="loss", mode="min", verbose=0, patience=10)
    model.compile(optimizer="adam", loss="mean_absolute_error")

    history = model.fit(
        X_data, Y_data, batch_size=32, epochs=200, verbose=0, callbacks=[es]
    )

    return model


def pop_and_replace(X_data, Popper):
    X_data = np.delete(X_data[-1], 0)
    X_data = np.append(X_data, Popper[0][0])
    X_data = np.array(X_data)
    X_data = np.reshape(X_data, (1, X_data.shape[0], 1))
    return X_data


def reduce_range(PrevClose, PredClose):

    UpperCircuit = round((0.05 * PrevClose) + PrevClose, 2)
    LowerCircuit = round((-0.05 * PrevClose) + PrevClose, 2)

    if PredClose > UpperCircuit:
        return UpperCircuit
    elif PredClose < LowerCircuit:
        return LowerCircuit
    return PredClose


def popper_handle(data):
    data = data.filter(
        ["Close", "VWAP", "Open", "High", "Low", "Volume", "50DMA", "RSI14", "IndiaVix"]
    ).tolist()
    data = scalerTable.transform(np.reshape(data, (1, -1)))
    return pca.transform(data)


def start_train(symbol):
    Predictions = []
    PrevClose = 0
    Date = 0

    try:
        master_data = get_data(symbol)

        for i in ["Day", "Week", "Month"]:
            data = format_data(master_data, i)

            Popper = data.iloc[-1, :]

            if PrevClose == 0 and Date == 0:
                PrevClose = Popper["Close"]
                Date = Popper["Dates"]

            X_data = perform_pca(
                data.filter(
                    [
                        "Prev Close",
                        "Open",
                        "High",
                        "Low",
                        "VWAP",
                        "Volume",
                        "50DMA",
                        "RSI14",
                        "IndiaVix",
                    ]
                )
            )
            Y_data = scalerClose.fit_transform(
                np.reshape(data["Close"].values, (-1, 1))
            )

            Popper = popper_handle(Popper)
            X_data = format_X(X_data)
            Y_data = format_Y(Y_data)

            model = generate_model(X_data, Y_data, i, symbol)

            X_data = pop_and_replace(X_data, Popper)
            Y_pred = scalerClose.inverse_transform(model.predict(X_data))
            Y_pred = reduce_range(PrevClose, Y_pred[0][0])

            tf.keras.backend.clear_session()

            Predictions.append(str(round(Y_pred, 2)))

        if len(Predictions) == 1:
            Predictions.extend([0, 0])
        if len(Predictions) == 2:
            Predictions.append(0)

    except IndexError:
        Predictions = [0, 0, 0]

    return Predictions, PrevClose, Date
