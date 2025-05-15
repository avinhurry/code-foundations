# How to insert nodes

The formula for calculating the maximum height of a Red-Black tree is `2.log2(n+1)`.

So for example, if a red black tree had a 7 nodes. it would be: 

```math
2.log2(7+1) = 6
```

## Inserting 30

Root is always black

```ruby
    30(B)
```


## Inserting 20

20 is smaller than 30 so we insert it to the left

```ruby
    30(B)
    / 
  20(R)
```

## Inserting 45

45 is larger than 30 so it's inserted to the right.

```ruby
     30(B)
    /    \
  20(R)  45(R)
```


## Inserting 25

Inserting 25 to the right of 20 because its bigger than 20 but smaller than 45.

```ruby
     30(B)
    /    \
  20(R)  45(R)
     \
      25(R)
```

VIOLATION two reds in a row. Recolour parent (20) and uncle (45) to black. Recolour grandparent to red.

```ruby
     30(R)
    /    \
  20(B)  45(B)
     \
      25(R)
```

VIOLATION root must be black. Recolour root to black.


```ruby
     30(B)
    /    \
  20(B)  45(B)
     \
      25(R)
```

## Inserting 1

Inserting 1 to the left of 20 because it is smaller.

Parent is black. Good to go.


```ruby
     30(B)
    /    \
  20(B)  45(B)
  /   \
1(R)  25(R)
```


## Inserting 4

Inserting 4 to the right of 1 because it is bigger.


```ruby
     30(B)
    /    \
  20(B)  45(B)
  /   \
1(R)  25(R)
 \
 4(R)
```

VIOLATION two reds in a row. Uncle (25) is red. Recolour parent (1) and uncle (25) to black. Recolour grandparent (20)
to red. No rotation is necessary because the uncle (25) was red.

```ruby
     30(B)
    /    \
  20(R)  45(B)
  /   \
1(B)  25(B)
 \
 4(R)
```


## Inserting 8

Inserting 8 to the right of 4 because it's bigger. Insert it as red initially.

```ruby
     30(B)
    /    \
  20(R)  45(B)
  /   \
1(B)  25(B)
 \
 4(R)
   \
   8(R)
```

VIOLATION, two reds in a row. No uncle (i.e., uncle is black), so we do a rotation and recolouring.

4(R) is the right child of 1(B) and 8(R) is the right child of 4(R). RR rotation. Left rotation
On 1B, 4 becomes the new subtree root. 

Recolour, 4 becomes black and 1 becomes red.

```ruby
     30(B)
    /    \
  20(R)  45(B)
  /   \
4(B)  25(B)
/   \
1(R) 8(R)
```

## Inserting 10

Inserting to the right of 8 because it is bigger. It will be inserted as red initially.

```ruby
     30(B)
    /    \
  20(R)  45(B)
  /   \
4(B)  25(B)
/   \
1(R) 8(R)
      \
      10(R)
```

VIOLATION, two reds in a row, uncle 1(R) is red. Since both the parent and uncle are red, recolour the parent
and uncle to black, and the grandparent to red.

```ruby
     30(B)
    /    \
  20(R)  45(B)
  /   \
4(R)  25(B)
/   \
1(B) 8(B)
      \
      10(R)
```

VIOLATION, two reds in a row (4 and 20). Uncle (45B) is black and is the right sibling of 20
so this is a LL case. We rotate right at 20 and recolour.

```ruby
     30(B)
    /   \
  4(B)   45(B)
  /   \     
 1(B) 20(R) 
      /   \
    8(B)  25(B)
     \
    10(R)
```

