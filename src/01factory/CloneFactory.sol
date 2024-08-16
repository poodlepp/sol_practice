// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * clone 工厂
 * 一个合约作为模板，其他合约都是代理的角色，这样同样的功能，但是不需要占用那么多的空间，节省了gas
 * evm有特殊的优化方式   这个proxy遵循EIP1167 使用简单的字节码就可以使用代理合约
 * 363d3d373d3d3d363d73   bebebebebebebebebebebebebebebebebeaf    5af43d82803e903d91602b57fd5bf3
 * 10-29字节替换为目标合约地址即可
 *
 * 需要注意的是  不能通过constructor来初始化了， 需要init函数来初始化
 */
contract CloneFactory {
    function createClone(address target) internal returns (address result) {
        bytes20 targetBytes = bytes20(target);
        assembly {
            let clone := mload(0x40)
            mstore(clone, 0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000000000000000000000)
            mstore(add(clone, 0x14), targetBytes)
            mstore(add(clone, 0x28), 0x5af43d82803e903d91602b57fd5bf30000000000000000000000000000000000)
            result := create(0, clone, 0x37)
        }
    }

    function isClone(address target, address query) internal view returns (bool result) {
        bytes20 targetBytes = bytes20(target);
        assembly {
            let clone := mload(0x40)
            mstore(clone, 0x363d3d373d3d3d363d7300000000000000000000000000000000000000000000)
            mstore(add(clone, 0xa), targetBytes)
            mstore(add(clone, 0x1e), 0x5af43d82803e903d91602b57fd5bf30000000000000000000000000000000000)

            let other := add(clone, 0x40)
            extcodecopy(query, other, 0, 0x2d)
            result := and(eq(mload(clone), mload(other)), eq(mload(add(clone, 0xd)), mload(add(other, 0xd))))
        }
    }
}

contract Factory is CloneFactory {
    Child[] public children;
    address masterContract;

    constructor(address _masterContract) {
        masterContract = _masterContract;
    }

    function createChild(uint256 data) external {
        Child child = Child(createClone(masterContract));
        child.init(data);
        children.push(child);
    }

    function getChildren() external view returns (Child[] memory) {
        return children;
    }
}

contract Child {
    uint256 public data;

    // 用 init 函数替换构造函数
    // 因为创建在createClone函数内完成
    function init(uint256 _data) external {
        data = _data;
    }
}
