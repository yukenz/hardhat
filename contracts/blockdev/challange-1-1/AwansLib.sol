// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

library AwansLib {

    function hashKecccak256(string memory stringValue)
    pure
    public
    returns (bytes32){
        return keccak256(abi.encodePacked(stringValue));
    }

    function equals(string memory arg0, string memory arg1)
    pure
    public
    returns (bool){

        if (hashKecccak256(arg0) == hashKecccak256(arg1)) {
            return true;
        } else {
            return false;
        }

    }

    /**
    @dev For Creating Selector
    */
    function getSelectorSignature(string memory selectorString)
    pure
    public
    returns (bytes4){
        return bytes4(hashKecccak256(selectorString));
    }

}

contract TestLib {

    using AwansLib for string;


    function compare(string memory arg0) public returns (bool) {

        address tesad = address(0);
        (bool success, bytes memory data) = tesad.call{value: 10}("");

        string memory abc = "ggwp";
        return abc.equals(arg0);
    }

}
