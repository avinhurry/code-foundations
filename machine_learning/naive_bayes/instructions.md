# Weather Naive Bayes classifier

## Goal

Build a small, reusable `WeatherNaiveBayes` classifier in Ruby.

You will train it on a tiny weather dataset and use it to predict whether someone goes for a run. The exercise should also include an RSpec suite that proves the classifier works.

This is the same algorithm as a spam classifier, but with a fresh problem using categorical weather features instead of word counts.

## Scenario

Each row represents one day. The model learns from four weather features and a final label showing whether a run happened.

| outlook | temp | humidity | wind | run |
| --- | --- | --- | --- | --- |
| sunny | hot | high | weak | no |
| sunny | hot | high | strong | no |
| overcast | hot | high | weak | yes |
| rainy | mild | high | weak | yes |
| rainy | cool | normal | weak | yes |
| rainy | cool | normal | strong | no |
| overcast | cool | normal | strong | yes |
| sunny | mild | high | weak | no |
| sunny | cool | normal | weak | yes |
| rainy | mild | normal | weak | yes |
| sunny | mild | normal | strong | yes |
| overcast | mild | high | strong | yes |
| overcast | hot | normal | weak | yes |
| rainy | mild | high | strong | no |

There are 9 `"yes"` days and 5 `"no"` days.

The two test days are:

```ruby
TEST_1 = { outlook: "sunny", temp: "cool", humidity: "high", wind: "strong" }
TEST_2 = { outlook: "overcast", temp: "mild", humidity: "normal", wind: "weak" }
```

## Class interface

The classifier should be used like this:

```ruby
model = WeatherNaiveBayes.new(features: %i[outlook temp humidity wind], label: :run, alpha: 1.0)
model.fit(DATA)

model.predict(TEST_1)
# => "no"

model.predict_probability_log(TEST_1)
# => { "no" => 0.7201, "yes" => 0.2799 }
```

## Methods to implement

| Method | Returns | Meaning |
| --- | --- | --- |
| `prior(klass)` | `Float` | `P(run == klass)`: the fraction of all rows in that class. |
| `likelihood(feature, value, klass)` | `Float` | `P(feature == value \| run == klass)`. |
| `score(sample, klass)` | `Float` | `prior(klass)` multiplied by each feature likelihood. |
| `predict_probability(sample)` | `Hash` | Linear-space class scores normalised into probabilities. |
| `log_score(sample, klass)` | `Float` | Same as `score`, but summing logs to avoid underflow. |
| `predict_probability_log(sample)` | `Hash` | Probabilities calculated using the log-sum-exp trick. |
| `predict(sample)` | `String` | The winning class label, using log-space internally. |

The `alpha:` constructor argument controls smoothing:

- `alpha: 0` means no smoothing, using raw counts.
- `alpha: 1` means add-one smoothing.

## Tier 1: counting

Naive Bayes is mostly counting.

Implement:

- `prior`
- `likelihood`

The smoothed likelihood formula is:

```text
             count(feature == value within class) + alpha
likelihood = ------------------------------------------------
             rows in class + alpha * distinct feature values
```

The number of distinct values differs by feature:

| Feature | Distinct values |
| --- | --- |
| `outlook` | 3 |
| `temp` | 3 |
| `humidity` | 2 |
| `wind` | 2 |

Expected values:

| Call | Alpha | Expected |
| --- | --- | --- |
| `prior("yes")` | `1` | `0.6429` |
| `prior("no")` | `1` | `0.3571` |
| `likelihood(:outlook, "sunny", "no")` | `0` | `0.6` |
| `likelihood(:temp, "cool", "yes")` | `0` | `0.3333` |
| `likelihood(:outlook, "overcast", "no")` | `1` | `0.125` |

## Tier 2: prediction and the zero-frequency bug

Implement:

- `score`
- `predict_probability`

`score` should multiply the prior by each feature likelihood for the given class.

`predict_probability` should calculate a score for each class and normalise the results so they sum to `1.0`.

With `alpha: 0`, predict both test days:

| Input | `P(yes)` | Prediction | Note |
| --- | --- | --- | --- |
| `TEST_1` | `0.2046` | `"no"` | Reasonable result. |
| `TEST_2` | `1.0` | `"yes"` | Bug: `"overcast"` never appears on a `"no"` day. |

That `100%` prediction is the zero-frequency problem. One unseen value completely eliminates a class.

Tier 3 fixes that.

## Tier 3: robustness

Implement:

- `log_score`
- `predict_probability_log`
- `predict`

`log_score` should start with `Math.log(prior(...))` and add `Math.log(likelihood(...))` for each feature.

`predict_probability_log` should use the log-sum-exp trick to turn log scores back into normalised probabilities.

With `alpha: 1`, smoothing should fix the zero-frequency bug:

| Input | `P(yes)` | Prediction |
| --- | --- | --- |
| `TEST_1` | `0.2799` | `"no"` |
| `TEST_2` | `0.9566` | `"yes"` |

Also check the raw log scores for `TEST_1` with `alpha: 1`:

| Call | Expected |
| --- | --- |
| `log_score(TEST_1, "yes")` | `-4.9499` |
| `log_score(TEST_1, "no")` | `-4.0051` |

`TEST_1` should predict `"no"`.

## Stretch: evaluation

Add two helper methods or standalone functions:

| Helper | Expected |
| --- | --- |
| `training_accuracy(DATA, alpha: 1.0)` | `0.929`, or `13/14` |
| `leave_one_out_accuracy(DATA, alpha: 1.0)` | `0.5`, or `7/14` |

Training accuracy tests the model on data it has already seen.

Leave-one-out accuracy trains a fresh model for each row, using the other 13 rows as training data and the held-out row as the test case.

The gap between the two results is the point of the exercise: training accuracy can look strong because the model has already seen the examples, while leave-one-out is a much harsher test on such a tiny dataset.

## Tier 4: test it with RSpec

Write an RSpec suite that locks in the expected behaviour.

Run it with:

```sh
rspec weather_naive_bayes_spec.rb
```

The spec should cover at least:

- `prior("yes")` and `prior("no")`.
- At least one raw likelihood with `alpha: 0`.
- At least one smoothed likelihood with `alpha: 1`.
- The zero-frequency bug: with `alpha: 0`, `predict_probability(TEST_2)` gives `P(yes) == 1.0` and `P(no) == 0.0`.
- The smoothing fix: with `alpha: 1`, `predict_probability_log(TEST_2)` gives `P(yes) ≈ 0.9566`.
- `predict(TEST_1) == "no"` and `predict(TEST_2) == "yes"` with `alpha: 1`.
- The probabilities returned by `predict_probability_log` add up to `1.0`.
- The stretch accuracy helpers, if implemented.

Use `be_within(...).of(...)` for floating point comparisons rather than `eq`.

## What this teaches

This exercise is about building the algorithm from first principles:

- Counting is the whole engine.
- A classifier can be built from priors, likelihoods, and normalised class scores.
- Smoothing prevents a single unseen value from removing a class entirely.
- Log-space prevents tiny probabilities from underflowing on larger inputs.
- Tests turn one successful run into behaviour that stays correct as the code changes.