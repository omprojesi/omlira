
pragma solidity ^0.6.0;

import "./ERC20/ERC20Capped.sol";
import "./ERC20/ERC20Burnable.sol";
import "./ERC1363/ERC1363.sol";
import "./access/Roles.sol";
import "./TokenRecover.sol";



/**
 * Part of the code written below was work of Vittorio Minacori
 * https://github.com/vittominacori
 */
 
 

/**
 * @title OM Lira
 * @author Osman Kuzucu (https://omlira.com)
 * @dev Implementation of the BaseToken for OM Lira
 */
 

contract OMLira is ERC20Capped, ERC20Burnable, ERC1363, Roles, TokenRecover {

    // indicates if minting is finished
    bool private _mintingFinished = false;

    // indicates if transfer is enabled
    bool private _transferEnabled = false;
    
    string public constant OLUSTURAN = "omlira.com - OM Lira";
    string public constant _imza = "Yerli ve milli teknoloji guclu Turkiye";



    /**
     * @dev Emitted during finish minting
     */
    event MintFinished();

    /**
     * @dev Emitted during transfer enabling
     */
    event TransferEnabled();
    
    /**
     * @dev Tokens can be minted only before minting finished.
     */
    modifier canMint() {
        require(!_mintingFinished, "OMLira: token basimi tamamlandi");
        _;
    }

    /**
     * @dev Tokens can be moved only after if transfer enabled or if you are an approved operator.
     */
    modifier canTransfer(address from) {
        require(
            _transferEnabled || hasRole(OPERATOR_ROLE, from),
            "OMLira: transfer aktif degil ya da OPERATOR yetkisine sahip degilsiniz."
        );
        _;
    }


    constructor()
        public
        ERC20Capped()
        ERC1363()
    {
        

        _setupDecimals(18);

        
        _mint(owner(), 1000000000000000000000000000);
        finishMinting();
        
    }


    

    /**
     * @dev Function to mint tokens.
     * @param to The address that will receive the minted tokens
     * @param value The amount of tokens to mint
     */
    function mint(address to, uint256 value) public canMint onlyMinter {
        _mint(to, value);
    }

    /**
     * @dev Transfer tokens to a specified address.
     * @param to The address to transfer to
     * @param value The amount to be transferred
     * @return A boolean that indicates if the operation was successful.
     */
    function transfer(address to, uint256 value) public virtual override(ERC20) canTransfer(_msgSender()) returns (bool) {
        return super.transfer(to, value);
    }

    /**
     * @dev Transfer tokens from one address to another.
     * @param from The address which you want to send tokens from
     * @param to The address which you want to transfer to
     * @param value the amount of tokens to be transferred
     * @return A boolean that indicates if the operation was successful.
     */
    function transferFrom(address from, address to, uint256 value) public virtual override(ERC20) canTransfer(from) returns (bool) {
        return super.transferFrom(from, to, value);
    }

    /**
     * @dev Function to stop minting new tokens.
     */
    function finishMinting() public canMint onlyOwner {
        _mintingFinished = true;

        emit MintFinished();
    }

    /**
     * @dev Function to enable transfers.
     */
    function enableTransfer() public onlyOwner {
        _transferEnabled = true;

        emit TransferEnabled();
    }
    
    /**
     * @dev Function to disable transfers if required.
     */
    function disableTransfer() public onlyOwner {
        _transferEnabled = false;
        
        emit TransferEnabled();
    }

    /**
     * @dev See {ERC20-_beforeTokenTransfer}.
     */
    function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override(ERC20, ERC20Capped) {
        super._beforeTokenTransfer(from, to, amount);
    }
}