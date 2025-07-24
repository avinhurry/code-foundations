# Differences between chaining and open addressing

## Changes from Chaining to Open Addressing
---

### 1. How buckets are structured

**Chaining:**
Each slot (bucket) holds an **array**. If multiple keys hash to the same index (a collision), their key-value pairs are stored in that array.

**Open Addressing:**
Each bucket holds just **one key-value pair** or is empty (`nil`). Collisions are handled by **probing** the next slot until a free one is found.

---

### 2. How values are inserted (`set`)

**Chaining:**
- Hash the key to get the bucket index.
- Look inside the array (bucket) for the key.
- If found, update the value.
- If not, append `[key, value]` to the array.

**Open Addressing:**
- Hash the key to get the starting index.
- Check that slot:
  - If it's `nil` or a **tombstone**, insert the key-value pair.
  - If it already contains the key, update the value.
  - Otherwise, move to the next slot (with wraparound).
- Keep probing until inserted or table is full.

---

### 3. How values are retrieved (`get`)

**Chaining:**
- Hash the key to find the bucket.
- Search the array in that bucket.
- Return the value if found, or `nil`.

**Open Addressing:**
- Hash the key to get the starting index.
- Probe forward:
  - If the slot is `nil`, return `nil`.
  - If it's a tombstone, continue probing.
  - If the key matches, return the value.
- Keep probing until the key is found or a `nil` is hit.

---

### 4. How deletion works (`delete`)

**Chaining:**
- Find the key in the array (bucket).
- Remove the `[key, value]` pair.

**Open Addressing:**
- Probe for the key like in `get`.
- Once found, **replace it with a tombstone marker** (not `nil`).
- This ensures future lookups and inserts continue to work properly.

---

### 5. Resizing

**Chaining:**
- Optional. Performance may degrade as buckets get longer, but the table still works.

**Open Addressing:**
- **Required** when load factor is high or too many tombstones accumulate.
- Resize by creating a larger table and **rehashing** all live entries.

---

### Summary Table

| Change Area   | Chaining                         | Open Addressing                    |
|---------------|----------------------------------|------------------------------------|
| Buckets       | Arrays of key-value pairs        | Flat array of single entries       |
| Collisions    | Store multiple items per bucket  | Probe for an empty slot            |
| Insert        | Insert into list                 | Linearly probe to find a free slot |
| Lookup        | Scan list at hashed index        | Probe until match or empty         |
| Deletion      | Remove from list                 | Mark slot with tombstone           |
| Resizing      | Optional but helpful             | Necessary to maintain performance  |


