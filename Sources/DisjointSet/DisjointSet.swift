// Copyright © 2019 Darren Mo
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of
// this software and associated documentation files (the “Software”), to deal in
// the Software without restriction, including without limitation the rights to
// use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
// the Software, and to permit persons to whom the Software is furnished to do so,
// subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
// FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
// COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
// IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
// CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

public struct DisjointSet<Element: Hashable> {
   // MARK: - Public API

   public init() {
   }

   public var isEmpty: Bool {
      return implementation.isEmpty
   }

   public var count: Int {
      return implementation.count
   }

   // O(1) (simplified; see Wikipedia for more details)
   public mutating func insert<Elements: Sequence>(
      _ newMember: Element,
      unioningWith existingMembers: Elements
   ) where Elements.Element == Element {
      if !isKnownUniquelyReferenced(&implementation) {
         implementation = Implementation(implementation)
      }

      implementation.insert(newMember, unioningWith: existingMembers)
   }

   // O(1)
   public func contains(_ member: Element) -> Bool {
      return implementation.contains(member)
   }

   // O(1)
   public func count<Elements: Sequence>(
      ofSubsetsContaining members: Elements
   ) -> Int where Elements.Element == Element {
      return implementation.count(ofSubsetsContaining: members)
   }

   // O(n)
   public func allSubsets() -> [Set<Element>] {
      return implementation.allSubsets()
   }

   // O(n)
   public func subset(containing member: Element) -> Set<Element>? {
      return implementation.subset(containing: member)
   }

   // MARK: - Private Properties

   private var implementation = Implementation()
}

// MARK: -

fileprivate extension DisjointSet {
   class Implementation {
      // MARK: - Public API

      init() {
      }

      init(_ source: Implementation) {
         var originalNodeToCopyMap = [UnsafeRawPointer: SubsetNode]()
         for originalNode in source.memberToSubsetNodeMap.values {
            let copy = SubsetNode(element: originalNode.element)
            copy.count = originalNode.count

            originalNodeToCopyMap[originalNode.reference] = copy
         }

         var memberToSubsetNodeMap = source.memberToSubsetNodeMap
         for (member, originalNode) in memberToSubsetNodeMap {
            let copy = originalNodeToCopyMap[originalNode.reference]!

            var parentCopy: SubsetNode?
            if let originalParent = originalNode.parent {
               parentCopy = originalNodeToCopyMap[originalParent.reference]!
            }
            copy.parent = parentCopy

            memberToSubsetNodeMap[member] = copy
         }

         self.memberToSubsetNodeMap = memberToSubsetNodeMap
      }

      var isEmpty: Bool {
         return memberToSubsetNodeMap.isEmpty
      }

      var count: Int {
         return memberToSubsetNodeMap.count
      }

      func insert<Elements: Sequence>(
         _ newMember: Element,
         unioningWith existingMembers: Elements
      ) where Elements.Element == Element {
         var rootNodes = [SubsetNode]()

         if let newMemberNode = memberToSubsetNodeMap[newMember] {
            let rootNode = findAndCompressRoot(of: newMemberNode)
            rootNodes.append(rootNode)
         } else {
            let rootNode = SubsetNode(element: newMember)
            memberToSubsetNodeMap[newMember] = rootNode
            rootNodes.append(rootNode)
         }

         for existingMember in existingMembers {
            guard let existingMemberNode = memberToSubsetNodeMap[existingMember] else {
               continue
            }

            let rootNode = findAndCompressRoot(of: existingMemberNode)
            rootNodes.append(rootNode)
         }

         unionSubsets(rootNodes)
      }

      func contains(_ member: Element) -> Bool {
         return memberToSubsetNodeMap[member] != nil
      }

      func count<Elements: Sequence>(
         ofSubsetsContaining members: Elements
      ) -> Int where Elements.Element == Element {
         var count = 0

         var lastRootNode: SubsetNode?
         for member in members {
            if let memberNode = memberToSubsetNodeMap[member] {
               let rootNode = findRoot(of: memberNode)

               if lastRootNode !== rootNode {
                  count += 1
               }

               lastRootNode = rootNode
            }
         }

         return count
      }

      func allSubsets() -> [Set<Element>] {
         var rootNodeToSubsetMap = [UnsafeRawPointer: Set<Element>]()

         for (member, node) in memberToSubsetNodeMap {
            let rootNode = findRoot(of: node)
            rootNodeToSubsetMap[rootNode.reference, default: []].insert(member)
         }

         return Array(rootNodeToSubsetMap.values)
      }

      func subset(containing member: Element) -> Set<Element>? {
         guard let targetMemberNode = memberToSubsetNodeMap[member] else {
            return nil
         }
         let targetRootNode = findRoot(of: targetMemberNode)

         var subset = Set<Element>()
         for (member, node) in memberToSubsetNodeMap {
            let rootNode = findRoot(of: node)
            if rootNode === targetRootNode {
               subset.insert(member)
            }
         }

         return subset
      }

      // MARK: - Private Properties

      private class SubsetNode {
         let element: Element

         var count: Int
         var parent: SubsetNode?

         init(element: Element) {
            self.element = element
            self.count = 1
         }

         var reference: UnsafeRawPointer {
            return UnsafeRawPointer(Unmanaged.passUnretained(self).toOpaque())
         }
      }

      private var memberToSubsetNodeMap = [Element: SubsetNode]()

      // MARK: - Union-Find Algorithm

      private func findRoot(of node: SubsetNode) -> SubsetNode {
         if let parentNode = node.parent {
            return findRoot(of: parentNode)
         } else {
            return node
         }
      }

      private func findAndCompressRoot(of node: SubsetNode) -> SubsetNode {
         if let parentNode = node.parent {
            let rootNode = findAndCompressRoot(of: parentNode)

            node.count = 1
            node.parent = rootNode

            return rootNode
         } else {
            return node
         }
      }

      private func unionSubsets(_ rootNodes: [SubsetNode]) {
         guard rootNodes.count > 1 else {
            return
         }

         var mergedRootNode = rootNodes[0]
         for var rootNodeToBeMerged in rootNodes.dropFirst() {
            if rootNodeToBeMerged === mergedRootNode {
               continue
            }

            if mergedRootNode.count < rootNodeToBeMerged.count {
               (mergedRootNode, rootNodeToBeMerged) = (rootNodeToBeMerged, mergedRootNode)
            }

            rootNodeToBeMerged.parent = mergedRootNode
            mergedRootNode.count += rootNodeToBeMerged.count
         }
      }
   }
}
