import pytest

from src.utilities import evaluation
from test.fixtures import y

def test_evaluate(y):
    results = evaluation.evaluate(y_actual=y, y_predict=y)
    assert results['auc'] == 1