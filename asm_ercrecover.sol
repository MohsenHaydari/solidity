// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.0 <0.9.0;
import "@openzeppelin/contracts/utils/Strings.sol";
//remix import
//import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Strings.sol";

contract ASMERCRECOVER{

    function recoverSignedMessage(address signer, bytes memory signature)
        internal
        view
        returns (bool equal)
    {
        //create hash 
        bytes memory _hash = abi.encodePacked(
            "buyer"
        );

        bytes32 hash = keccak256(
            abi.encodePacked(
                "\x19Ethereum Signed Message:\n",
                Strings.toString(_hash.length),// personal sign
                _hash
            )
        );
        assembly {
            switch mload(signature) // signator length most be 65
            case 65 {
                let pointer := mload(0x40) // free pointer
                let s := mload(add(signature, 0x40)) // s on position 64 
                let v := byte(0, mload(add(signature, 0x60))) // v on position 96
                mstore(pointer, hash) // add 32 bytes hash to pointer at position 0
                mstore(add(pointer, 0x20), v) // add 32 bytes v on position 32
                mstore(add(pointer, 0x40), mload(add(signature, 0x20))) // add 32 bytes v on position 64
                mstore(add(pointer, 0x60), s) // add 32 bytes s on pisition 96
                if gt(s,0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0){ // s most be lower than 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0
                    stop()
                }
                switch or(eq(v,27),eq(v,28)) // v most be 27 or 28
                case 0 {stop()}
                if iszero(staticcall(not(0), 0x01, pointer, 0x80, pointer, 0x20)) { // ercrver address is 0x1, send 128 bytes data in pointer // out pointer with 32 bytes
                    stop()
                }
                let size := returndatasize()
                returndatacopy(pointer, 0, size)
                switch eq(mload(pointer),signer) 
                case 1 {
                    equal := true
                }
                default {stop()}
            }
            default {
                stop()
            }
            
        }
    }


}
