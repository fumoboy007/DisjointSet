# DisjointSet

A Swift implementation of a [disjoint-set data structure](https://en.wikipedia.org/wiki/Disjoint-set_data_structure).

## Overview of Disjoint-Set

A disjoint-set is like a regular set but with an extra superpower: it can partition members into disjoint subsets without increasing the upper bound time complexity of standard operations.

## Algorithmic Time Complexity

| Operation | Time Complexity |
| --- | --- |
| `isEmpty` | `O(1)` |
| `count` | `O(1)` |
| `insert(_:unioningWith:)` | `O(1)` |
| `contains(_:)` | `O(1)` |
| `allSubsets()` | `O(n)` |
| `subset(containing:)` | `O(n)` |

To confirm that the real-world results match the theory, use `DisjointSet.attabench`.

## API Usage

See `Tests/DisjointSetTests/LeetCodeTests.swift`.

## Compatibility

Tested using Swift 4. MIT license.