// SPDX-License-Identifier: MIT

pragma solidity >0.7.0 <0.9.0;

contract DonacionesEj {
    //para ver balance de cuenta / dir-monto var:balance
    mapping (address => uint256 _balance) public balance;
    uint256 public vecesFallback;
    uint256 public vecesReceive;
    bytes public data;

    //para cambiar balance de cuenta
    function setBalance(uint256 _balance) public {
        balance[msg.sender] = _balance;
    }

    // hacerlo payable (se puede castear) incorpora metodos transfer y send 

    fallback() external payable { 
        vecesFallback++;
        data = msg.data;
    }

    receive() external payable { 
        vecesReceive++;
    }

}
