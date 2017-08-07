pragma solidity ^0.4.10;

contract OneContract {



	address[] public addr;
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

	string name;
	uint balance;
	bool accessStatus;
	bool getDockAccess;
	//string role;
	address userAddress;
    	uint owners;
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
//retrieve objects based on address 
 function retrieveObjDetails() returns(string, string, string)
 {



                                                       //if(users[msg.sender].role==)

	uint length = objects[msg.sender].length;
    
return (objects[msg.sender][length-1].objname,objects[msg.sender][length-1].locTo,objects[msg.sender][length-1].locFrom); 


 }




/*function boxInTransit() returns(bool)
{
//boo=false;
return boo;

}*/



// register a user
 function registerUser(string name, uint owner) returns(address,uint,string)
 {
	
	uint i=0;
	User memory user;
	user.name=name;
	//user.role=role;
	bool flag; //to check for duplicates in addr array
	string memory boolliteral;
	
	if(owner==1)
	{
	   boolliteral="true";
	   user.owners=1;
	   user.getDockAccess=true;
	   user.accessStatus=true;
	}
	
	if(owner==0)
	{
	   boolliteral="false";
	   user.owners=0; //means the person is a helper.
	   user.getDockAccess=true;
	   user.accessStatus=false;
	}
	
	user.userAddress=msg.sender;
	//uint length=user.object.length;	
		

	//to decide whether to keep only owner addresses or not.
	if(addr.length==0)
	addr.push(msg.sender);
	
	while(i<addr.length)
	{
	 if(addr[i]==msg.sender)
	{flag=true;}
	i++;	
       }
	if(flag==false)
	addr.push(msg.sender);// adds only unique users to the addr array

	users[msg.sender].push(user);
	return (user.userAddress, user.owners, boolliteral);// returns the addres

 }


//retrieve the details of the user
 function retrieveUserDetails(address addr) returns(string,uint,uint)
 {
   uint length = users[msg.sender].length;
   string memory info1;
   uint info2;
 
    for (uint i = 0; i < length; i++){
    if (addr == users[msg.sender][i].userAddress) {
  	     info1= users[msg.sender][i].name;
         info2= users[msg.sender][i].owners;
      }
	  else
	  {
	     info1="loser";
	  }
   }

    return (info1, info2,length);

	
 }
  

function showallobj() returns(address[])
{

return addr;

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
