pragma solidity 0.8.27;

//import {Test, console} from "forge-std/Test.sol";
import "./ChristmasDinner.sol";
import {ERC20Mock} from "../node_modules/@openzeppelin/contracts/mocks/token/ERC20Mock.sol";


interface IHevm {
    function snapshot() external returns (uint256);
    function revert(uint256) external;
    function startPrank(address) external; 
    function stopPrank() external; 
    function warp(uint x) external;
    }

contract Echidna {

    address constant HEVM_ADDRESS = 0x7109709ECfa91a80626fF3989D68f67F5b1DD12D;
    IHevm hevm = IHevm(HEVM_ADDRESS);
    ChristmasDinner cd;
    ERC20Mock wbtc;
    ERC20Mock weth;
    ERC20Mock usdc;
    
    uint256 constant DEADLINE = 7;
    
    address constant deployer = address(uint160(0x3));
    address user1 = address(uint160(0x4));
    address user2 = address(uint160(0x5));
    address user3 = address(uint160(0x6));

    constructor(){
    
        wbtc = new ERC20Mock();
        weth = new ERC20Mock();
        usdc = new ERC20Mock();
        hevm.startPrank(deployer);
        cd = new ChristmasDinner(address(wbtc), address(weth), address(usdc));
        hevm.warp(1);
        cd.setDeadline(DEADLINE);
        hevm.stopPrank();
       
        _makeParticipants();

    }
    /* function echidna_tryResettingDeadlineAsHost() external{
        hevm.startPrank(deployer);
        cd.setDeadline(8 days);
        hevm.stopPrank();
     //   assert(DEADLINE == 7 days);
    } */

     function test_participationStatusBeforeDeadline() public {
        hevm.startPrank(user1);
        //weth.safeTransfer();
        cd.deposit(address(weth), 1e18);
        assert(cd.getParticipationStatus(user1) == true);
        cd.changeParticipationStatus();
        assert(cd.getParticipationStatus(user1) == false);
    }

    function test_hostChange() external {
        hevm.startPrank(user2);
        cd.deposit(address(weth), 1e18);
        cd.changeHost(user2);
        address x = cd.getHost();

        assert(x == user1);
    }

    function _makeParticipants() internal {
        //user1 = makeAddr("user1");
        wbtc.mint(user1, 2e18);
        weth.mint(user1, 2e18);
        usdc.mint(user1, 2e18);
        hevm.startPrank(user1);
        wbtc.approve(address(cd), 2e18);
        weth.approve(address(cd), 2e18);
        usdc.approve(address(cd), 2e18);
        hevm.stopPrank();
       // user2 = makeAddr("user2");
        wbtc.mint(user2, 2e18);
        weth.mint(user2, 2e18);
        usdc.mint(user2, 2e18);
        hevm.startPrank(user2);
        wbtc.approve(address(cd), 2e18);
        weth.approve(address(cd), 2e18);
        usdc.approve(address(cd), 2e18);
        hevm.stopPrank();
        //user3 = makeAddr("user3");
        wbtc.mint(user3, 2e18);
        weth.mint(user3, 2e18);
        usdc.mint(user3, 2e18);
        hevm.startPrank(user3);
        wbtc.approve(address(cd), 2e18);
        weth.approve(address(cd), 2e18);
        usdc.approve(address(cd), 2e18);
        hevm.stopPrank();
    }
   

  
}