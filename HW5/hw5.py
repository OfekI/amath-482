import numpy as np
import tensorflow as tf
import matplotlib.pyplot as plt
import pandas as pd
from sklearn.metrics import confusion_matrix
from functools import partial

mnist = tf.keras.datasets.fashion_mnist
(X_train_full, y_train_full), (X_test, y_test) = mnist.load_data()


X_valid = X_train_full[:5000] / 255
X_train = X_train_full[5000:] / 255
X_test = X_test / 255

y_valid = y_train_full[:5000]
y_train = y_train_full[5000:]


def fully_connected():
    dense_layer = partial(tf.keras.layers.Dense, activation="relu",
                          kernel_regularizer=tf.keras.regularizers.l2(1e-6))

    model = tf.keras.models.Sequential([
        tf.keras.layers.Flatten(input_shape=[28, 28]),
        dense_layer(300),
        dense_layer(100),
        dense_layer(10, activation="softmax")
    ])

    model.compile(loss="sparse_categorical_crossentropy",
                  optimizer="nadam", metrics=["accuracy"])

    return (model.fit(X_train, y_train, epochs=10,
                      validation_data=(X_valid, y_valid)),
            model, 'Fully Connected Neural Network Results on Fashion-MNIST')


def convolutional():
    global X_valid, X_train, X_test

    X_train = X_train[..., np.newaxis]
    X_valid = X_valid[..., np.newaxis]
    X_test = X_test[..., np.newaxis]

    dense_layer = partial(tf.keras.layers.Dense, activation="relu",
                          kernel_regularizer=tf.keras.regularizers.l2(1e-6))
    conv_layer = partial(tf.keras.layers.Conv2D,
                         activation="relu", padding="valid")

    model = tf.keras.models.Sequential([
        conv_layer(6, 5, padding="same", input_shape=[28, 28, 1]),
        tf.keras.layers.AveragePooling2D(2),
        conv_layer(16, 5),
        tf.keras.layers.AveragePooling2D(2),
        conv_layer(120, 5),
        tf.keras.layers.Flatten(),
        dense_layer(84),
        dense_layer(10, activation="softmax")
    ])

    model.compile(loss="sparse_categorical_crossentropy",
                  optimizer="nadam",
                  metrics=["accuracy"])

    return (model.fit(X_train, y_train, epochs=10,
                      validation_data=(X_valid, y_valid)),
            model, 'Convolutional Neural Network Results on Fashion-MNIST')


get_model_history = convolutional
history, model, title = get_model_history()

pd.DataFrame(history.history).plot(figsize=(8, 5))
plt.grid(True)
plt.gca().set_ylim(0, 1)
plt.title(title)
plt.xlabel('Epochs')
plt.show()

y_pred = model.predict_classes(X_train)
conf_train = confusion_matrix(y_train, y_pred)
print(conf_train)

model.evaluate(X_test, y_test)
y_pred = model.predict_classes(X_test)
conf_test = confusion_matrix(y_test, y_pred)
print(conf_test)
