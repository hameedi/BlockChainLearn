// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

contract Greeter {
    string public yourName;

    constructor() {
        yourName = "World";
    }

    function set (string memory _yourName) public {
        yourName = _yourName;
    }

    function greet() public view returns (string memory){
         // Using abi.encodePacked for string concatenation
        return string(abi.encodePacked("Hello ", yourName, "!"));
    }

}