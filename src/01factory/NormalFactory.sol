// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title 普通工厂合约
 * @notice 每次new新的合约
 */
contract Factory {
    Child[] public children;
    uint256 disabledCount;

    event ChildCreated(address childAddress, uint256 data);

    function createChild(uint256 data) external {
        Child child = new Child(data, children.length);
        children.push(child);
        emit ChildCreated(address(child), data);
    }

    function getChildren() external view returns (Child[] memory _children) {
        _children = new Child[](children.length - disabledCount);
        uint256 count;
        for (uint256 i = 0; i < children.length; i++) {
            if (children[i].isEnabled()) {
                _children[count] = children[i];
                count++;
            }
        }
    }

    function disable(Child child) external {
        children[child.index()].disable();
        disabledCount++;
    }
}

contract Child {
    uint256 data;
    bool public isEnabled;
    uint256 public index;

    constructor(uint256 _data, uint256 _index) {
        data = _data;
        isEnabled = true;
        index = _index;
    }

    function disable() external {
        isEnabled = false;
    }
}
