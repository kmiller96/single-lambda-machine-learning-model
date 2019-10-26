import pandas as pd
import pytest
from tempfile import TemporaryDirectory
import os

from src.utilities.model import Model
from src.utilities.preprocessing import Xy_split, preprocess

def load_df():
    data = pd.read_csv('test/data/bank.csv', sep=';')
    return data 


@pytest.fixture
def df():
    return load_df()


@pytest.fixture 
def X():
    df = load_df()
    X, _ = Xy_split(df, target='y')
    X = preprocess(X)
    return X


@pytest.fixture 
def y():
    df = load_df()
    _, y = Xy_split(df, target='y')
    return y


@pytest.fixture
def model():
    """Initialises a model with all of the default hyperparameters."""
    return Model()


@pytest.fixture
def csv_directory():
    """Directory full of CSV files. Comes with 3 CSV files."""
    df = pd.DataFrame({
        'a': list(range(10)),
        'b': list(range(0, 100, 10)),
    })
    with TemporaryDirectory() as tmpdir:
        for i in range(3):
            df.to_csv(os.path.join(tmpdir, f'data{i}.csv'), index=False)
        yield tmpdir


@pytest.fixture 
def s3_put_event():
    event = {  
        "Records":[  
            {  
                "eventVersion":"2.1",
                "eventSource":"aws:s3",
                "awsRegion":"us-west-2",
                "eventTime":"1970-01-01T00:00:00.000Z",
                "eventName":"ObjectCreated:Put",
                "userIdentity":{  
                    "principalId":"AIDAJDPLRKLG7UEXAMPLE"
                },
                "requestParameters":{  
                    "sourceIPAddress":"127.0.0.1"
                },
                "responseElements":{  
                    "x-amz-request-id":"C3D13FE58DE4C810",
                    "x-amz-id-2":"FMyUVURIY8/IgAtTv8xRjskZQpcIZ9KG4V5Wp6S7S/JRWeUWerMUE5JgHvANOjpD"
                },
                "s3":{  
                    "s3SchemaVersion":"1.0",
                    "configurationId":"testConfigRule",
                    "bucket":{  
                    "name":"mybucket",
                    "ownerIdentity":{  
                        "principalId":"A3NL1KOZZKExample"
                    },
                    "arn":"arn:aws:s3:::mybucket"
                    },
                    "object":{  
                    "key":"HappyFace.jpg",
                    "size":1024,
                    "eTag":"d41d8cd98f00b204e9800998ecf8427e",
                    "versionId":"096fKKXTRTtl3on89fVO.nfljtsv6qko",
                    "sequencer":"0055AED6DCD90281E5"
                    }
                }
            }
        ]
    }
    return event