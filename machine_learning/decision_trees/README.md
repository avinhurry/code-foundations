# Decision Trees

A small Ruby implementation of decision trees from scratch.

A decision tree predicts by asking a sequence of questions about the input features. Each answer follows a branch until the tree reaches a leaf containing the final prediction.

## Concepts covered

- Decision trees
- Nodes, branches and leaves
- Gini impurity
- Gain
- Recursive tree building
- Categorical splits
- Maximum depth
- Overfitting
- Numeric threshold splits

## Running the experiments

```sh
ruby machine_learning/decision_trees/decision_tree_experiments.rb
```

## Running the tests

```sh
rspec machine_learning/decision_trees/decision_tree_spec.rb
```

## Decision tree experiments

The experiments demonstrate how a decision tree chooses useful splits, builds and follows branches, limits its depth, overfits noisy data, and handles numeric features with threshold questions.

### Gini impurity and gain

The weather dataset starts with an even split between `yes` and `no`, giving a root Gini impurity of 0.5.

The two possible first features produce:

- outlook gain: 0.25
- wind gain: 0.125

The tree chooses `outlook` first because it has the larger gain, meaning it reduces impurity more than `wind`.

### Building and reading the tree

The categorical tree learns the following pattern:

- overcast -> yes
- sunny -> no
- rainy + weak wind -> yes
- rainy + strong wind -> no

Prediction then consists of following the learned branches until a leaf is reached.

### Limiting tree depth

With `max_depth = 1`, the tree stops after splitting on `outlook` and can't ask about `wind` inside the rainy branch.

The rainy branch therefore falls back to its majority label. This makes the tree simpler, but it also loses useful detail and can make worse predictions.

### Overfitting

A unique `day_id` feature was added deliberately as a useless input. An unrestricted tree can use this feature to separate individual training rows and achieve perfect training accuracy.

This demonstrates overfitting: the tree can fit the training examples extremely well without learning a pattern that is useful for new data.

### Numeric threshold splits

For a numeric `studied` feature, the tree tries thresholds between the observed values and measures the gain from each split.

The best threshold was 4.5:

- studied ≤ 4.5 -> fail
- studied > 4.5 -> pass

This threshold had a gain of 0.5 and perfectly separated the two labels in the toy dataset.

### Limitation

Decision trees are highly interpretable and do not require feature scaling, but a single unrestricted tree can overfit easily and can be unstable when the training data changes. Depth limits and other stopping rules help control this.