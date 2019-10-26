import pandas as pd
import pytest

from src.training.app import train
from test.fixtures import s3_put_event


@pytest.mark.skip("TODO")
def test_train():
    assert 0