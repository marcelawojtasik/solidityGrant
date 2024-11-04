// SPDX-License-Identifier: MIT

//Contract 0x32Eb3F2Ee94255239A49ADe10d581e2515F1d80f

pragma solidity >0.7.0 <0.9.0;

/*
Estructura de Datos:
 ○ Utilizar un struct llamado Donacion 
 ○ Crear un array de Donacion para almacenar todas las donaciones
 realizadas al contrato.
 ○ Utilizar un mapping para rastrear el total donado por cada dirección.
*/
/*
Eventos:
 ○ Emitir un evento DonacionRealizada que incluya:
 ■ Ladirección del donante.
 ■ Lacantidad de ether donada
 ■ Lafecha de la donación
*/
/*
Funciones del Contrato:
 ○ Unafunción donar() que permita a los usuarios enviar ether al contrato.
 ○ Unafunción obtenerDonaciones() que retorne el total de donaciones
 realizadas y el número de donantes únicos.
*/

contract Grants{
    
    event DoneGrant(address indexed donante, uint256 cantidad, uint256 fecha);
    
    mapping (address => uint256 _balance) public balance; //total donado por cada dirección

    struct Grant{
        address donante; //dirección del donante.
        uint cantidad; //cantidad de ether donada.
        uint fecha; //fecha de la donación.
    }

    Grant[] public grants; //almacena las donaciones al contract - accedo x indice

    address[] public uniqueAddress; //almacena direcciones de donantes - accedo x indice

    address public owner; //para el modifier
    constructor(){
        owner = msg.sender; //seteo owner
    }

    function donar() external payable { //acepta ether
        address _sender = msg.sender; //para no acceder tantas veces a las mismas var
        uint256 _grant = msg.value;
        uint256 _date = block.timestamp;

        grants.push(Grant(_sender, _grant, _date)); //nuevo registro en el array de donaciones- (address, cantidad, fecha).
        if(balance[_sender] == 0){
            uniqueAddress.push(_sender); //cuando alguien dona, si su bal=0, lo agrego al listado de donantes
        }
        balance[_sender] += _grant; //Actualizar el mapping para reflejar el total donado por el donante.
        emit DoneGrant(_sender, _grant, _date);
    }

    function obtenerDonaciones() external view returns (Grant[] memory _grants){
        uint256 len = uniqueAddress.length;
        
        for(uint256 i=0; i<len; i++){
           _grants[i] = Grant(uniqueAddress[i], balance[uniqueAddress[i]], block.timestamp); //donante, donacion, fecha  
           
        }
                 
        return _grants;
    }

    modifier onlyOwner(){
        require(msg.sender == owner, "Ud. no tiene permisos para retirar");    
        _;
    }

    function retirarFondos() external onlyOwner {
        payable(msg.sender).transfer(address(this).balance); 
    }
}

