pragma solidity ^0.4.10;

contract OneContract {

//bytes32 public objHash;

struct Object{

	string objname;
	uint objid;
	string locTo;
	string locFrom;
	bool delivered;
	bool inTransit;
	
	
  }


  struct User{

	bytes32 name;
	uint balance;
	bool accessStatus;
	bool getDockAccess;
	bytes32 role;
	address userAddress;

             }

  



 //User[] public usEr;
 mapping (address => User[]) public users;// mapping address to User
 mapping (address => Object[]) public objects;
 //Object[] public obJect;

 
 //Function to add objects into the system, a user can add more than one item.
 
 function addObject(address owaddr,string objNaame,string locto,string locfrom) returns(bool)
  {
	Object memory object;
	object.objname=objNaame;
	object.locTo=locto;
	object.locFrom=locfrom;
	object.delivered=false;
	object.inTransit=false;
	object.objid=objects[msg.sender].length+1;
	objects[msg.sender].push(object);
	return true;


  }
//retrieve objects
 function retrieveObjDetails() returns(string, string, string)
 {
//if(users[msg.sender].role==)

	uint length = objects[msg.sender].length;
    
return (objects[msg.sender][length-1].objname,objects[msg.sender][length-1].locTo,objects[msg.sender][length-1].locFrom); 


 }

// register a user
 function registerUser(bytes32 name, bytes32 role) returns(address)
 {
	

	User memory user;
	user.name=name;
	user.role=role;
	user.userAddress=msg.sender;
	//uint length=user.object.length;
	
	users[msg.sender].push(user);
	return user.userAddress;// returns the addres

 }


//retrieve the details of the user
 function retrieveUserDetails(address addr) returns(bytes32,bytes32)
 {
	uint length = users[msg.sender].length;
   bytes32 info1;
   bytes32 info2;
 
    for (uint i = 0; i < length; i++){
    if (addr == users[msg.sender][i].userAddress) {
  	 info1= users[msg.sender][i].name;
         info2= users[msg.sender][i].role;
      }
   }

    return (info1, info2);

	
 }
  




/*function hashObj(string name) returns (bytes32){


	objHash=sha3(name);
	return objHash;

}*/


/*function bytes32ToString(bytes32 x) constant returns (string) 
{ 
	bytes memory bytesString = new bytes(32); 
	uint charCount = 0; 
	for (uint j = 0; j < 32; j++) 
	{ 
		byte char = byte(bytes32(uint(x) * 2 ** (8 * j))); 
		if (char != 0)
		 {
			bytesString[charCount] = char;
			charCount++; 
		 }
 	} 
	bytes memory bytesStringTrimmed = new bytes(charCount);
 	for (j = 0; j < charCount; j++) 
	{ 
		bytesStringTrimmed[j] = bytesString[j];
 	}
 	
return string(bytesStringTrimmed); 
}

*/



}
