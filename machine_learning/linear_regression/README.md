# Linear Regression

A small Ruby implementation of linear regression from scratch using only Ruby's standard `Matrix` library.

## Concepts covered

- Linear regression
- Features, weights and bias
- Gradient descent
- Normal equation
- Feature scaling (standardization)
- Model evaluation (RMSE, MAE and R²)

## Running the example

```sh
ruby machine_learning/linear_regression/linear_regression.rb
```

## Running the experiments

```sh
ruby machine_learning/linear_regression/linear_regression_experiments.rb
```

The experiments demonstrate:

- training a linear regression model using the normal equation
- training a linear regression model using gradient descent
- making predictions using a trained model
- comparing the coefficients learned by each training algorithm
- that feature scaling changes the learned parameters but not the predictions or evaluation metrics
- how feature scaling allows gradient descent to use larger learning rates and converge in fewer iterations
- how to evaluate whether an additional feature improves the model by comparing R²
- why evaluating a model on unseen data gives a more realistic estimate of its performance
- how adjusted R² fairly compares models with different numbers of features