pragma solidity ^0.4.18;
contract SafeRide {
    address _creator;
     int[] _GPSTrace;
    function GPS_Trace() public view returns (int[])
    {
        return _GPSTrace;
    }

    uint _password;
    uint _fakePassword;
     string _licensePlate;
    function License() public view returns (string)
    {
        return _licensePlate;
    }
    uint _friendsPassword;
    bool _isBounty;
    function IsBountyActive() public view returns (bool)
    {
        return _isBounty;
    }
     uint _lastUpdatedTime;
    function LastUpdatedTime() public view returns (uint)
    {
        return _lastUpdatedTime;
    }
    //address _friend;
	
	
	event Alart(int[] GPSTrace, string licensePlate, uint friendsPassword, uint lastUpdatedTime);

//    modifier onlyOwner(){    if (msg.sender != _creator) revert();}

    modifier onlyOwner() {
        require(msg.sender == _creator);
        _;
    }

    constructor (uint password, string licensePlate/*, address friend*/) payable public
    {
        //load bounty here
        _creator = msg.sender;
        _password=password;
        _licensePlate=licensePlate;
        _friendsPassword= 234234;
        //int x=(abi.encodePacked(now));// 234234;//some random number;
        _isBounty=false;
        //_friend=friend;
    }
    
    
    function getTime ( ) view private /*public*/ returns (uint )
    {
        return now;
    }
    

    function closeContract() onlyOwner payable external
    {
        RewardMsgSender();
        _GPSTrace=new int[](0);
        _licensePlate="";
    }

    function claimBounty(uint password) payable external returns (bool)
    {
        if (!_isBounty) return false;

        if(password == _fakePassword)
        {
            return true;
        }
        else if(password == _password)
        {
            //delay one day 
            RewardMsgSenderLater();
            return true;
        }
        else
        {
            return false;
        }
    }
    
    function RewardMsgSenderLater()  private
    {
        msg.sender.transfer(address(this).balance);
    }


    function RewardMsgSender()  private
    {
        msg.sender.transfer(address(this).balance);
    }

    function updateGPS(int longitude, int latitude) onlyOwner public
    {
        //append gps info
        _GPSTrace.push(longitude);
        _GPSTrace.push(latitude);

        _lastUpdatedTime= now;//nowtime;
    }

    function updateIsAlive()  public
    {
        if (!IsGpsUpdated())
        {
            notifyFriends();
        }
    }

    function IsGpsUpdated() view public returns (bool)
    {
        uint deltaTime= now - _lastUpdatedTime;
        return deltaTime < 1*60; //1min;
    }

    function notifyFriends()  private
    {
        emit Alart(_GPSTrace, _licensePlate, _friendsPassword, _lastUpdatedTime);
        // return licensePlate and GPS trace, and friendsPassword;
    }


    function triggerBounty(uint friendsPassword) payable public
    {
        if (friendsPassword != _friendsPassword) revert();
        
        _isBounty=true;
    }
    
    
    function getContractBalance() public view returns (uint)
    {
        return address(this).balance;
    }
    
}
