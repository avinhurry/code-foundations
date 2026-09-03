# Gradient Boosting

A small Ruby implementation of gradient boosting for regression from scratch.

Gradient boosting builds small trees one after another. Each new stump learns the residuals left by the current model and adds a correction to improve the prediction.

## Concepts covered

- Gradient boosting
- Residuals
- Decision stumps
- Weak learners
- Learning rate
- Shrinkage
- Train and test error
- Overfitting
- Validation data
- Early stopping
- Patience

## Running the experiments

```sh
ruby machine_learning/gradient_boosting/gradient_boosting_experiments.rb
```

## Running the tests

```sh
rspec machine_learning/gradient_boosting/gradient_boosting_spec.rb
```

## Gradient boosting experiments

The experiments demonstrate how boosting reduces residual error round by round, how the learning rate changes the size of each correction, how too many rounds can lead to overfitting, how boosting differs from random forests, and how validation data can be used for early stopping.

### Trace the errors

The model starts by predicting the average target value for every row.

Each new stump is then trained on the residuals left by the current predictions. After each round, the experiment prints the predictions, residuals and mean squared error.

The training MSE drops from about 48.9 to 8.4, then 2.3, then 0.76, showing how each stump corrects some of the error still left by the previous rounds.

### Learning rate

The experiment compares a learning rate of `1.0` with `0.1`.

With the same number of rounds, the smaller learning rate improves more slowly because every stump makes a smaller correction. Giving it more rounds lets those smaller corrections build up and can produce a better fit.

This scaling down of each trees contribution is called shrinkage.

### Watch it overfit

A small synthetic regression dataset with a simple trend and repeating noise is split into training and test data.

Models are trained with increasing numbers of boosting rounds while both train and test MSE are printed.

Training error keeps falling because the model continues fitting the training data more closely. If test error starts rising while training error still falls, the model is starting to overfit instead of generalising well.

### Boosting vs forest

The random forest and gradient boosting implementations in this repository currently solve different problems, so their scores are not directly comparable.

The random forest is a classifier that builds trees independently and combines their predictions by voting. The gradient booster is a regressor that builds stumps sequentially, with each stump correcting the residuals left by the current model.

Random forests are generally more forgiving to tune, while gradient boosting is more sensitive to settings such as learning rate and number of rounds.

### Early stopping

The model can use a separate validation set while training.

It first measures the base prediction, then checks validation MSE after each round. If validation performance improves, that round is remembered as the best one. If it does not improve for the configured patience period, training stops and the model keeps the stumps from the best round. This means it can keep the base prediction when every stump makes validation performance worse.

This helps avoid continuing to fit the training data after performance on unseen validation data has stopped improving.

### Limitation

This is a deliberately small teaching implementation. It supports regression with a single numeric feature and decision stumps using squared error. Production gradient boosting libraries support multiple features, richer trees, classification, additional loss functions, regularisation and more advanced optimisation.
