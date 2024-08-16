> https://learnblockchain.cn/article/2119
### 新功能
- 移除safeMath
  - 特殊情况适用unchecked
- INVALID 不再消耗所有gas
- REVERT
  - 使用前缀4个字节区分
    - 常规revert   0x08c379a0
    - 系统内部错误 panic  0x4e487b71
      - 参数num用于标识具体原因类型   https://docs.soliditylang.org/en/latest/control-structures.html#panic-via-assert-and-error-via-require

### 旧功能改变
- 移除safeMath
- msg.sender.transfer 改为 payable(msg.sender).transfer
- 不允许从 int256 到 bytes32 进行显示的类型转换，得先手动转换为uint256
- 只有在符合给定类型的情况下，才允许类型转换，所以uint256(-1)将不再工作。 使用type(uint256).max代替
- myContract.functionCall{gas: 10000}{value: 1 ether }()改为：myContract.functionCall{gas: 10000, value: 1 ether }()
- x**y**z 改为(x**y)**z，因为默认的执行顺序改变了
- byte 类型改为 byte1
- 更多内容  https://docs.soliditylang.org/en/latest/080-breaking-changes.html
