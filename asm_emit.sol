contract ASMEMIT {
    event Deposit(uint256 value, uint256 onyekivalue, address _address);

    function AssemblyEvent() public {
        bytes32 selector = bytes32(
            keccak256("Deposit(uint256,uint256,address)")
        );
        assembly {
            let p := mload(0x40)
            mstore(p, caller())
            log3(p, 0x20, selector, 255, 555)
        }
    }

    function PureAssemblyEvent() public {
        assembly {
            mstore(0x0, "Deposit(uint256,uint256,address)")
            let t2 := keccak256(0x0, add(0x0, 32)) // add(0x0, 32 ) 32 is len of   Deposit(uint256,uint256,address)
            let p := mload(0x40)
            mstore(p, caller())
            log3(p, 0x20, t2, 255, 555)
        }
    }
}
