# Naive Bayes

A small Ruby implementation of a Naive Bayes classifier using a weather dataset to predict whether someone will go for a run.

## Concepts covered

- Prior probabilities
- Conditional probabilities (likelihoods)
- Laplace smoothing
- The zero-frequency problem
- Log-space scoring
- The log-sum-exp trick
- Training accuracy
- Leave-one-out cross validation (testing on rows not used during training)

## Running the exercise

```sh
ruby weather_naive_bayes_exercise.rb
```

## Running the specs

```sh
rspec weather_naive_bayes_spec.rb
```

## Key learnings

Naive Bayes is primarily a counting algorithm. The model learns probabilities from the training data and combines them to make predictions.

Without smoothing, unseen feature values can force probabilities to zero (the zero-frequency problem). Laplace smoothing avoids this by assigning a small probability to unseen events.

The exercise also demonstrates the difference between evaluating on training data and unseen data:

- Training accuracy: 92.9%
- Leave-one-out accuracy: 50.0%

This highlights an important machine learning lesson: high training accuracy does not necessarily mean a model generalises well to unseen data.