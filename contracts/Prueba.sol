pragma solidity ^0.5.1;

contract Prueba {
    mapping(address => bool) cuentas;

    function agregarCuenta() public {
        cuentas[msg.sender] = true;
    }

    function autorizado() public returns (bool) {
        return cuentas[msg.sender];
    }
}
