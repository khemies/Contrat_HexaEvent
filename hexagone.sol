// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;


import "@openzeppelin/contracts/token/ERC20/ERC20.sol";



contract Hexagone is ERC20 {


    constructor() ERC20("EcoHexa", "EH") {


        _mint(msg.sender, 10000*10**18);


    }




}