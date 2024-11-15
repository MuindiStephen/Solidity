// SPDX-License-Identifier: GPL-3.0
// Solidity smart contract to manage farm produce
pragma solidity >=0.4.22 <0.9.0;

contract ProduceManager {
    struct Produce {
        string name;
        uint quantity;
        uint price;
    }
    Produce[] public produceList;

    function addProduce(string memory _name, uint _quantity, uint _price) public {
        produceList.push(Produce(_name, _quantity, _price));
    }

    function getProduce(uint _index) public view returns (string memory, uint, uint) {
        Produce memory produce = produceList[_index];
        return (produce.name, produce.quantity, produce.price);
    }

    function totalProduce() public view returns (uint) {
        return produceList.length;
    }
}
