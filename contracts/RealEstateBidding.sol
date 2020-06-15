//SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

import "./ERC721.sol";

contract RealEstateBidding is ERC721 {
    address public realtor;
    uint public propertyID;
    uint public highestBid;
    bool private beginBidding;
    address public winner;
    
    struct CounterStruct{
        uint setProperty;
        uint bidderCount;
    }
    
    struct Bidder {
        address addr;
        uint bidAmount;
    }
    
    mapping(address => Bidder) bidderDetails;
    
    Bidder[5] bidders;
    
    CounterStruct internal counters;
    
    constructor() ERC721("RealEstateBidding","REB") public payable {
        realtor = msg.sender;
        counters.setProperty = 0;
        counters.bidderCount = 0;
        highestBid = 0;
        beginBidding = false;
    }

    function mint(uint propID) public {
 
        _mint(msg.sender, propID);
        
    }
    
    modifier onlyRealtor {
        require(
            msg.sender == realtor,
            "Only realtor can call this function."
        );
        _;
    }
    
    function setPropertyID(uint id) public onlyRealtor {
        require(counters.setProperty == 0, "Property has already been set");
        counters.setProperty++;
        propertyID = id;
    }
    
    function register() public payable {
        require(msg.sender != realtor, "Realtor cannot be a bidder");
        require(counters.bidderCount < 5, "Maximum number of bidders have been registered");
        for(uint i = 0; i < 5; i++) {
            require(msg.sender != bidders[i].addr,"Bidder has already registered");
        }
        
        bidders[counters.bidderCount].addr = msg.sender;
        counters.bidderCount++;
        
    }
    
    function initializeBidding() public onlyRealtor {
        beginBidding = true;
    }
    
    function bid(uint amount) public payable{
        require(beginBidding == true, "Bidding has not yet started");
        require(amount > highestBid, "Amount is less than or equal to highest bid");
        bool registered = false;
        for (uint i = 0; i < 5; i++){
            if(bidders[i].addr == msg.sender){
                registered = true;
            }
        }
        require(registered == true, "Bidder is not registered");
        highestBid = amount;
        bidderDetails[msg.sender].bidAmount = amount;
        
    }
    
    function declareWinner() public onlyRealtor returns (address){
        for(uint i = 0; i < 5; i++){
            if(bidders[i].bidAmount == highestBid){
                winner = bidders[i].addr;
            }
        }
        
        return winner;
    }
    
    
    
}