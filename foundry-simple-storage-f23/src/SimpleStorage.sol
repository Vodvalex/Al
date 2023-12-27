// SPDX-License-Identifier: MIT
pragma solidity 0.8.18; //this is our version

contract SimpleStorage {
    //Basic data types: boolean,address,bytes,uint,int
    uint256 public favoriteNumnber;
    //0 favorite number initilize through 0 if the value is not given
    //otherwise shuld be uint favoriteNumber=6 for instance

    uint256 myFavoriteNumber; //0

    //uint256[] listofFavoriteNumbers; //[0,78,90]

    struct Person {
        uint256 favoriteNumber;
        string name;
    }

    // Person public pat= Person({favoriteNumber:7, name: 'Pat'});
    //Person public mariah= Person({favoriteNumnber:16, name: 'Mariah'});

    //dynamic array,static array

    Person[] public listofPeople; //list of people
    mapping(string => uint256) public nameToFavoriteNumber;

    //Functions
    //virtual means this function is overidable in case you want to overide it

    function store(uint256 _favoriteNumber) public virtual {
        favoriteNumnber = _favoriteNumber;
    }

    //view,pure.View disallow updating state and reading from storage.

    function retrieve() public view returns (uint256) {
        return myFavoriteNumber;
    }

    //calldata,memory,storage to store data in solidity

    function addPerson(string memory _name, uint256 _favoriteNumber) public {
        listofPeople.push(Person(_favoriteNumber, _name));
        nameToFavoriteNumber[_name] = _favoriteNumber;
    }
}
