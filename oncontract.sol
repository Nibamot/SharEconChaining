pragma solidity ^0.4.10;

contract OneContract {

  struct User{
	string name;
	uint balance;
	bool accessStatus;
	bool getDockAccess;
	string role;
	address userAddress;
	
  }

 User[] public usEr;
 mapping (address=> User) public users;


 function registerUser(string name, string role) returns(bool)
 {
	User memory user;
	user.name=name;
	user.role=role;
	user.userAddress=msg.sender;
	usEr.push(user);
	return true;

 }


// function retrieveDetails(string locto) returns(string)
 //{
//	return usEr.name;
	
 //}
 function OneContract(){

 } 


}


