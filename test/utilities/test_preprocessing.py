import pandas as pd
import pytest

from src.utilities import preprocessing
from test.fixtures import df



def test_Xysplit(df):
    X, y = preprocessing.Xy_split(df, target='y')
    assert len(X.columns) == (len(df.columns) - 1)
    assert isinstance(y, pd.Series)
    assert len(X) == len(y)
    assert len(X) == len(df)


def test_train_test_split(df):
    train, test = preprocessing.train_test_split(df)
    assert (len(train) + len(test)) == len(df)
    for i in test.index.values:
        assert i not in train.index


def test_preprocess(df):
    X = preprocessing.preprocess(df)
    assert set(X.columns) == {'age', 'balance'}
    assert len(X) == len(df)