import Benchmarking
import DisjointSet

let benchmark = Benchmark<[Int]>(title: "DisjointSet")
benchmark.descriptiveTitle = "Time spent on all elements"
benchmark.descriptiveAmortizedTitle = "Average time spent on a single element"

benchmark.addTask(title: "DisjointSet.isEmpty") { inserts in
    var disjointSet = DisjointSet<Int>()
    for value in inserts {
        disjointSet.insert(value,
                           unioningWith: [value - 1, value + 1])
    }

    return { timer in
        for _ in 0..<inserts.count {
            _ = disjointSet.isEmpty
        }
    }
}

benchmark.addTask(title: "DisjointSet.count") { inserts in
    var disjointSet = DisjointSet<Int>()
    for value in inserts {
        disjointSet.insert(value,
                           unioningWith: [value - 1, value + 1])
    }

    return { timer in
        for _ in 0..<inserts.count {
            _ = disjointSet.count
        }
    }
}

benchmark.addTask(title: "DisjointSet.insert(_:unioningWith:)") { inserts in
    var disjointSet = DisjointSet<Int>()

    return { timer in
        for value in inserts {
            disjointSet.insert(value,
                               unioningWith: [value - 1, value + 1])
        }
    }
}

benchmark.addTask(title: "DisjointSet.contains(_:)") { inserts in
    var disjointSet = DisjointSet<Int>()
    for value in inserts {
        disjointSet.insert(value,
                           unioningWith: [value - 1, value + 1])
    }

    let lookups = Array(0..<inserts.count)

    return { timer in
        for value in lookups {
            _ = disjointSet.contains(value)
        }
    }
}

benchmark.addTask(title: "DisjointSet.allSubsets()") { inserts in
    var disjointSet = DisjointSet<Int>()
    for value in inserts {
        disjointSet.insert(value,
                           unioningWith: [value - 1, value + 1])
    }

    return { timer in
        for _ in 0..<inserts.count {
            _ = disjointSet.allSubsets()
        }
    }
}

benchmark.addTask(title: "DisjointSet.subset(containing:)") { inserts in
    var disjointSet = DisjointSet<Int>()
    for value in inserts {
        disjointSet.insert(value,
                           unioningWith: [value - 1, value + 1])
    }

    let lookups = Array(0..<inserts.count)

    return { timer in
        for value in lookups {
            _ = disjointSet.subset(containing: value)
        }
    }
}

benchmark.start()

