pragma solidity ^0.5.0;


/* --- Global --- */
import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/cryptography/ECDSA.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";
import "@openzeppelin/contracts/ownership/Ownable.sol";
import "@openzeppelin/contracts/access/Roles.sol";

contract ATM is Ownable {

    /* -------------------------------------- */
    // Libraries
    /* -------------------------------------- */
    using ECDSA for bytes32;
    using SafeMath for uint256;
    using Roles for Roles.Role;
    /* -------------------------------------- */
    // Variables
    /* -------------------------------------- */
    /* --- Variables : Public --- */
    mapping (bytes32 => bool) public certificateClaimed;
    mapping (address => mapping (address => bool)) public delegates;

    /* --- Variables : Private --- */
    Roles.Role private _delegate;

    /* -------------------------------------- */
    // Public : Functions
    /* -------------------------------------- */

    constructor (
        address _issuer
    ) public {
        _delegate.add(_issuer);
    }

    /// Redeem
    function redeem(
        address _from,
        address _erc20,
        uint256 _amount,
        uint256 _nonce,
        bytes calldata _signature)
        external
    {
        // Recreate hash from params
        bytes32 certHash = getCertificateHash(_amount, msg.sender, _from, _erc20, _nonce);

        // Verify signature is valid for the hash
        // require(_verifySignature(certHash, _signature, _from), "Certificate Signature Not Valid");
        require(verifyCertificate(_from, msg.sender, _erc20, _amount, _signature, _nonce), "Certificate Signature Not Valid");
        // Verify that certificate is not already claimed
        require(!certificateClaimed[certHash], "Certificate already claimed");

        // Mark Claimed and transfer to recipient
        certificateClaimed[certHash] = true;
        IERC20 ERC20 = IERC20(_erc20);
        require(ERC20.transferFrom(_from, msg.sender, _amount), "Transfer Failed");
    }

    function addDelegate(address _issuer) external onlyOwner {
        _delegate.add(_issuer);
    }
    
    function removeDelegate(address _issuer) external onlyOwner {
        _delegate.remove(_issuer);
    }

    /* -------------------------------------- */
    // Internal : Functions
    /* -------------------------------------- */

    // Verify Signature
    function _verifySignature(
        bytes32 _hash,
        bytes memory _signature,
        address _from)
        internal view returns (bool)
    {
        address signer = _hash.toEthSignedMessageHash().recover(_signature);
        if (signer == _from) {
            return true;
        }
        return delegates[_from][signer];
    }

    /* -------------------------------------- */
    // View : Functions
    /* -------------------------------------- */

    /// Create Unsigned Certificate Hash
    function getCertificateHash(
        uint256 _amount,
        address _recipient,
        address _holder,
        address _erc20,
        uint256 _nonce)
        public view returns (bytes32)
    {
        return keccak256(abi.encodePacked(address(this), _amount, _recipient, _holder, _erc20, _nonce));
    }

    // Verify Certificate
    function verifyCertificate(
        address _from,
        address _recipient,
        address _erc20,
        uint256 _amount,
        bytes memory _signature,
        uint256 _nonce)
        public view returns (bool)
    {
        bytes32 certHash = getCertificateHash(_amount, _recipient, _from, _erc20, _nonce);
        return _verifySignature(certHash, _signature, _from);
    }
}