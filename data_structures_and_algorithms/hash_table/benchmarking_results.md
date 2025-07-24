# Hash Table Benchmark Results

### July 2025

Comparison of `Chaining` vs `OpenAddressing` implementations at various load factors.

| Type            | Load Factor | Insert Time (s) | Lookup Time (s) |
|-----------------|-------------|-----------------|------------------|
| Chaining        |     0.1     |    0.00087       |     0.00037       |
| OpenAddr        |     0.1     |    0.00040       |     0.00037       |
| Chaining        |     0.3     |    0.00111       |     0.00173       |
| OpenAddr        |     0.3     |    0.00196       |     0.00205       |
| Chaining        |     0.5     |    0.00232       |     0.00260       |
| OpenAddr        |     0.5     |    0.00336       |     0.00290       |
| Chaining        |     0.7     |    0.00354       |     0.00373       |
| OpenAddr        |     0.7     |    0.00451       |     0.00408       |
| Chaining        |     0.9     |    0.00941       |     0.00455       |
| OpenAddr        |     0.9     |    0.00958       |     0.00498       |
