import pandas as pd
import pytest
import os

from src.utilities import other
from test.fixtures import csv_directory


def test_read_csv_directory(csv_directory):
    n_files = len(os.listdir(csv_directory))
    df_single = pd.read_csv(os.path.join(csv_directory, 'data0.csv'))
    df = other.read_csv_directory(csv_directory)
    assert len(df) == n_files * len(df_single)


def test_split_s3_uri():
    file_uri = "s3://my-bucket/my/path/to/file.ext"
    dir_uri = "s3://my-bucket/my/directory/"
    assert other.split_s3_uri(file_uri) == ("my-bucket", 'my/path/to/file.ext')
    assert other.split_s3_uri(dir_uri) == ("my-bucket", 'my/directory/')


def test_download_directory(tmpdir):
    dir_uri = 's3://adss-single-lambda/data/'
    other.download_directory(uri=dir_uri, dst=tmpdir)
    assert 'bank.csv' in os.listdir(tmpdir)