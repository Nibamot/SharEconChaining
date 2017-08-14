pragma solidity ^0.4.10;

contract OneContract {


mapping(address => uint) balanceOf;
address[] public addr;
bytes32 public regionHash;
//bytes32 public objHash;
 
 struct Box{

	uint boxId;
	string locTo;
	string locFrom;
	uint delivered;
	uint inTransit;
	uint inUse; 
	uint getDockAccess;
	uint accessStatus;//0-- no access &no lights   1--access and no lights 2--only lights 3--both/dock access
    address senderAddr;
	uint price;
	string name;
	
  }


  struct User{

	address userAddress;
	string name;
    uint owners;
	string password;
            
			}


 mapping (address => User[]) public users;// mapping address to User
 mapping (bytes32 => Box[]) public boxes;
 
 
 //Function to add objects into the system, a user can add more than one item.
 // from arduino(box)
 function addBox(string region) returns (uint, string, uint)
 {
	regionHash=sha3(region);
	Box memory box;
	box.boxId=boxes[regionHash].length+1;
	box.locFrom=region;
	//not adding delivered, intransit and inuse flags to check
	boxes[regionHash].push(box);
	return (box.boxId, box.locFrom, box.inUse);
  
  }
 
 function deleteBox(string region, uint boxid)returns (bool)
 {
  regionHash=sha3(region);
  boxes[regionHash][boxid-1].inUse=1;
  return true;
 }
 //to locate the box.. from the app
 function locateBox(string region) returns (uint, bool)
 {
   bytes32 regionHash=sha3(region);
   uint length= boxes[regionHash].length;
   uint i=0;
   
   while(i<length)
	{
	if(boxes[regionHash][i].inUse==0)
	{
	boxes[regionHash][i].accessStatus=3;// access and lights
	return (boxes[regionHash][i].boxId,true);
	}else
	i++;
    }
 return(0,false);
 }
 
 //lock unlock and lights
 function lockUnlock(string region,uint boxid) returns (bool)
 {
   regionHash=sha3(region);
  boxes[regionHash][boxid-1].accessStatus=3;
  return true; 
 }
 
 
 //sent from arduino: to prompt map on the appupon closing 
 function promptMap(string regionfrom, uint boxid,uint inuse) returns (bool)
 {
   regionHash=sha3(regionfrom);
  boxes[regionHash][boxid-1].inUse=1;
  return true;
 }
 
 // sent from the app: function to set other parameters like location to, price, sender, accessStatus to locked.
 function setParameters(string regionfrom, uint boxid,string regionto, uint price ) returns (bool)
{
 regionHash=sha3(regionfrom);
 boxes[regionHash][boxid-1].locTo=regionto;
 boxes[regionHash][boxid-1].price=price;
 boxes[regionHash][boxid-1].senderAddr=msg.sender;
 boxes[regionHash][boxid-1].inUse=1;
 boxes[regionHash][boxid-1].delivered=0;
 boxes[regionHash][boxid-1].inTransit=0;
 boxes[regionHash][boxid-1].accessStatus=0;
 return true;

} 

//sent from transporters app: checks for the closest boxes that are nearby
function checkboxesAround (string region) returns (uint, uint, bytes32,uint)
{
    regionHash=sha3(region);
   uint length= boxes[regionHash].length;
   uint i=0;
   uint k=0;
   uint[10] memory pricearray;
   bytes32[10] memory regiontoarray;
   uint[10] memory boxidarray;   
   while(i<length)
	{
	 if(boxes[regionHash][i].inUse==1 && boxes[regionHash][i].delivered==0 && boxes[regionHash][i].inTransit==0)
	{
	 pricearray[k]=boxes[regionHash][i].price;
	 regiontoarray[k]=stringToBytes32((boxes[regionHash][i].locTo));
	 boxidarray[k]=boxes[regionHash][i].boxId;
	 boxes[regionHash][i].accessStatus=2;// only lights
	 boxes[regionHash][i].getDockAccess=1;
     k++;
	 
	}
	else
	 i++;
	 
	return (boxes[regionHash][i].boxId,pricearray[k-1],regiontoarray[k-1],boxidarray[k-1]); 
    }
 return(0,pricearray[0],regiontoarray[0],boxidarray[0]);

} 
 
 function stringToBytes32(string memory source) returns (bytes32 result) {
    assembly {
        result := mload(add(source, 32))
    }
	
	return result;
}
 //call from the transporter app to cumulus to locate the box
function transporterLocateBox(uint boxid, string region,string name,string pass) returns (bool)
{
    regionHash=sha3(region);
   uint length= boxes[regionHash].length;
   uint i=0;
   boxes[regionHash][boxid-1].accessStatus=2;
   boxes[regionHash][boxid-1].getDockAccess=1;
   //boxes[regionHash][boxid-1].name=name;
   //boxes[regionHash][boxid-1].password=pass;
   return true;
}  

//call from the arduino to let cumulus know that box is in transit
function boxOnTheMove(string region, uint boxid) returns(bool)
{
  regionHash=sha3(region);
 boxes[regionHash][boxid-1].inTransit=1; 
 return true;
}

//call from arduino to check if the box is in transitor not
function checkInTransit(string region, uint boxid) returns(bool)
 {
    regionHash=sha3(region);
  
   if(boxes[regionHash][boxid-1].inTransit==1 && boxes[regionHash][boxid-1].delivered==0) 
    
	return true;
   else
     return false;
 }

 //function from the arduino to get the transporter details to call transfer done
function getTransporterDetails(string region, uint boxid) returns (bool, string, string)
{
  regionHash=sha3(region);
 string name=boxes[regionHash][boxid-1].name;
 //string password=boxes[regionHash][boxid-1].password;
 
 return (true, name, 'secret');
}

//sent by the dock(Arduino) to announce homecoming of package 
function transferDone(string region, uint boxid) returns (bool)
	{
	 regionHash=sha3(region);
	boxes[regionHash][boxid-1].delivered=1;
	boxes[regionHash][boxid-1].inTransit=0;
	transferTokens(regionHash,msg.sender, boxes[regionHash][boxid-1].price, boxid);
	return true;
	
	
	}
 //real function to transfer tokens
 function transferTokens(bytes32 regionHash, address recipient, uint value, uint boxid) returns (bool) {
    	
    
 // Check if the sender has enough money.
		if (balanceOf[boxes[regionHash][boxid-1].senderAddr] < value) {
			return false;
		}

		// Check for overflows.
		if (balanceOf[recipient] + value < balanceOf[recipient]) {
			return false;
		}

		balanceOf[recipient] += value; // Add the same to the recipient.
		balanceOf[boxes[regionHash][boxid-1].senderAddr] -= value; // Subtract from the sender.
		
		return true;
	}

 // called from app of any user(sender or transporter) 
 function checkMyBalance()returns(uint)
 {
 return balanceOf[msg.sender];
  }
 
 
 //Reset the box to the place it has been sent to
function resetBox(string region, uint boxid) returns(bool)
{
 regionHash=sha3(region);
 string newregion=boxes[regionHash][boxid-1].locTo;
 addBox(newregion);
 return true;

} 


// from the user's app:  register a user
 function registerUser(string name, uint owner, string pass) returns(address,uint,string)
 {
	
	uint i=0;
	User memory user;
	user.name=name;
	user.password=pass;
	balanceOf[msg.sender]=1000;
	//user.role=role;
	bool flag; //to check for duplicates in addr array
	string memory boolliteral;
	
	if(owner==1)
	{
	   boolliteral="true";
	   user.owners=1;
	   
	}
	
	if(owner==0)
	{
	   boolliteral="false";
	   user.owners=0; //means the person is a helper.
	   
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







}
