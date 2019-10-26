import pandas as pd
import pytest

from src.training.app import train
from test.fixtures import s3_put_event


def test_train():
    train({}, {})