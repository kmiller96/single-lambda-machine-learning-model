from chalice import Chalice, Response
import utilities

app = Chalice(app_name='training')

DATA_BUCKET = 'adss-single-lambda'
DATA_PREFIX = 'train/'
DATA_TMP_DST = '/tmp/data/'

MODEL_BUCKET = 'adss-single-lambda'
MODEL_PREFIX = 'model/'


@app.on_s3_event(bucket=DATA_BUCKET, prefix=DATA_PREFIX)
def train(event):
    """Trains our ML model."""
    utilities.download_data(uri=f"s3://{DATA_BUCKET}/{PREFIX}", dst=DATA_TMP_DST)
    df = utilities.read_csv_directory(DATA_TMP_DST)

    train, test = utilities.train_test_split(df)
    X_train, y_train = utilities.Xy_split(train)
    X_test, y_test = utilities.Xy_split(test)

    X_train = utilities.preprocessing.preprocess(X_train)
    X_test = utilities.preprocessing.preprocess(X_test)

    model = utilities.Model()
    model.fit(X_train, y_train)

    y_hat = model.predict(y_test)
    eval_results = utilities.evaluate(y_actual=y_test, y_predict=y_hat)

    utilities.save_model(obj=model, uri=f"s3://{DATA_BUCKET}/{PREFIX}")
    return {
        "status": "success",
        "results": eval_results,
    }

