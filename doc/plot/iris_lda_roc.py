#!/usr/bin/env python
# Andre Anjos <andre.anjos@idiap.ch>
# Sat 24 Mar 2012 18:51:21 CET

"""Computes an ROC curve for the Iris Flower Recognition using Linear Discriminant Analysis and Bob.
"""

import bob.db.iris
import bob.learn.linear
import bob.measure
import numpy
import matplotlib.pyplot as plt

# Training is a 3-step thing
data = bob.db.iris.data()
trainer = bob.learn.linear.FisherLDATrainer()
machine, eigen_values = trainer.train(data.values())

# A simple way to forward the data
output = {}
for key, value in data.items():
    output[key] = machine(value)

# Performance
negatives = numpy.vstack([output["setosa"], output["versicolor"]])[:, 0]
positives = output["virginica"][:, 0]

# Plot ROC curve
fpr, fnr = bob.measure.roc(negatives, positives, n_points=2000)
plt.plot(100 * fpr, 100 * fnr)
plt.xlabel("False Virginica Acceptance (%)")
plt.ylabel("False Virginica Rejection (%)")
plt.title("ROC Curve for Virginica Classification")
plt.grid()
