import os
try: 
    import utilities
except ModuleNotFoundError:  # Happpens when calling pytest.
    from . import utilities

DATA_BUCKET = os.environ['DATA_BUCKET']
DATA_PREFIX = os.environ['DATA_PREFIX']
DATA_TMP_DST = '/tmp/data/'

MODEL_BUCKET = os.environ['MODEL_BUCKET']
MODEL_PREFIX = os.environ['MODEL_PREFIX']


def train(event, context):
    """Trains our ML model."""
    utilities.download_directory(uri=f"s3://{DATA_BUCKET}/{DATA_PREFIX}", dst=DATA_TMP_DST)
    df = utilities.read_csv_directory(DATA_TMP_DST)
    print(f"SHAPE: {df.shape}")

    train, test = utilities.train_test_split(df)
    X_train, y_train = utilities.Xy_split(train, target='y')
    X_test, y_test = utilities.Xy_split(test, target='y')

    X_train = utilities.preprocessing.preprocess(X_train)
    X_test = utilities.preprocessing.preprocess(X_test)

    model = utilities.Model()
    model.fit(X_train, y_train)

    y_hat = model.predict(X_test)
    eval_results = utilities.evaluate(y_actual=y_test, y_predict=y_hat)

    utilities.save_model(obj=model, uri=f"s3://{DATA_BUCKET}/{MODEL_PREFIX}")
    return {
        "status": "success",
        "results": eval_results,
    }

