// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/*
Solidity supports multiple inheritance. Contracts can inherit other contract by using the is keyword.

Function that is going to be overridden by a child contract must be declared as virtual.

Function that is going to override a parent function must use the keyword override.

Order of inheritance is important.

You have to list the parent contracts in the order from “most base-like” to “most derived”.
*/

/* Graph of inheritance
    A
   / \
  B   C
 / \ /
F  D,E

*/

contract A {
    function foo() public pure virtual returns (string memory) {
        return "A";
    }
}

// Contracts inherit other contracts by using the keyword 'is'.
contract B is A {
    // Override A.foo()
    function foo() public pure virtual override returns (string memory) {
        return "B";
    }
}

contract C is A {
    // Override A.foo()
    function foo() public pure virtual override returns (string memory) {
        return "C";
    }
}

// Contracts can inherit from multiple parent contracts.
// When a function is called that is defined multiple times in
// different contracts, parent contracts are searched from
// right to left, and in depth-first manner.

contract D is B, C {
    // D.foo() returns "C"
    // since C is the right most parent contract with function foo()
    function foo() public pure override(B, C) returns (string memory) {
        return super.foo();
    }
}

contract E is C, B {
    // E.foo() returns "B"
    // since B is the right most parent contract with function foo()
    function foo() public pure override(C, B) returns (string memory) {
        return super.foo();
    }
}

// Inheritance must be ordered from “most base-like” to “most derived”.
// Swapping the order of A and B will throw a compilation error.
contract F is A, B {
    function foo() public pure override(A, B) returns (string memory) {
        return super.foo();
    }
}

/*
1.起初以为多继承时 super 调用不是直接去找自身的父合约，而是沿着继承清单的顺序向前找，除非当前函数所在合约和清单的前一个合约没有任何关系。
 - 如 D 继承 B、C，而 B、C 继承 A，那么 super 的查找循序就是 D -> C -> B -> A；
 - 如 D 继承 B、C，而 B、C 分别继承 A、A1，那么 super 的查找顺序就是 D -> C -> A1；
2.但是发现并非完全按照清单的顺序不管自身父类合约，更像是先去找自身父类合约，当发现清单的前一个和父类有关系，会先去找清单的前一个，再去找父类合约。
 - 如在第二种情况下，A1 继续继承 A，那么 super 的查找顺序时 D -> C -> A1 -> B -> A；
3.还有一个非常迷惑的情况：
 - D 继承 B、X、C，而 B、C 继承 A，只有 X 和谁都没有关系也没有父合约，那么 super 的查找循序就是 D -> C -> X，
 - 在上面的情况下，如 X 继承 X1 并且加上 super，那么 super 的查找顺序就是 D -> C -> X -> X1；
最后猜测规律如下：
 - super 会优先指向当前合约的父合约，如发现清单的前面【任意位置】有合约也继承该父合约，会转而指向清单中的【前一个合约】。
*/
