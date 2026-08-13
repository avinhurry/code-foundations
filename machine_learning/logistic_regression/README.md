

# Logistic Regression

A small Ruby implementation of logistic regression from scratch.

Logistic regression is a linear model for binary classification: it builds a weighted score from the inputs, passes that score through a sigmoid to get a probability, then uses a threshold to choose between two classes.

## Concepts covered

- Logistic regression
- Binary classification
- Sigmoid
- Log loss
- Gradient descent
- Feature scaling (standardization)
- Classification metrics
- Confusion matrix
- Precision, recall and F1
- AUC
- Threshold tuning
- L2 regularization

## Running the churn model

```sh
ruby machine_learning/logistic_regression/churn.rb
```

## Running the tests

```sh
rspec machine_learning/logistic_regression/logistic_regression_spec.rb
rspec machine_learning/classification_metrics_spec.rb
```

## Churn model

This example uses logistic regression to predict customer churn from tenure, monthly charge and number of support tickets. The input features are standardised before training.

The model beat the always stay baseline, achieving approximately 83.3% accuracy compared with 66.7%.

### Classification performance

- Accuracy: 83.3%
- Precision: 0.833
- Recall: 0.625
- F1: 0.714
- AUC: 0.867

### Threshold tuning

A threshold of 0.4 was selected because it achieved recall of 0.875, catching 7 of 8 churners, while keeping precision at 0.875.

### Regularization

As lambda increased, the overall weight size decreased. AUC stayed at 0.867 up to lambda 0.1, then dropped slightly to 0.859 at lambda 1.

This showed that regularization could shrink the weights without reducing AUC at moderate strengths, while stronger regularization eventually made the model slightly worse at giving actual churners higher churn probabilities than stayers.

### Features

The model uses:

- tenure
- monthly charge
- support tickets

The learned weights suggested that:

- higher tenure reduced churn likelihood
- higher monthly charges increased churn likelihood
- more support tickets increased churn likelihood

### Limitation

The model was trained and evaluated on the same small dataset, so the reported performance does not show how well it would generalise to unseen customers.