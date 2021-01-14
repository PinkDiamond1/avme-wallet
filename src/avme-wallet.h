// Aleth: Ethereum C++ client, tools and libraries.
// Copyright 2015-2019 Aleth Authors.
// Licensed under the GNU General Public License, Version 3.
/// @file
/// CLI module for key management.
#ifndef AVME_WALLET_H
#define AVME_WALLET_H

#include <atomic>
#include <chrono>
#include <fstream>
#include <iosfwd>
#include <iostream>
#include <string>
#include <thread>
#include <vector>

#include <boost/algorithm/string.hpp>
#include <boost/algorithm/string/trim_all.hpp>
#include <boost/filesystem.hpp>
#include <boost/thread.hpp>
#include <boost/lexical_cast.hpp>

#include <libdevcore/CommonIO.h>
#include <libdevcore/FileSystem.h>
#include <libdevcore/LoggingProgramOptions.h>
#include <libdevcore/SHA3.h>
#include <libethcore/KeyManager.h>
#include <libethcore/TransactionBase.h>

#include <json_spirit/JsonSpiritHeaders.h>

#include "network.h"
#include "json.h"

using namespace dev;
using namespace dev::eth;
using namespace boost::algorithm;
using namespace boost::filesystem;

class BadArgument: public Exception {};

// Struct for account data
typedef struct WalletAccount {
  std::string id;
  std::string privKey;
  std::string name;
  std::string address;
  std::string hint;
  std::string balanceETH;
  std::string balanceTAEX;
} WalletAccount;

// Struct for raw transaction data
typedef struct WalletTxData {
  std::string hex;
  std::string type;
  std::string code;
  std::string to;
  std::string from;
  std::string data;
  std::string creates;
  std::string value;
  std::string nonce;
  std::string gas;
  std::string price;
  std::string hash;
  std::string v;
  std::string r;
  std::string s;
} WalletTxData;

class WalletManager {
  private:
    // The proper wallet
    KeyManager wallet;

  public:
    // Set MAX_U256_VALUE for error handling.
    u256 MAX_U256_VALUE();

    /**
     * Load and authenticate a wallet from the given paths.
     * Returns true on success, false on failure.
     */
    bool loadWallet(path walletFile, path secretsPath, std::string walletPass);

    /**
     * Create a new wallet, which should be loaded manually afterwards.
     * Returns true on success, false on failure.
     */
    bool createNewWallet(path walletFile, path secretsPath, std::string walletPass);

    /**
     * Create a new Account in the given wallet and encrypt it.
     * An Account contains an ETH address and other stuff.
     * See https://ethereum.org/en/developers/docs/accounts/ for more info.
     * Returns a struct with the account's data.
     */
    WalletAccount createNewAccount(
      std::string name, std::string pass, std::string hint, bool usesMasterPass
    );

    /**
     * Hash a given phrase to create a new address based on that phrase.
     * It's easier to hash since hashing creates the 256-bit variable used by
     * the private key.
     */
    void createKeyPairFromPhrase(std::string phrase);

    /**
     * Erase an Account from the wallet.
     * The Account will only be erased if it's completely empty (no ETH and no
     * token amounts), otherwise it fails.
     * Returns true on success, false on failure.
     */
    bool eraseAccount(std::string account);

    /**
     * Check if an Account is completely empty (no ETH and no token amounts).
     * Returns true on success, false on failure.
     */
    bool accountIsEmpty(std::string account);

    /**
     * Select the appropriate Account name or address stored in KeyManager
     * from user input string.
     * Returns the proper address in Hex (without the "0x" part), or an empty
     * address on failure.
     */
    Address userToAddress(std::string const& input);

    /**
     * Load the secret key for a given address in the wallet.
     * Returns the proper Secret, or aborts the program on failure.
     */
    Secret getSecret(std::string const& address, std::string pass);

    /**
     * Create a key from a random string of characters.
     * Check FixedHash.h for more info.
     * Returns a private/public key pair.
     */
    KeyPair makeKey();

    /**
     * Convert a full Wei amount to a fixed point ETH amount and vice-versa.
     * BTC has 8 decimals but is considered a full integer in code, so 1.0 BTC
     * actually means 100000000 satoshis.
     * Likewise with ETH, which has 18 digits, so 1.0 ETH actually means
     * 1000000000000000000 Wei.
     * Operations are actually done with the full amounts in Wei, but to make
     * those operations more human-friendly, we show to/collect from the user
     * fixed point values, and convert those to Wei and back as required.
     * Returns the fixed point and full amounts of ETH/Wei, respectively.
     */
    std::string convertWeiToFixedPoint(std::string amount, size_t digits);
    std::string convertFixedPointToWei(std::string amount, int decimals);

    /**
     * List the wallet's Accounts and their ETH and token balances.
     * ETH balances are checked in batches of up to 20.
     * ERC-20 tokens need to be loaded in a different way, from their proper
     * contract address, beside their respective wallet address. Plus, due
     * to API limitations, only one can be checked at a time.
     * Returns a list of accounts and their ETH/token amounts, respectively.
     */
    std::vector<WalletAccount> listETHAccounts();
    std::vector<WalletAccount> listTAEXAccounts();

    /**
     * Get the recommended amount of fees for a transaction.
     * Returns the amount in Gwei.
     */
    std::string getAutomaticFee();

    /**
     * Build transaction data to send ERC-20 tokens.
     * Returns a string with said data.
     */
    std::string buildTxData(std::string txValue, std::string destWallet);

    /**
     * Build an ETH or token transaction from user data.
     * Returns a skeleton filled with data for an ETH/token transaction,
     * respectively, which has to be signed.
     */
    TransactionSkeleton buildETHTransaction(
      std::string srcAddress, std::string destAddress,
      std::string txValue, std::string txGas, std::string txGasPrice
    );
    TransactionSkeleton buildTAEXTransaction(
      std::string srcAddress, std::string destAddress,
      std::string txValue, std::string txGas, std::string txGasPrice
    );

    /**
     * Sign a transaction with user credentials.
     * Returns a string with the raw signed transaction in Hex.
     */
    std::string signTransaction(
      TransactionSkeleton txSkel, std::string pass, std::string address
    );

    /**
     * Send a signed transaction for processing.
     * Returns a link to the transaction in the blockchain.
     */
    std::string sendTransaction(std::string txidHex);

    /**
     * Decode a raw transaction in Hex.
     * Returns a structure with the transaction's data.
     */
    WalletTxData decodeRawTransaction(std::string rawTxHex);
};

#endif // AVME_WALLET_H

