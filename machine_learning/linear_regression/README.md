# Linear Regression

A small Ruby implementation of linear regression from scratch using only Ruby's standard `Matrix` library.

## Concepts covered

- Linear regression
- Features, weights and bias
- Gradient descent
- Normal equation
- Feature scaling (standardization)
- Model evaluation (RMSE, MAE and R²)
- Train/test split
- Ridge regularisation (L2 regularisation)
- Residual analysis

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

## Running the house price model

```sh
ruby machine_learning/linear_regression/house_prices.rb
```

## House price model

This example uses linear regression to predict house prices from house size, number of bedrooms and age. The input features are standardised before training.

Several ridge regularisation strengths were evaluated using the same train/test split. The unregularised model (`λ = 0`) achieved the lowest test RMSE, giving the best performance on this dataset.

### Test performance

- Test RMSE: approximately 1.98
- Selected λ: 0

The train and test R² scores were very similar, suggesting the model generalised well to unseen houses.

Residual analysis showed that the prediction errors were relatively small, appeared on both sides of zero and had no obvious trend as predicted price increased. This suggests the model was making mostly random errors rather than repeating the same type of mistake.

### Features

The model uses the following input features:

- house size
- number of bedrooms
- age

Earlier experiments showed that adding additional features improved prediction accuracy compared with using house size alone.

### Limitation

Linear regression assumes that the relationship between the input features and house price is approximately linear. If the true relationship is more complex, a linear model may not capture it accurately and can underfit the data.